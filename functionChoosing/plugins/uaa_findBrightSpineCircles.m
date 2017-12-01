function uaa_findBrightSpineCircles(I)
% uaa_findBrightSpineCircles(I)
%UAA_FINDBRIGHTSPINECIRCLES uses the imfindcircles function to find
%spine-sized bright circles in the image. This is good for images where
%spines are brighter; for example, GFP-actin transfected cells.
%
% Inputs: Image
% Outputs: Image, circle coordinates
global uaa

smallestSpineRadius = round(.1/uaa.imageInfo.umPerPixel);
largestSpineRadius = round(2/uaa.imageInfo.umPerPixel);
minPixRes =uaa.imageInfo.smallestFeature/uaa.imageInfo.umPerPixel;

[centers,radii,metric] = imfindcircles(I,[smallestSpineRadius largestSpineRadius],'Sensitivity',.9);


%%
figure
imagesc(I);
axis equal
hold on
viscircles(centers,radii)

%%
[gmag,~] = imgradient(I);
[centers,radii,metric] = imfindcircles(gmag,[smallestSpineRadius largestSpineRadius],'Sensitivity',.9);
figure
imagesc(gmag);
axis equal
hold on
viscircles(centers,radii)

%%
B = I.*gmag;
[centers,radii,metric] = imfindcircles(B,[smallestSpineRadius largestSpineRadius],'Sensitivity',.9);
figure
imagesc(B);
axis equal
hold on
viscircles(centers,radii);

%%
Kaverage = filter2(fspecial('average',minPixRes),I);
B = Kaverage.*gmag;
[centers,radii,metric] = imfindcircles(Kaverage,[smallestSpineRadius largestSpineRadius],'Sensitivity',.9);
figure
imagesc(B);
axis equal
hold on
viscircles(centers,radii);