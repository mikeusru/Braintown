function noDendrite = uaa_subtractDendrite(I,BWDendrite)
% noDendrite = uaa_subtractDendrite(I,BWDendrite)
% UAA_subtractDendrite removes the dendrite from the image
%
% Inputs: Original Image, Binary Dendrite
% Outputs: Image

I(BWDendrite) = min(I(:));
noDendrite = I;
