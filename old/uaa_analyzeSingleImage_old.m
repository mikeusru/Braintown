function uaa_analyzeSingleImage

global uaa


if ~isfield(uaa.settings,'I') || isempty(uaa.settings.I)
    % result=input('use new image? 1 for yes, enter for no ');
    [fName,pName,~]=uigetfile;
    [I,map]=imread([pName,fName]);
    uaa.settings.I=I;
    uaa.settings.fName=fName;
    uaa.settings.pName=pName;
    uaa.settings.map=map;
    uaa_makeFig( 1 );
    uaa.imSize=size(I);
    
else
    I=uaa.settings.I;
end

if length(uaa.imSize)>2 && uaa.imSize(3)==3
    I=rgb2gray(I);
end
% figures to show
showfigs=logical([1 1 1 1 1 1 1 1 1 1 1 1]);

image(I, 'Parent',uaa.handles.ax(1));
title(uaa.handles.ax(1),'Original Image')

if uaa.settings.removeTransparency
   I(I==0)=max(max(I))+1; 
end

if uaa.settings.inverseImage
    I=imcomplement(I);
end

[ Ig, bw2, bw3, bw4, bw5, bw6, bw7, mask_em, I_mod, overlay3, overlay4, stats] = uaa_watershedWithOptions( I );


axCounter=2;
if showfigs(axCounter)
    imagesc(Ig,'Parent',uaa.handles.ax(axCounter));
    title('I_eq','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(bw2,'Parent',uaa.handles.ax(axCounter));
    title('bw2','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(bw3,'Parent',uaa.handles.ax(axCounter));
    title('bw3','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(bw4,'Parent',uaa.handles.ax(axCounter));
    title('bw4','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(bw5,'Parent',uaa.handles.ax(axCounter));
    title('bw5','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(bw6,'Parent',uaa.handles.ax(axCounter));
    title('bw6','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    imagesc(bw7,'Parent',uaa.handles.ax(axCounter));
    title('bw7','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    imagesc(mask_em,'Parent',uaa.handles.ax(axCounter));
    title('mask_em','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    
    imagesc(I_mod,'Parent',uaa.handles.ax(axCounter));
    title('I_mod','Parent',uaa.handles.ax(axCounter));
    hold(uaa.handles.ax(axCounter),'on');
    scatter(uaa.handles.ax(axCounter),stats.Centroid(:,1),stats.Centroid(:,2),'r','filled');
    hold(uaa.handles.ax(axCounter),'off');
%     set(uaa.handles.ax(axCounter),'Tag','I_mod'); %for center plotting
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    imagesc(overlay3,'Parent',uaa.handles.ax(axCounter));
    title('overlay3','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end
axCounter=axCounter+1;
if showfigs(axCounter)
    imagesc(overlay4,'Parent',uaa.handles.ax(axCounter));
    title('I superimposed with L','Parent',uaa.handles.ax(axCounter));
else cla(uaa.handles.ax(axCounter));
end

axis(uaa.handles.ax,'equal','off');
colormap(uaa.handles.Fig1,jet);
% colormap(uaa.handles.ax(1),uaa.settings.map);