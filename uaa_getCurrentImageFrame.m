function I = uaa_getCurrentImageFrame(frameNumber)
% I = uaa_getCurrentImageFrame
% returns the current image frame I. This is necessary for dealing with
% regular data versus ImageDatastores

global uaa

if nargin<1
    frameNumber = uaa.currentFrame;
end

if isfield (uaa, 'useImageDatastore') && uaa.useImageDatastore
    I = readimage(uaa.imds,frameNumber);
else
    I = uaa.T.Image{frameNumber};
end