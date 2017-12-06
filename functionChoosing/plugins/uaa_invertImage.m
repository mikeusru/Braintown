function I = uaa_invertImage(I)
% I = uaa_invertImage(I) simply invert the image using imcomplement.
%
% Input: I (image)
% 
% Output: I (Inverse Image)
%
I = imcomplement(I);