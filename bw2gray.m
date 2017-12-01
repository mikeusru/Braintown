function Igray = bw2gray( BW )
%BW2GRAY takes a binary image and multiplies it into 3 dimensions, making
%it RGB and grayscale

Igray=cat(3,BW,BW,BW);


end

