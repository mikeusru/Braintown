function [centers,radii,metric]=uaa_autoMakeCircles(I)
% circleanalysis_circleonly(I) analyzes the circles in the
% image I and figures out which ones are mostly surrounded by empty space,
% meaning that they are not inside another object. the function draws a
% larger circle around the first one and tells you the difference. the
% inputs are:
%
global uaa

[imageSizeY,imageSizeX]=size(I);


% find circles
level=graythresh(I);
% BW=im2bw(I,level);
% BW=bwmorph(BW,'diag');%make sure all 8-connected pixels are 4-connected
% [centers,radii,metric] = imfindcircles(BW,[3 12],'Sensitivity',.9);
[centers,radii,metric] = imfindcircles(I,[3 12],'Sensitivity',.95);
% 
% hFig1=figure;
% hAx1=gca;
% hFig2=figure;
% hAx2=gca;

% imagesc(I,'Parent',hAx1);
% viscircles(hAx1,centers2,radii2);
% 
% imshow(BW,'InitialMagnification',300);
% viscircles(hAx2,centers,radii);
% 
% thinmorph=bwmorph(BW,'thin',Inf);
% endpoints=bwmorph(thinmorph,'endpoints');
% % Create a logical image of a circle with specified
% % diameter, center, and image size.
% % First create the image.
% 
% 
% expandCoefficient=5;
% % imageSizeX = 128;
% % imageSizeY = 128;
% [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% % Next create the circle in the image.
% newcenters=centers;
% newradii=radii;
% for i=1:length(radii)
%     centerX = centers(i,1);
%     centerY = centers(i,2);
%     sideXdist=abs(centerX-imageSizeX)/imageSizeX; % percent distance from edge of image
%     sideYdist=abs(centerY-imageSizeY)/imageSizeY;
%     radius = radii(i);
%     
%     
%     circlePixels = (rowsInImage - centerY).^2 ...
%         + (columnsInImage - centerX).^2 <= radius.^2;
%     
%     circlePixelsExpanded=(rowsInImage - centerY).^2 ...
%         + (columnsInImage - centerX).^2 <= (radius+expandCoefficient).^2;
%     % circlePixels is a 2D "logical" array.
%     
%     innerarea=sum(sum(BW(circlePixels)));
%     outerarea=sum(sum(BW(circlePixelsExpanded)))-innerarea;
%     outerarea_measured=sum(sum(BW(circlePixelsExpanded)));
%     
%     
%     innerarea_full=sum(sum(circlePixels));
%     outerarea_full=sum(sum(circlePixelsExpanded))-innerarea_full;
%     outerarea_diff=outerarea_full/outerarea;
%     
%     
%     removed=false;
%     if metric(i)<.3
%         if outerarea_diff<1.5 % remove circles which are surrounded by filled in areas
%             remove_circle_index=ismember(newcenters,[centerX,centerY],'rows');
%             newcenters(remove_circle_index,:)=[];
%             newradii(remove_circle_index)=[];
%             removed=true;
%         elseif outerarea_diff>1.5 && outerarea_diff<2.5
%             if isempty(find(circlePixelsExpanded(endpoints),1)) % if circle does not contain skeletal endpoint and is not completely surrounded by emptiness
%                 remove_circle_index=ismember(newcenters,[centerX,centerY],'rows');
%                 newcenters(remove_circle_index,:)=[];
%                 newradii(remove_circle_index)=[];
%                 removed=true;
%             end
%         end
%         if 0.1 > sideXdist || 0.9 < sideXdist || ... %remove circles too close to edge
%                 0.1 > sideYdist || 0.9 < sideYdist
%             remove_circle_index=ismember(newcenters,[centerX,centerY],'rows');
%             newcenters(remove_circle_index,:)=[];
%             newradii(remove_circle_index)=[];
%             removed=true;
%         end
%     end
%     if ~removed
%         viscircles([centerX,centerY],radius,'EdgeColor','b');
%         viscircles([centerX,centerY],radius+expandCoefficient,'EdgeColor','r');
% 
%         text(centerX-5,centerY,num2str(outerarea_diff));
%         text(centerX,centerY-10,[{['Area(px) = ' num2str(round(outerarea_measured))]};{['Metric = ' num2str(metric(i))]}],'BackgroundColor','y');
%     end
% end
% 
% 
% % viscircles(newcenters, newradii,'EdgeColor','b');
% % viscircles(newcenters, newradii+expandCoefficient,'EdgeColor','r');
% 
% %% Circle analysis on original image
% subplot(SpineStruct(k).ax2);
% 
% lowmetric=metric2;
% lowmetric(lowmetric>.3)=0;
% lowmetric(lowmetric>0)=1;
% lowmetric=logical(lowmetric);
% centers2(lowmetric,:)=[];
% radii2(lowmetric,:)=[];
% metric2(lowmetric)=[];
% 
% imagesc(I);
% viscircles(centers2,radii2);
% text(centers2(:,1),centers2(:,2),num2str(metric2));
% 
% 
% 
% 
% % save image
% f=getframe(SpineStruct(k).fig);
% if k==1
%     [circleGif,SpineStruct(1).immap] = rgb2ind(f.cdata,256,'nodither');
% end
% circleGif(:,:,1,k)=rgb2ind(f.cdata,SpineStruct(1).immap,'nodither');


% SpineStruct(current).CircleImage=getframe;
% fname=SpineStruct(1).fname;
% print('-dpng',[fname, num2str(k)]);
% SpineStruct(current).circleImg=BW;
% SpineStruct(current).circle

