function bestFocus = uaa_chooseBestFocusFrames

global uaa

h3d=figure;
disp('For each image, find the best focused slice,');
% disp('then hit ''Accept Slice''');
% disp('Note: currently, this only works with 9 slices or fewer per image');
disp('then enter the number in the command window and press ENTER');
bestFocus=zeros(1,size(uaa.T,1));

% hc=figure('MenuBar','none','ToolBar','none','Name','Continue?',...
%     'Position',[446,522,242,77]);
% h = uicontrol('Position',[20 20 200 40],'String','Accept Slice',...
%               'Callback','uiresume(gcbf)');

          
figure(h3d);

% imshow3Dfull(uaa.T.ImageStack{1,1});
for q=1:size(uaa.T.ImageStack{1,1},3)
    st(q)=subplot_tight(1,size(uaa.T.ImageStack{1,1},3),q);
end

for i=1:size(uaa.T,1)
   I=uaa.T.ImageStack{i,1};
   for j=1:size(I,3)
      cla(st(j));
      
      I(:,:,j)=adapthisteq(I(:,:,j));
      im(j)=imagesc(I(:,:,j),'parent',st(j));
    set(st(j),'XTick',[],'YTick',[]);
    xlabel(num2str(j),'parent',st(j));
        axis(st(j),'equal','tight');

   end
%    figure(h3d);
%    imshow3Dfull(I);
%    uiwait(hc);
%    a=findall(h3d,'style','Slider');
   bestFocus(1,i)=input('Enter Best Focused Slice#: ');
   delete(im);
%    disp(bestFocus(1,i));
end

uaa.imageAnalysis.bestFocus=bestFocus;




close(h3d);
% close(hc);