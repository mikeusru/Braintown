function [ FinalImage,NumberImages,InfoImage ] = read_tiff_func( FileTif )
%read_tiffstack Is used to read an entire tiff stack and output it as a
%three-dimensional matrix
%   The input argument is the name of the tiff stack to be imported
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
%workaround for imageJ images larger than 4gb listing as only having 1 frame
if NumberImages == 1 
    try
        numFramesStr = regexp(InfoImage.ImageDescription, 'images=(\d*)', 'tokens');
        numFrames = str2double(numFramesStr{1}{1});
        if numFrames > 1
            fprintf('%s%d%s\n','Found ', numFrames, ' Frames although only 1 initially reported. Using low-level File I/I to read file');
            NumberImages = numFrames;
            fp = fopen(FileTif , 'rb');
            % Use low-level File I/O to read the file
            % The StripOffsets field provides the offset to the first strip. Based on
            fseek(fp, InfoImage.StripOffsets, 'bof');
            % Assume that the image is 16-bit per pixel and is stored in big-endian format.
            % Also assume that the images are stored one after the other.
            % For instance, read the first 100 frames
            imData=cell(1,NumberImages);
            FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
            for i=1:NumberImages
                FinalImage(:,:,i)=fread(fp, [InfoImage.Width InfoImage.Height], 'uint16', 0, 'ieee-be')';
                fprintf('%s%d\n','Reading Frame ', i);
            end
            fclose(fp);
            return
        end
    end
end
FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
for i=1:NumberImages
   %assign frames by 1. if shape is wrong, just assign the image and break
   %the loop.
   img = imread(FileTif,'Index',i);
   if ~isequal(size(FinalImage(:,:,i)),size(img))
       FinalImage = uint16(img);
%        NumberImages = size(FinalImage,3);
       break
   end
   FinalImage(:,:,i)=imread(FileTif,'Index',i);
end

end

