function [ shiftx,shifty ] = computeDrift( imgref,img)
%computeDrift computes the x and y drift for two images using fourier
%transform calculations. It uses an entire image and not just the spine.
%The input is the reference (first) image and the second image. the output
%is the directional shift [x, y] in pixels. code is written by Michael
%Smirnov and based on drifty_shifty_deluxe script by Josh Sugar and Dave
%Robinson, Sandia National Labs, Copyright 2014 Sandia Corporation.

scale = size(img)./size(imgref);
if ~(sum(size(imgref) == size(img)) == 2)
    img = imresize(img,size(imgref));
end    
    
[vidHeight vidWidth ~] = size(imgref);
fft_ref=fft2(imgref); % 2D fast Fourier transform on initial image
centery=(vidHeight/2)+1;
centerx=(vidWidth/2)+1;
fft_frame=fft2(img);
prod=fft_ref.*conj(fft_frame);
cc=ifft2(prod);
[maxy,maxx]=find(fftshift(cc)==max(max(cc)));
% fftshift moves corners to center; max(max()) gives largest element; find returns indices of that point
shifty=maxy(1)-centery;
shiftx=maxx(1)-centerx;
% Checks to see if there is an ambiguity problem with FFT because of the
% periodic boundary in FFT (not sure why or if this is necessary but I'm
% keeping it around for now)
if abs(shifty)>vidHeight/2
    shifty=shifty-sign(shifty)*vidHeight;
end
if abs(shiftx)>vidWidth/2
    shiftx=shiftx-sign(shiftx)*vidWidth;
end

shiftx = round(shiftx * scale(1));
shifty = round(shifty * scale(2));

end

