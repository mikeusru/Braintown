function I = uaa_getAllImageFrames
% I = uaa_getAllImageFrames
% returns an array of cells of images. This is necessary for dealing with
% regular data versus ImageDatastores

global uaa

if isfield(uaa,'useImageDatastore') && uaa.useImageDatastore
    I = readall(uaa.imds);
else
    I = uaa.T.Image;
end