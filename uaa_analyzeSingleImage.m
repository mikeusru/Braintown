function uaa_analyzeSingleImage(I)

global uaa

showfigs=logical([1 1 1 1 1 1 1 1 1 1 1 1]);

figVars=cell(0);
imSize=size(uaa_getCurrentImageFrame);
uaa.imageAnalysis.analyzedFigs{1}=I;

if uaa.settings.watershed.doWatershed
    if isfield(uaa.handles,'uaa_autoOptions')...
            && ishandle(uaa.handles.uaa_autoOptions.updateSingleImageCheckbox)...
            && get(uaa.handles.uaa_autoOptions.updateSingleImageCheckbox,'Value')
        varName=uaa_getVarFromHandle(uaa.imageAnalysis.lastUsedOptions);
        if isfield(uaa.imageAnalysis.analyzedStruct,varName)
            uaa.imageAnalysis.analyzedStruct=rmfield(uaa.imageAnalysis.analyzedStruct,varName);
        end
        analyzedStruct = uaa_watershedWithOptions( I,uaa.imageAnalysis.analyzedStruct );
        uaa.imageAnalysis.analyzedStruct=analyzedStruct;
        figVars=getFigVars;
        uaa.imageAnalysis.figVars=[{'I'},figVars];
%         varInd=find(~cellfun(@isempty,strfind(figVars,varName)));
        if ~isfield(uaa.handles,'singleImg') || ~ishandle(uaa.handles.singleImg)
            uaa.handles.singleImg=figure('Name','Single Variable Test Image');
        else
            figure(uaa.handles.singleImg);
        end
        imshow(analyzedStruct.(varName),'InitialMagnification',384/imSize(1)*100);
        title(varName);
        colormap(jet);
        return
    else
        if length(imSize)>2 && imSize(3)==3
            I=rgb2gray(I);
        end
        % figures to show
        
        imagesc(I, 'Parent',uaa.handles.ax(1));
        title(uaa.handles.ax(1),'Original Image');
        
        if uaa.settings.watershed.removeTransparency
            I(I==0)=max(max(I))+1;
        end
        
        if uaa.settings.watershed.inverseImage
            I=imcomplement(I);
        end
        
        analyzedStruct = uaa_watershedWithOptions( I );
        uaa.imageAnalysis.analyzedStruct=analyzedStruct;
        figVars = getFigVars;
        figNames={'Gaussian Blur (Ig)' , 'Top-hat filter (bw2)', ...
            'Morphological Opening (bw3)',...
            'Threshold + Remove Small Objects (bw4)' ,...
            'Thin and Remove Branches (bw5)', 'Build Dendrite (bw6)', ...
            'Subtract Dendrite from bw3 (bw7)', 'Extended Maxima (mask_em)', ...
            'Clear Extended Maxima (I_mod)', 'Watershed Transform (overlay3)', ...
            'Spine Overlay (overlay4)'};
        jetAxis=logical([ 0 0 1 1 0 0 0 0 0 1 0 0]);
        uaa.imageAnalysis.figVars=[{'I'},figVars];
        uaa.imageAnalysis.figNames=[{'Original (I)'},figNames];
    end
end

for j=1:size(figVars,2)
    axCounter=j+1;
    %     uaa.imageAnalysis.analyzedFigs(axCounter)={analyzedStruct.(figVars{1,i})};
    if showfigs(axCounter)
        imshow(analyzedStruct.(figVars{1,j}),'Parent',uaa.handles.ax(axCounter));
        title(figNames{1,j},'Parent',uaa.handles.ax(axCounter));
    else
        cla(uaa.handles.ax(axCounter));
    end
end

h=uaa.handles.ax(ishandle(uaa.handles.ax));
axis(h,'equal','off','image');

if  uaa.settings.watershed.doWatershed
    hJet=h(jetAxis);
    for j=1:length(hJet)
        colormap(hJet(j),jet);
    end
end

    function figVars = getFigVars
        figVars=fieldnames(analyzedStruct)';
        noShowNames={'stats','L','I2'};
        for k=1:length(noShowNames)
            ind=~cellfun(@isempty,strfind(figVars,noShowNames{k}));
            figVars(ind)=[];
        end
    end
end
