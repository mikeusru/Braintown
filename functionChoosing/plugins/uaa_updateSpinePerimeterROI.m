function uaa_updateSpinePerimeterROI(i,p)
% uaa_updateSpinePerimeterROI(i,p)
%Note - this is a dependent of the function uaa_labelSpinePerimeters and is
%not to be used alone

global uaa

uaa.T.PerimeterSpineBoundingBox{uaa.currentFrame,1}(i,:) = p;
% disp(i);
% disp(j);
% disp(p);