function [shiftx, shifty, I_corrected] = uaa_driftCorrectUsingSubstack(frameBox,I)

% for weak signal frames, try summing a select number them and
%correcting for drift so intensity is high enough
% frameBox - number of frames to sum for drift correction. For example, if
%image is 30hz and you want to do drift correction once a minute, set to
%30
%
% I - cell vector of images


global uaa
[FileName, PathName] = uiputfile('*.tif');
fName = fullfile(PathName,FileName);
timerVal = tic;

if nargin<1
    frameBox = 30;
end
if nargin<2
    I = uaa.T.Image;
end
imSize = size(I{1});
nFrames = length(I);
truncatedLength = nFrames - mod(nFrames,frameBox);
It = I(1:truncatedLength);
It = reshape(It,frameBox,[]);
n = size(It,2);
Imax = zeros(imSize(1),nan(2),n);
shiftx = zeros(1,n);
shifty = zeros(1,n);
for i = 1:n
    for j = 1:frameBox
        Imax(:,:,i) = max(cat(3,Imax(:,:,i),It{j,i}),[],3);
    end
    if i>1
        [ shiftx(i),shifty(i) ] = computeDrift( Imax(:,:,1),Imax(:,:,i));
        fprintf('%s%d%s%d\n','Calculating Drift for Frames ',frameBox*(i-1)+ 1, ' - ', frameBox*(i));
    end
end


% %% First, make drift corrected summed stack for preview
% newsizey=2*max(abs(shifty))+imSize(1);
% newsizex=2*max(abs(shiftx))+imSize(2);
% midindexy=(newsizey-imSize(1))/2+1;
% midindexx=(newsizex-imSize(2))/2+1;
% minBackground = min(Imax(:));
% blankNewI=ones(newsizey,newsizex,'uint16') * minBackground;
% I_corrected = cell(n,1);
% 
% for i=1:n
%     frame_shift=blankNewI;
%     row=midindexy+shifty(i):midindexy+shifty(i)+(imSize(1)-1);
%     col=midindexx+shiftx(i):midindexx+shiftx(i)+(imSize(2)-1);
%     frame_shift(row,col)=Imax(:,:,i);
%     I_corrected{i}=frame_shift;
%     fprintf('%s%d\n','Creating Preview Frame ',i);
% end

%% make new drift-corrected image stack
shiftx = repmat(shiftx,frameBox,1);
shiftx = shiftx(:);
shiftx(end : nFrames) = shiftx(end);
shifty = repmat(shifty,frameBox,1);
shifty = shifty(:);
shifty(end : nFrames) = shifty(end);

newsizey=2*max(abs(shifty))+imSize(1);
newsizex=2*max(abs(shiftx))+imSize(2);
midindexy=(newsizey-imSize(1))/2+1;
midindexx=(newsizex-imSize(2))/2+1;
minBackground = min(Imax(:));
blankNewI=ones(newsizey,newsizex,'uint16') * minBackground;
I_corrected = I;

for i=1:nFrames
    frame_shift=blankNewI;
    row=midindexy+shifty(i):midindexy+shifty(i)+(imSize(1)-1);
    col=midindexx+shiftx(i):midindexx+shiftx(i)+(imSize(2)-1);
    frame_shift(row,col)=I{i};
    I_corrected{i}=frame_shift;
    fprintf('%s%d\n','Creating Frame ',i);
end

%% write file
ii = 1;
maxFrames = 5000; %max frames per file
if nFrames/maxFrames>1
    disp('Writing multiple files to avoid memory errors');
    [p,f,e] = fileparts(fName);
    while ii <= ceil(nFrames/maxFrames)
        firstInd = (ii-1)*maxFrames + 1;
        if firstInd > nFrames
            break
        end
        fName = fullfile(p,[f,'_',num2str(ii),e]);
        imwrite(I_corrected{firstInd},fName,'WriteMode','overwrite');
        for i = 2:maxFrames
            ind = (ii-1)*maxFrames + i;
            if ind > nFrames
                break
            end
            imwrite(I_corrected{ind},fName,'WriteMode','append');
            fprintf('%s%d\n','Writing Frame ',ind);
        end
        ii = ii + 1;
    end
else
    imwrite(I_corrected{1},fName,'WriteMode','overwrite');
    for i = 2:nFrames
        imwrite(I_corrected{i},fName,'WriteMode','append');
        fprintf('%s%d\n','Writing Frame ',i);
    end
end
elapsedTime = toc(timerVal);
fprintf('%s%d%s\n', 'Entire Drift Correction Process Took ', elapsedTime, 's');