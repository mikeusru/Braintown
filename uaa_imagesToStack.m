function I = uaa_imagesToStack
global uaa


I = uaa.T.Image;
I = reshape(I,1,1,[]);
I = cell2mat(I);

% 
% I=uaa_getCurrentImageFrame(1);
% 
% for i=1:size(uaa.T.Image,1)
%     if i==1
%         continue
%     end
%     I(:,:,i)=uaa_getCurrentImageFrame(i);
% end