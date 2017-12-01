function [ Ig, bw2, bw3, bw4, bw5, bw6, bw7, mask_em, I_mod, overlay3, overlay4, stats] = uaa_golgiAnalysis( I )
%uaa_golgiAnalysis runs the golgi image analysis
%% define constants
global uaa
% for i=1:length(uaa.handles.ax)
%     cla(uaa.handles.ax(i));
% end

%figures to show
% showfigs=logical([1 1 1 1 1 1 1 1 1 1 1 1]);

%Gaussian Blur Image
G=fspecial('gaussian',[5 5],2);
Ig=imfilter(I,G,'same');
imSize=size(uaa_getCurrentImageFrame);

[spines,dendrite]=watershed2(Ig);
% I4 = I;
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;

stats=watershedStats(spines);

if size(uaa.T.Roi,2)>1
    findClosestRoiPos(stats);
end
% uaa.test.Ispines=Ispines;
% uaa.test.Idendrite=Idendrite;
% uaa.test.stats=stats;


%% set properties for all axes
% axesHandles = uaa.handles.ax;
% Set the axis property to square
% axis(axesHandles,'square','off');


% uaa.test.profile=profile('info');
%%


    function closestPos=findClosestRoiPos(stats)
        for q=2:size(uaa.T.Roi,2)
            roiCenter=[uaa.T.Roi{uaa.currentFrame,q}(1) + ...
                uaa.T.Roi{uaa.currentFrame,q}(3)/2 , ...
                uaa.T.Roi{uaa.currentFrame,q}(2) + ...
                uaa.T.Roi{uaa.currentFrame,q}(4)/2];
            pointDist=pdist2(roiCenter,[stats.Centroid(:,1),stats.Centroid(:,2)]);
            ind=find(pointDist==min(pointDist),1);
            closestPos=stats.BoundingBox(ind,:);
            uaa.T.closestPosRoi{uaa.currentFrame,q}=closestPos;
        end
        
    end

%%
    function stats = watershedStats(spines)
        stats=regionprops(spines,{'Area','Centroid','BoundingBox'});
        uaa.test.stats2=struct2dataset(stats);
        stats=struct2dataset(stats);
        maxArea=imSize(1)*imSize(2);
        maxAreaLogical=stats.Area > (maxArea/4);
        stats=stats(~maxAreaLogical,:); %remove spines with area greater than 1/4 of image
        %         maxAreaInd=find(maxAreaLogical);
        %         spines(ismember(spines,maxAreaInd))=0;
        %         spineBorder=bwperim(spines);
        % %         dendBorder=bwperim(dendrite);
        %         Ispines=I;
        %         Ispines(~spines)=0;
        %         Idendrite=I;
        %         Idendrite(~dendrite)=0;
%         ax=findobj(uaa.handles.ax,'Tag','I_mod');
%         hold(ax,'on');
%         scatter(ax,stats.Centroid(:,1),stats.Centroid(:,2),'r','filled');
%         hold(ax,'off');
    end


    function [spines,dendrite]=watershed2(Ig)
        h=waitbar(0,'Watershed Analysis...');
        
        level=graythresh(Ig);
        M=max(max(Ig)); %maximum value in image
        m=min(min(Ig)); %minimum value in an image
        thresh=(M-m)*level+m; %values below thresh are background
        I2=Ig;
        I2(I2<thresh)=0; %I2 is I with the below-threshold noise removed
        
        
        se=strel('disk',uaa.settings.watershed.tophatDisk);
        waitbar(.1,h,'Tophat...');
        tophatFiltered = imtophat(I2,se);
        waitbar(.2, h,'bw2');
        bw2 = imfill(tophatFiltered,'holes');
        waitbar(.3,h,'bw3...');
        bw3 = imopen(bw2, ones(uaa.settings.watershed.bw3imopen,uaa.settings.watershed.bw3imopen));
        level2=.01;
        waitbar(.4,h,'bw4');
        bw4=im2bw(bw3,level2);
        bw4 = bwareaopen(bw4, uaa.settings.watershed.bw4areaOpen);
        
        % find dendrite
        waitbar(.5,h,'bw5');
        bw5=findDendrite(bw4);
        waitbar(.6,h,'bw6...');
        bw6=imopen(bw4,bw5);
        se2=strel('disk',uaa.settings.watershed.bw6imcloseDisk);
%         bw8=bwmorph(bw8,'erode');
        bw6=imclose(bw6,se2);
        
        %remove dendrite from BW image
        waitbar(.7,h,'bw7...');
        bw7=bw3;
        bw7(bw6)=0;
        bw7=bwareaopen(bw7,uaa.settings.watershed.bw7areaopen);
        
        waitbar(.8,h,'mask_em...');
        bw8=bw3;
        bw8(bw6)=0;
        H=uaa.settings.watershed.imextendedmaxInput/100*max(max(bw8));
        mask_em = imextendedmax(bw8, H);
        mask_em = imclose(mask_em, ones(uaa.settings.watershed.maskImclose,uaa.settings.watershed.maskImclose));
        mask_em = imfill(mask_em, 'holes');
        mask_em = bwareaopen(mask_em, uaa.settings.watershed.maskBwareaopen);
        mask_em = bwmorph(mask_em,'erode');
        
        waitbar(.9,h,'Watershed...');
        I_eq_c = imcomplement(Ig);
        I_mod = imimposemin(I_eq_c, ~bw7 | mask_em);
        L = watershed(I_mod);
        %         bw5(circleMaskTotal)=0;
%         overlay3 = imoverlay(label2rgb(L), bw6, [.3 1 .3]);
        overlay3 = label2rgb(L);
        uaa.test.overlay3=overlay3;
        map=jet(double(max(max(I))));
%         Irgb=ind2rgb(I,map);
        I_eq=adapthisteq(I);
        Lo=imdilate(~L,ones(round(imSize(1:2)/150))); %make sure lines are visible
        overlay4 = imoverlay(I_eq, Lo, [1 0 0]);       
        spines=L;
        dendrite=bw6;
        close(h);
    end

    function BW2 = findDendrite(BW)
        BW2=bwmorph(BW,'thin',Inf);
        seed=false(size(BW2));
        hD=figure; %to monitor progress...
        hDa=axes('Parent',hD);
        for i=1:5

            BW2=bwmorph(BW2,'spur',1); %remove single pixels leftover from enlarged branchpoint image
            BW2=bwmorph(BW2,'thin',Inf);
            BWbranch=bwmorph(BW2,'branchpoints');
%             figure;
%             uaa.test.BW2=BW2;
%             uaa.test.BWbranch=BWbranch;
%             imagesc(BW2);
            BWnoBranch=BW2;
            BWnoBranch(BWbranch)=0;
            BW2end=bwmorph(BW2,'endpoints');
            end2Ind=find(BW2end);
            allDone=1;
            BWbranchDilate=imdilate(BWbranch,ones(3));
            BWnoBranch(BWbranchDilate)=0;
%             figure;
%             imagesc(BWnoBranch);
            imshow(BW2,'Parent',hDa);
            drawnow;
            hWd=waitbar(0,['Findind Dendrites (round ' num2str(i),')']);
            wds=1/length(end2Ind);
            for j=1:length(end2Ind)
                waitbar(j*wds,hWd);
                tempSeed=seed;
                tempSeed(end2Ind(j))=1;
                BWD=bwdistgeodesic(BWnoBranch,tempSeed);
                BWD(isinf(BWD))=0;
                BWD(isnan(BWD))=0;
                bwdMax=max(max(BWD));
                if bwdMax<uaa.settings.watershed.bw5spur
                    BW2(BWD>0)=0;
                    BWnoBranch(BWD>0)=0;
                    BW2(tempSeed==1)=0;
                    allDone=0;
                    imshow(BW2,'InitialMagnification',20,'Parent',hDa);
                    drawnow;
                end
            end
            close(hWd);
            if allDone %if nothing else needs to be removed, finish loop
                break
            end
        end
        BW2=bwareaopen(BW2,uaa.settings.watershed.bw5areaOpen);
        close(hD);
    end

    function textureSegmentation(I)
        nhood = true(9);
        for j=1:3
            switch j
                case 1
                    E = mat2gray(entropyfilt(I));
                case 2
                    E = mat2gray(stdfilt(I,nhood));
                case 3
                    E = rangefilt(I,ones(5));
            end
            %         imagesc(Eim);
            BW1 = im2bw(E, .8);
            %         imagesc(BW1)
            BWao = bwareaopen(BW1,2000);
            %         imagesc(BWao);
            closeBWao = imclose(BWao,nhood);
            %         imagesc(closeBWao)
            roughMask = imfill(closeBWao,'holes');
            %         imagesc(roughMask)
            I2 = I;
            I2(roughMask) = 0;
            %         imagesc(I2);
            E2 = entropyfilt(I2);
            E2im = mat2gray(E2);
            %         imagesc(E2im);
            BW2 = im2bw(E2im,graythresh(E2im));
            %         imagesc(BW2)
            mask2 = bwareaopen(BW2,1000);
            %         imagesc(mask2);
            texture1 = I;
            texture1(~mask2) = 0;
            texture2 = I;
            texture2(mask2) = 0;
            %         imagesc(texture1)
            %         imagesc(texture2)
            boundary = bwperim(mask2);
            segmentResults = I;
            segmentResults(boundary) = max(max(I))+1;
            switch j
                case 1
                    imagesc(segmentResults,'Parent',uaa.handles.ax(3));
                    
                case 2
                    imagesc(segmentResults,'Parent',uaa.handles.ax(4));
                    
                case 3
                    imagesc(segmentResults,'Parent',uaa.handles.ax(5));
                    
            end
            %         imagesc(mat2gray(S));
            %         imagesc(R);
        end
    end

    function perpendicularLines(I)
        nhood = true(9);
        
        E = mat2gray(stdfilt(I,nhood));
        BW1 = im2bw(E, .8);
        BWao = bwareaopen(BW1,2000);
        closeBWao = imclose(BWao,nhood);
        %         imagesc(closeBWao)
        roughMask = imfill(closeBWao,'holes');
        %         imagesc(roughMask)
        I2 = I;
        I2(roughMask) = 0;
        %         imagesc(I2);
        E2 = entropyfilt(I2);
        E2im = mat2gray(E2);
        %         imagesc(E2im);
        BW2 = im2bw(E2im,graythresh(E2im));
        %         imagesc(BW2)
        mask = bwareaopen(BW2,1000);
        
        %         mask = im2bw(I, .01);
        boundary = bwperim(mask);
        %                 imagesc(boundary,'Parent',uaa.handles.ax6);
        boundary(1,:)=0;
        boundary(end,:)=0;
        boundary(:,1)=0;
        boundary(:,end)=0;
        curveBoundary=double(boundary);
        lineCanvas=zeros(size(boundary));
        [R,C]=find(boundary);
        %         imagesc(boundary);
        hold on
        for z=1:length(R)
            D1 = bwdistgeodesic(boundary, C(z), R(z), 'quasi-euclidean');
            D1 = D1 < 15;
            [R2,C2]=find(D1);
            coeffs=polyfit(C2,R2,2);
            curveBoundary(R(z),C(z))=abs(coeffs(1))*10;
            continue
            newLine=drawLine(C(z),R(z),C2,R2,size(lineCanvas));
            se=strel('disk',3);
            newLine=imdilate(newLine,se);
            newLineD1 = bwdistgeodesic(newLine, C(z), R(z), 'quasi-euclidean');
            newLineD1 = newLineD1 < 20;
            lineCanvas=lineCanvas+newLineD1;
            %     plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
            %     plot(fittedX, fittedY2, 'LineWidth', 3);
        end
        
        
        %         lineCanvas(~mask)=0;
        %         lineCanvas=lineCanvas+curveBoundary;
        imshow(curveBoundary,'Parent',uaa.handles.ax(6));
        uaa.test.curveBoundary=curveBoundary;
    end

    function watershed1(Ig)
        
        radRange=[3,15]; %range of radii for finding circles
        
        % Use the Sobel edge masks, |imfilter|, and some simple arithmetic to
        % compute the gradient magnitude.  The gradient is high at the borders of
        % the objects and low (mostly) inside the objects.
        hy = fspecial('sobel');
        hx = hy';
        Iy = imfilter(double(Ig), hy, 'replicate');
        Ix = imfilter(double(Ig), hx, 'replicate');
        gradmag = sqrt(Ix.^2 + Iy.^2);
        % imagesc(gradmag,'Parent',hGradMagax);
        % title('Gradient magnitude (gradmag)','Parent',hGradMagax);
        
        % Opening is an erosion followed by a dilation, while
        % opening-by-reconstruction is an erosion followed by a morphological
        % reconstruction.  Let's compare the two.  First, compute the opening using
        % |imopen|.
        
        se = strel('disk', radRange(1));
        % Io = imopen(I2Gauss, se);
        % figure
        % imagesc(Io), title('Opening (Io)')
        
        Ie = imerode(Ig, se);
        Iobr = imreconstruct(Ie, Ig);
        % figure
        % imagesc(Iobr), title('Opening-by-reconstruction (Iobr)')
        
        % Ioc = imclose(Io, se);
        % figure
        % imagesc(Ioc), title('Opening-closing (Ioc)');
        
        Iobrd = imdilate(Iobr, se);
        Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
        Iobrcbr = imcomplement(Iobrcbr);
        % figure
        % imagesc(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
        
        fgm = imregionalmax(Iobrcbr);
        % figure
        % imagesc(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)')
        
        % I2fgm = I;
        % I2fgm(fgm) = 255;
        % figure
        % imagesc(I2fgm), title('Regional maxima superimposed on original image (I2Gauss)');
        
        se2 = strel(ones(3,3));
        fgm2 = imclose(fgm, se2);
        fgm3 = imerode(fgm2, se2);
        
        fgm4 = bwareaopen(fgm3, 5);
        % I3 = I;
        % I3(fgm4) = 255;
        % figure
        % imagesc(I3)
        % title('Modified regional maxima superimposed on original image (fgm4)')
        
        % make circles for opened and closed image
        % imagesc(Iobrcbr,'Parent',hbwax);
        level=linspace(.01,1,100);
        % circInfo2=struct;
        maxObjNum=0;
        maxObjInd=1;
        allCenters=[0,0];
        allRadii=0;
        for i=1:length(level)
            bw(:,:,i)=im2bw(Iobrcbr,level(i));
            bw(:,:,i)=bwmorph(bw(:,:,i),'diag');%make sure all 8-connected pixels are 4-connected
            [centers,radii,metric]=imfindcircles(bw(:,:,i),radRange);
            metricInd=metric>.4;
            %    viscircles(uaa.handles.ax2,centers(metricInd,:),radii(metricInd,:));
            allCenters=[allCenters;centers(metricInd,:)];
            allRadii=[allRadii;radii(metricInd,:)];
            %    circInfo2(i).centers=centers(metricInd,:);
            %    circInfo2(i).radii=radii(metricInd,:);
            %    circInfo2(i).metric=metric(metricInd,:);
            CC=bwconncomp(bw(:,:,i));
            if CC.NumObjects>maxObjNum
                maxObjNum=CC.NumObjects;
                maxObjInd=i;
            end
            %    circInfo2(i).NumObjects=CC.NumObjects;
            %    circInfo2(i).level=level(i);
            %    circInfo(i).metricInd=metricInd;
            if isempty(find(bw(:,:,i),1)) %stop loop when all BW values are 0
                break
            end
            
        end
        % level2=level(maxObjInd);
        
        % bw = im2bw(Iobrcbr, level2);
        bw=bw(:,:,maxObjInd);
        % figure
        % imagesc(bw), title('Thresholded opening-closing by reconstruction (bw)')
        
        D = bwdist(bw);
        DL = watershed(D);
        bgm = DL == 0;
        
        % make figure with segmenting lines
        I4=I;
        I4(bgm)=max(max(I4))+1;
        % figure
        % imagesc(bgm), title('Watershed ridge lines (bgm)')
        
        % The function |imimposemin| can be used to modify an image so that it has
        % regional minima only in certain desired locations.  Here you can use
        % |imimposemin| to modify the gradient magnitude image so that its only
        % regional minima occur at foreground and background marker pixels.
        
        % gradmag2 = imimposemin(gradmag, bgm | fgm4);
        % Finally we are ready to compute the watershed-based segmentation.
        
        % L = watershed(gradmag2);
        
        % One visualization technique is to superimpose the foreground
        % markers, background markers, and segmented object boundaries on the
        % original image.  You can use dilation as needed to make certain aspects,
        % such as the object boundaries, more visible.  Object boundaries are
        % located where |L == 0|.
        
        IgMax=max(max(Ig));
        circleMask=zeros(imSize);
        circleMaskTotal=circleMask;
        for k=2:size(allCenters,1)
            circleMask=circle(imSize(1),imSize(2), allCenters(k,1),allCenters(k,2),allRadii(k));
            circleMaskTotal(circleMask)=1;
        end
        
        circleMaskTotal=bwperim(circleMaskTotal);
        % Ig(circleMaskTotal)=0;
        imagesc(I4,'Parent',uaa.handles.ax(2));
        viscircles(uaa.handles.ax(2),allCenters,allRadii);
        
        title('Watershed Segmentation','Parent',uaa.handles.ax(2));
    end

    function seLine=bwFindAngle(BW)
        [row,col]=find(BW);
        bwFit=polyfit(row,col,1);
        bwLine=polyval(bwFit,1:imSize(1));
        axes(uaa.handles.ax(8));
        hold on
        plot(uaa.handles.ax(8),1:imSize(1),bwLine(1,:),'r','LineWidth',3);
        degrees=radtodeg(atan(bwFit(1)));
        seLine=strel('line',30,-degrees);
        hold off
    end

    function bwLine=bwFindPolyLine(BW)
        [row,col]=find(BW);
        bwFit=polyfit(row,col,6);
        bwLine=polyval(bwFit,1:imSize(1));
        axes(uaa.handles.ax(9));
        hold on
        plot(uaa.handles.ax(9),1:imSize(1),bwLine(1,:),'r','LineWidth',3);
        hold off
    end


end

