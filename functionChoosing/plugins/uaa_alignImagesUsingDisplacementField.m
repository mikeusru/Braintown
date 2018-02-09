function transformedImage = uaa_alignImagesUsingDisplacementField(inputImage)
% transformedImage = uaa_alignImagesUsingDisplacementField(inputImage)
% uaa_alignImagesUsingDisplacementField figures out a transform
% based on an automatically calculated displacement field between images.
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
% tForm = fitgeotrans(selectedMovingPoints, selectedFixedPoints, 'affine');
% dim = size(template);
[D, moving_reg] = imregdemons(inputImage,ref_image);
% transformedImage = imwarp(inputImage, D);
figure; imshowpair(ref_image, moving_reg, 'falsecolor');
%get how many imaging sessions
sessions = unique([fov.session]);
%grab dendrite locations
isDendrite = logical([fov.dendrite]);
dendriteLocs = find(isDendrite);
%in case there is more than 1 dendritic segment (just grab 1 image)
segs = [fov(dendriteLocs).segment];
dendriteLocs = dendriteLocs(segs==1);

%input imaging session (after first) you want
imgday = sessions(2);

figure
imagesc(fov(dendriteLocs(1)).img)
template = fov(dendriteLocs(1)).img;
%now grab next image and set up affine correction
%note: sometimes this does a bad job the first time so making this
%integrated with a button would be very helpful (so one could re-do)
clear fixedPoints
clear movingPoints
currentSlice = fov(dendriteLocs(imgday)).img;
cpselect(normalizeArray(template),normalizeArray(currentSlice)); %matlab based GUI

%% once you have fixedPoints/movingPoints continue here
%now find transform with these fixed points
tForm = cp2tform(movingPoints, fixedPoints, 'affine');
dim = size(template);
transformedImage = imtransform(currentSlice, tForm,'XData', [1 dim(1)], 'YData', [1 dim(2)]);

%just for me to visualize everything and see how good transform is
figure(); imagesc(normalizeArray(template)); axis image;
figure(); imagesc(normalizeArray(transformedImage)); axis image;
figure(); imagesc(normalizeArray(currentSlice)) ; axis image;


%now go through each ROI associated with this image and transform
for cc = 1:length(fov)
    if fov(cc).spine && fov(cc).session==imgday
        oldX = fov(cc).xPos;
        oldY = fov(cc).yPos;
        [newX,newY] = tformfwd(tForm,oldX,oldY);

%         %NOTE might want to NOT overwrite old positions
%         fov(cc).xPos = newX;
%         fov(cc).yPos = newY;
        
        %just for me to visualize everything
        figure(5)
        hold on
        plot(oldX,oldY,'or')
        figure(6)
        hold on
        plot(newX,newY,'or')
    end
end
