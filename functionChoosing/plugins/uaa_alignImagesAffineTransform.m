function transformedImage = uaa_alignImagesAffineTransform(inputImage)
% transformedImage = uaa_alignImagesAffineTransform(inputImage)
% uaa_alignImagesAffineTransform figures out a transform
% based on user clicks.
%
% Inputs: Image
% Outputs: Image

global uaa
% Dialog to figure out what frame to compare to
prompt = {'Which frame do you want to use as a comparison?'};
dlg_title = 'Frame Selection';
num_lines = 1;
defaultans = {num2str(uaa.currentFrame-1)};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
ref_frame = str2double(answer{1});
ref_image = uaa_getCurrentImageFrame(ref_frame);
[selectedMovingPoints,selectedFixedPoints] = cpselect(mat2gray(inputImage),mat2gray(ref_image),'Wait',true);
%% once you have fixedPoints/movingPoints continue here
%now find transform with these fixed points
tForm = fitgeotrans(selectedMovingPoints, selectedFixedPoints, 'affine');
% dim = size(template);
transformedImage = imwarp(inputImage, tForm);
figure; imshowpair(ref_image, transformedImage, 'falsecolor');

% Construct a questdlg with three options
choice = questdlg('Permanently Transform image and coordinates?', ...
    'Continue?', ...
    'Yas','No','No');
% Handle response
switch choice
    case 'Yas'
        keepGoing = true;
    case 'No'
        keepGoing = false;
end

if keepGoing
    oldX = uaa.T.SpineCoordinates{uaa.currentFrame}(:,1);
    oldY = uaa.T.SpineCoordinates{uaa.currentFrame}(:,2);
    [newX,newY] = tformfwd(maketform('affine',tForm.T),oldX,oldY);
    uaa.T.SpineCoordinates{uaa.currentFrame}(:,1) = newX;
    uaa.T.SpineCoordinates{uaa.currentFrame}(:,2) = newY;
    uaa.T.Image{uaa.currentFrame} = transformedImage;
    uaa_updateImage;
end
