function [ output_args ] = uaa_changeFrame( moveTo,command )
%uaa_changeFrame( prevNext ) indicates that the user wants to change the
%frame to a different position.
%
% prevNext indicates whether the change is to go back or forward. 0
% indicates back, 1 indicates forward, and 2 indicates a move to
% uaa.currentFrame

global uaa
if nargin<2
    command='';
end

switch moveTo
    case 0 %move to previous frame
        if uaa.currentFrame-1 > 0
            uaa_deleteRoiHandles;
            uaa.currentFrame=uaa.currentFrame-1;
            uaa_updateImage;
        else
            disp('Reached First Frame');
            return
        end
        
    case 1 %move to next frame
        if uaa.currentFrame+1 <= size(uaa.T,1)
            uaa_deleteRoiHandles;
            uaa.currentFrame=uaa.currentFrame+1;
            uaa_updateImage;
        else
            disp('No More Frames');
            return
        end
    case 2 %move to frame stored in uaa.currentFrame
        uaa_deleteRoiHandles;
        uaa_updateImage;
end

if strcmp(command,'watershed')
    uaa.T.Roi(uaa.currentFrame,2:end)=uaa.T.closestPosRoi(uaa.currentFrame,2:end);
end

uaa_showRois;
uaa_updateGUI;

end

