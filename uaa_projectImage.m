function Ip = uaa_projectImage(pMethod)
%function uaa_projectImage(pMethod) projects an image using all the frames
% pMethod indicates projection type and can either be 'sum' or 'max'

global uaa

I=uaa_imagesToStack;

switch pMethod
    case 'sum'
        Ip=sum(double(I),3);
    case 'max'
        Ip=max(I,[],3);
    case 'std'
        Ip = std(double(I),0,3);
end

Ip=mat2gray(Ip);

uaa.T(2:end,:)=[];
uaa.T.Image(1,1)={Ip};

uaa.currentFrame=1;
uaa_updateGUI;
uaa_changeFrame(2);