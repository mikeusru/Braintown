function uaa_makeExampleMovie
% function uaa_makeExampleGif makes a gif of all the images which are
% analyzed and saves it
global uaa

totalFrames=size(uaa.T,1);
disp(['There are ', num2str(totalFrames), ' frames in total']);
firstFrame=input('Input first frame ');
lastFrame=input('Input last frame ');
fType=input('Filetype? (1 = Uncompressed AVI, 2 = Compressed MP4, 3 = Compressed AVI) ');
if fType==2 || fType==3
    quality=input('Quality? (1 to 100; default=75) ');
    if isempty(quality)
        quality=75;
    end
end
updateRois=input('Update Circle ROIs? (0 or 1) ');
switch fType
    case 1
        [fName,pName]=uiputfile('movie.avi',pwd);
        writerObj=VideoWriter([pName,fName],'Uncompressed AVI');
    case 2
        [fName,pName]=uiputfile('movie.mp4',pwd);
        writerObj=VideoWriter([pName,fName],'MPEG-4');
        writerObj.Quality=quality;
    case 3
        [fName,pName]=uiputfile('movie.avi',pwd);
        writerObj=VideoWriter([pName,fName],'Motion JPEG AVI');
        writerObj.Quality=quality;
end
% [fName,pName]=uiputfile('movie.avi',pwd);
%% open writer object
% loops=lastFrame-firstFrame+1;
% uaa.movie(loops) = struct('cdata',[],'colormap',[]);
writerObj.FrameRate=5;
open(writerObj);

%% loop through frames and get all of them
for i=firstFrame:lastFrame
    uaa.currentFrame=i;
    uaa_changeFrame(2);
    if updateRois
        uaa_deleteRoiHandles;
        uaa.T.Roi(uaa.currentFrame,2:end)=uaa.T.closestPosRoi(uaa.currentFrame,2:end);
        uaa_showRois;
    end
    disp(uaa.currentFrame);
    frame=getframe(uaa.handles.Fig1);
    writeVideo(writerObj,frame);
%     checkIfAbort=input('Abort? 1=yes, enter=no');
%     if checkIfAbort
%         return
%     end
end

close(writerObj);
disp('Finished');
