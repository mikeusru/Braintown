function uaa_calcRoiInfo()
%uaa_calcRoiInfo calculates the ROI info

global uaa

%make sure ROIs are defined
% if isempty(uaa.circleRoi(:,:,uaa.currentFrame)) || ...
%         isempty(uaa.image(:,:,uaa.currentFrame)) || ...
%         isempty(uaa.backgroundRoi(:,:,uaa.currentFrame))
%     return
% end
if isempty(findobj('Tag', 'RoiA0'))
    beep;
    errordlg('Set the background ROI (roi 0)!');
    error('Set the background ROI (roi 0)!');
end

ind=uaa.currentFrame;

%calculate average background pixel value
roiMask=uaa.handles.roiA(1).createMask;
I = uaa_getCurrentImageFrame(ind);
backAvg=mean(I(roiMask));
uaa.T.AverageBackgroundPixel(ind,1)=backAvg;

try %calculate non-background ROIs
    for i=1:length(uaa.handles.roiA) %circle ROIs
        if i==1 %don't do calculations for background
            continue
        end
        if ~isempty(uaa.T.Roi{ind,i})
            roiMask=uaa.handles.roiA(i).createMask;
            Icropped=uaa_getCurrentImageFrame(ind);
            Icropped(~roiMask)=0;
            uaa.T.RoiCrop(ind,i)={Icropped}; % cropped ROI image
            Icropped=Icropped - backAvg; % subtract background
            Icropped(Icropped<0)=0; % zero negative values
            uaa.T.RoiSum(ind,i)=sum(Icropped(roiMask));
            uaa.T.RoiAvg(ind,i)=mean(Icropped(roiMask));
            uaa.T.RoiMax(ind,i)=max(max(Icropped));
        end
    end
end
try %calculate polygonal ROIs
    for i=1:length(uaa.handles.polyA)
        if ~isempty(uaa.T.PolygonRoi{ind,i})
            polyMask=uaa.handles.polyA(i).createMask;
            Icropped=uaa_getCurrentImageFrame(ind);
            Icropped(~polyMask)=0;
            uaa.T.PolyCrop(ind,i)={Icropped};
            Icropped=Icropped - backAvg; % subtract background
            Icropped(Icropped<0)=0; % zero negative values
            uaa.T.PolySum(ind,i)=sum(Icropped(polyMask));
            uaa.T.PolyAvg(ind,i)=mean(Icropped(polyMask));
            uaa.T.PolyMax(ind,i)=max(max(Icropped));
        end
    end
end



end

