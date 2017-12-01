function uaa_rotateAndSaveImages(filename)
%create additional training examples by rotating spine images, making sure
%data is invariant to rotaion.

angleInDegrees = 20;

X = gpuArray(imread(filename));
[pathstr,name,ext] = fileparts(filename);

for i=1:floor(360/angleInDegrees)
    X_rotated = imrotate(X,angleInDegrees * i, 'crop');
    newFileName = fullfile(pathstr,[name,'_rotated',num2str(i),ext]);
    disp(['Saving ', newFileName]);
    imwrite(gather(X_rotated),newFileName);
end

disp('done');