function [ output_args ] = uaa_updateRoiInfo( i )
%uaa_updateRoiInfo( roiInd ) updates the info for the given ROI in the
%dataset.
%
% roiInd is the dataset index of the roi
global uaa

ind=uaa.currentFrame;

switch get(uaa.handles.roiA(i),'Type')
    case 'line'
        spc_roi=[get(uaa.handles.roiA(i), 'XData')', get(uaa.handles.roiA(i), 'YData')'];
        uaa.T.PolygonRoi{ind,i} = spc_roi;
        
        %add position to all non-accessed and all empty ROI positions
        uaa.T.PolygonRoi(~uaa.T.Accessed,i)={spc_roi}; %add position to all non-accessed positions
        emptyInd=cellfun('isempty',uaa.T.PolygonRoi(:,i));
        uaa.T.PolygonRoi(emptyInd,i)={spc_roi}; %add position to all empty positions
        
    case 'rectangle'
        
        spc_roi=get(uaa.handles.roiA(i), 'Position');
        uaa.T.Roi{ind,i} = spc_roi;
        
        %add position to all non-accessed and all empty ROI positions
        uaa.T.Roi(~uaa.T.Accessed,i)={spc_roi}; %add position to all non-accessed positions
        emptyInd=cellfun('isempty',(uaa.T.Roi(:,i)));
        uaa.T.Roi(emptyInd,i)={spc_roi}; %add position to all empty positions
end

end

