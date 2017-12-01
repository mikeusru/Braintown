function [ output_args ] = uaa_updateRoiInfo( pos, i, tagA )
%uaa_updateRoiInfo( roiInd ) updates the info for the given ROI in the
%dataset.
%
% roiInd is the dataset index of the roi
global uaa
ind=uaa.currentFrame;

switch tagA
    case 'PolA'
        uaa.T.PolygonRoi{ind,i} = pos;
        %add position to all non-accessed and all empty ROI positions
        uaa.T.PolygonRoi(~uaa.T.Accessed,i)={pos}; %add position to all non-accessed positions
        emptyInd=cellfun('isempty',(uaa.T.PolygonRoi(:,i)));
        uaa.T.PolygonRoi(emptyInd,i)={pos}; %add position to all empty positions
        set(uaa.handles.polyTextA(i),'Position',[pos(1,1)+2, pos(1,2)+2,0]);
        
    case 'RoiA'
        
        uaa.T.Roi{ind,i} = pos;
        %add position to all non-accessed and all empty ROI positions
        uaa.T.Roi(~uaa.T.Accessed,i)={pos}; %add position to all non-accessed positions
        emptyInd=cellfun('isempty',(uaa.T.Roi(:,i)));
        uaa.T.Roi(emptyInd,i)={pos}; %add position to all empty positions
        set(uaa.handles.textA(i),'Position',[pos(1), pos(2),0]);

end

end

