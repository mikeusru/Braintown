function [Is,branchStruct] = uaa_make3Dimage(fovSizeUM,I,doDownsample)

global uaa

% FOV Size, in microns in X or Y

if nargin<1
    fovSizeUM=250;
end

if nargin<2
    I=uaa_imagesToStack;
end

if nargin<3
    doDownsample=false;
end


if doDownsample
    branchImageSize=[5, 5, 10];
else
    branchImageSize=[80, 80, 10];
end

[zStepSize,zoomFactor] = uaa_findZstepSize;

[m,n,o]=size(I);

if m~=n
    disp('image dimensions needs to be equal');
    return
end

fovSizeActual=fovSizeUM/zoomFactor;
umPerPixel=fovSizeActual/m;
zPixelsPerStep=abs(zStepSize/umPerPixel);

if zPixelsPerStep<1
    disp('warning - fewer than 1 pixel per Z step. Using value of 1 pixel.');
    zPixelsPerStep=1;
end

if doDownsample
    I = downsampleImage(I);
end
Is = im3Danalysis(I);
branchStruct = separateBranches(I,Is.SkelDendrite);
branchStruct = padBranchImages(branchStruct);
try
    dispBranchStruct(branchStruct);
end
Is.I=I;
make3Dfigs(Is);

%% Downsample image for faster processing
    function Id = downsampleImage(I)
        Id=uint16(zeros([64, 64, o]));
        for i=1:o
            Id(:,:,i)=imresize(I(:,:,i),[64,64]);
        end
    end

%% Make Binary 3D Image

% TH=zeros(size(I));
% IO=zeros(size(I));
% hWait=waitbar(0,'Making Binary Image...');
% ii=1;
% SEth=strel('disk',3);

% SEio=strel('disk',2);
% for i=1:o
%     waitbar(ii/o,hWait);
%     ii=ii+1;
%     TH(:,:,i)=imtophat(I2(:,:,i),SEth);
%     IO(:,:,i)=imopen(TH(:,:,i),SEio);
%     level=graythresh(IO(:,:,i));
%     BW(:,:,i)=im2bw(IO(:,:,i),level);
% end
% close(hWait);


    function Is = im3Danalysis(I)
        %threshold
        h=waitbar(0,'Thresholding...');
        I2=I;
        imax=max(max(max(I2)));
        I2(I2<(graythresh(I2)*imax))=0;
        %
        Is=struct;
        Is.BW=false(size(I2));
        SEth=strel('ball',5,2);
        SEio=strel('ball',1,2);
        if doDownsample
            SEid=strel('ball',2,2);
        else 
            SEid=strel('ball',7,5);
        end
        waitbar(0.1,h,'Tophat...');
        Is.TH=imtophat(I2,SEth);
        waitbar(0.2,h,'IMopen...');
        Is.IO=imopen(Is.TH,SEio);
        Is.BW(Is.IO>0)=1;
        Is.BW=bwareaopen(Is.BW,5);
        waitbar(0.3,h,'Dilate...');
        
        Is.BWdi=imdilate(double(Is.BW),SEid);
        Is.BWic=imclose(Is.BWdi,(SEid));
        Is.I2=I2;
        waitbar(0.4,h,'Skeleton...');
        
        Is.Skel=Skeleton3D(logical(Is.BWic-min(min(min(Is.BWic)))));

        Is.SkelDendrite=getDendrite(Is.Skel);
        close(h);
    end

    function branchStruct = separateBranches(I,Skel)
        I2=I;
        Skel2=Skel;
        SE=ones(branchImageSize);
        branchStruct=struct;
        ii=1;
        ind=find(Skel2);
        waitMax=length(ind);
        h=waitbar(0,'Separating Branches...');
        while ~isempty(ind)
            waitbar((waitMax - length(ind))/waitMax ,h,'Separating Branches...');
            mask=false(size(Skel2));
            mask(ind(1))=1;
            mask=imdilate(mask,SE);
            [i1,i2,i3]=ind2sub(size(mask),(find(mask)));
            i1r=min(i1):max(i1);
            i2r=min(i2):max(i2);
            i3r=min(i3):max(i3);
            I2cropped=I2(i1r,i2r,i3r);
            SkelCropped=Skel2(i1r,i2r,i3r);
            %             cropped=zeros(size([i1,i2,i3]));
            %             I2cropped=I2;
            %             I2cropped(~mask)=0;
            branchStruct(ii).maxProj=max(I2cropped,[],3);
            [x, y, z] = ind2sub(size(Skel2),ind(1));
            branchStruct(ii).coords=[x y z];
            branchStruct(ii).SkelCropped=SkelCropped;
            I2(i1r,i2r,i3r)=0;
            Skel2(i1r,i2r,i3r)=0;
            ind=find(Skel2);
            ii=ii+1;
            
        end
        close(h);
        branchStruct = organizeBranchStruct(branchStruct);
    end

    function I3D = multiplyZpixels(I,zPixelsPerStep)
        % multiply Z pixels
        
        zSiz=size(I,3);
        zSiz=zSiz*round(zPixelsPerStep);
        I3D=uint16(zeros(m,n,zSiz));
        
        hExpand=waitbar(0,'Expanding Image...');
        ii=1;
        for i=1:m
            for j=1:n
                zStack=permute(I(i,j,:),[1,3,2]);
                %         zStack=interp(zStack,round(zPixelsPerStep)); %interpolation
                zStack=repmat(zStack,round(zPixelsPerStep),1);
                zStack=reshape(zStack,[1,1,zSiz]);
                I3D(i,j,:)=zStack;
            end
            waitbar(ii/m,hExpand,'Expanding Image...');
            ii=ii+1;
        end
        close(hExpand);
    end

    function make3Dfigs(Is)
        % Make Figures
        try
            delete(uaa.handles.h3d)
        end
        fields=fieldnames(Is);
        totalFigs=length(fields);
        if totalFigs>4
            figRows=ceil(totalFigs/4);
            figCols=4;
        else
            figRows=1;
            figCols=totalFigs;
        end
        uaa.handles.h3d=figure;
        for i=1:totalFigs
            h3dAx(i) = subplot_tight(figRows,figCols,i,[0.05,0.05],'Parent',uaa.handles.h3d);
            view(h3dAx(i),[-45, 45]);
            title(h3dAx(i),fields{i});
            drawnow();
            H(i)=vol3d('CData',Is.(fields{i}),'texture','2D','Parent',h3dAx(i));
        end
        axis(h3dAx,'square');
        whitebg(uaa.handles.h3d,'black');
    end
%%
    function [Ixz, Iyz] = create3Dtransforms(I,zPixelsPerStep)
        % not working
        D=permute(I,[1 2 4 3]);
        T3=maketform('affine',[-round(zPixelsPerStep),0,0; 0, 1, 0; 0, 0, 1; 68.5, 0, 0]);
        R3 = makeresampler({'cubic','nearest','nearest'},'fill');
        [m,n,o]=size(I);
        zSiz=o*round(zPixelsPerStep);
        Ixz=tformarray(D,T3,R3,[4 1 2],[1 2 4],[zSiz, m, n],[],0);
        Iyz=tformarray(D,T3,R3,[4 2 1],[1 2 4],[zSiz, m, n],[],0);
        Ixz=squeeze(Ixz);
        Iyz=squeeze(Iyz);
        I4=mirt3D_mexinterp(double(I),y,x,z);
        [X,Y,Z] = meshgrid(x,y,z);
    end
%%
    function branchStruct = organizeBranchStruct(branchStruct)
        coords=extractfield(branchStruct,'coords');
        coords=reshape(coords',3,[])';
        coordDist=squareform(pdist(coords));
        coordDist(coordDist==0)=Inf;
        branchStruct(1).dispIndex=1;
        ii=1;
        for i=2:length(branchStruct)
            [~,ind]=min(coordDist(ii,:)); %find closest value
            coordDist(ii,:)=inf;
            coordDist(:,ii)=inf;
            branchStruct(ind).dispIndex=i;
            ii=ind;
        end
        branchCell=struct2cell(branchStruct);
        sz=size(branchCell);
        branchCell=squeeze(branchCell)';
        branchCell=sortrows(branchCell,4);
        branchCell=reshape(branchCell',sz);
        branchStruct = cell2struct(branchCell,fieldnames(branchStruct));
    end
%%
    function dispBranchStruct(branchStruct)
        try
            delete(uaa.handles.branchFig);
        end
        uaa.handles.branchFig=figure;
        branchCell=squeeze(struct2cell(branchStruct))';
        imdisp(branchCell(:,1));
        
    end
%%
    function SkelDendrite=getDendrite(Skel)
        % convert skeleton to graph structure
        [~,node,link] = Skel2Graph3D(Skel,40);
        % convert graph structure back to (cleaned) skeleton
        SkelDendrite = Graph2Skel3D(node,link,m,n,o);
    end

    function branchStruct = padBranchImages(branchStruct)
        
        for i=1:length(branchStruct)
            sz=size(branchStruct(i).maxProj);
            padsize=branchImageSize(1:2)-sz;
            branchStruct(i).maxProj=padarray(branchStruct(i).maxProj,padsize,0,'post');
        end
    end
end