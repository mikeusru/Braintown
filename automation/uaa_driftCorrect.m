function uaa_driftCorrect
%UAA_DRIFTCORRECT runs the drift correction algorithm on all the images
%using the selected frame as a reference
global uaa
disp('Using currently selected frame as reference for Drift Correction algorithm');

Iref=uaa_getCurrentImageFrame;
nFrames=height(uaa.T);
for i=1:nFrames
    I=uaa_getCurrentImageFrame(i);
    [ shiftx(i),shifty(i) ] = computeDrift( Iref,I);
end


% avgframes = 1;
% bigIter = 15000;
%   framerate = 29.97;

newsizey=2*max(abs(shifty))+uaa.imSize(1);
newsizex=2*max(abs(shiftx))+uaa.imSize(2);
midindexy=(newsizey-uaa.imSize(1))/2+1;
midindexx=(newsizex-uaa.imSize(2))/2+1;
blankNewI=zeros(newsizey,newsizex,'uint16');
stackSize=size(uaa.T.ImageStack{1,1},3);
blankNewIStack=zeros(newsizey,newsizex,stackSize,'uint16');
for i=1:nFrames
    frame_shift=blankNewI;
    I=uaa_getCurrentImageFrame(i);
    row=midindexy+shifty(i):midindexy+shifty(i)+(uaa.imSize(1)-1);
    col=midindexx+shiftx(i):midindexx+shiftx(i)+(uaa.imSize(2)-1);
    frame_shift(row,col)=I;
    uaa.T.Image{i,1}=frame_shift;
    %shift entire stack as well as projection
    stackFrame_shift=blankNewIStack;
    for j=1:stackSize
        if isempty(uaa.T.ImageStack{i,1})
            continue
        end
        Is=uaa.T.ImageStack{i,1}(:,:,j);
        stackFrame_shift(row,col,j)=Is;
    end
    uaa.T.ImageStack{i,1}=stackFrame_shift;
end

uaa.imSize=size(uaa_getCurrentImageFrame(1));
uaa_makeFig(1);
uaa_updateImage;
end




