function ca = uaa_imageToGrid(Iframe,blockSizeR,blockSizeC)
% uaa_imageToGrid divides a 2D image into a cell array of grid parts

[rows, columns, numberOfColorBands] = size(Iframe);
% The first way to divide an image up into blocks is by using mat2cell().
if nargin<3
    blockSizeR = 100; % Rows in block.
    blockSizeC = 100; % Columns in block.
end

% Figure out the size of each block in rows.
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns.
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

% Create the cell array, ca. 
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
    % It's a color image.
    ca = mat2cell(Iframe, blockVectorR, blockVectorC, numberOfColorBands);
else
    ca = mat2cell(Iframe, blockVectorR, blockVectorC);
end
