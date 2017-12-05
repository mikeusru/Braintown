function [BW, I2] = uaa_manualThreshold(I)
% [BW, I2] = uaa_manualThreshold(I)
global uaa

    function sliderContValCallback(h,eventdata)
        thresh=str2double(sprintf('%.3f',get(h,'Value'))); %workaround because rounding to decimal places doesn't work in old version.
        thresh = thresh * maxVal;
        [BW,I2] = threshImage(I,thresh);
        cla(ax1);
        cla(ax2);
        imshow(I2,'Parent',ax1);
        imshow(BW,'Parent',ax2);
    end

    function [BW,I2] = threshImage(I2,multiplier)
        N = round(10 * 1/uaa.imageInfo.umPerPixel);
        N = N + 1 - mod(N,2); %if even, add 1 to neighborhood to make it odd

        [level, EM] = multithresh(I2,2);
        lvl = level(1) * multiplier;
        BWgeneral = imbinarize(I2,lvl); %do this first to remove obviously low background pixels


        I2 = medfilt2(I2);
        I2 = I2 - mean(I2(~BWgeneral));

        T = adaptthresh(gather(I2),'NeighborhoodSize',[N,N]);
        BW = imbinarize(gather(I2),T);
        BW(~BWgeneral) = 0;

        %fill holes smaller than 0.5µm^2
        artifactHoleArea = round((0.5 * 1/uaa.imageInfo.umPerPixel)^2);
        BW_holes = imfill(BW,'holes');
        BW_holes(BW) = 0;
        BW_holes = BW_holes & ~bwareaopen(BW_holes,artifactHoleArea);
        BW = BW | BW_holes;
        I2(~BW) = 0;
    end

    function [f,ax1,ax2] = createSliderWindow()
        %create slider window
        f = figure('Name', 'Adjust Threshold', 'NumberTitle','off','MenuBar','none');
        %create axes
        ax1 = subplot(1,2,1,'Parent',f,'position',[0.08 0.39  0.4 0.54]);
        ax2 = subplot(1,2,2,'Parent',f,'position',[0.54 0.39  0.4 0.54]);
        imshow(I2,'Parent',ax1);
        imshow(BW,'Parent',ax2);
        %create slider
        b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
            'value',startVal, 'min',0, 'max',1,'Tag','threshSlider');
        bgcolor = f.Color;
        bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
            'String','0','BackgroundColor',bgcolor);
        bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
            'String',num2str(maxVal),'BackgroundColor',bgcolor);
        bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
            'String','Threshold','BackgroundColor',bgcolor);
        closeText = uicontrol('Parent',f,'Style','text','Position',[193,5,200,23],...
            'String','Close Window to Continue','BackgroundColor',bgcolor);
        % Create a listener for the slider
        sliderListener = addlistener(b,'ContinuousValueChange',...
            @(b,eventdata) sliderContValCallback(...
            b,eventdata));
    end

I = mat2gray(im2double(I));
startVal = .5;
maxVal = 5;
[BW,I2] = threshImage(I,startVal);
[f,ax1,ax2] = createSliderWindow();

waitfor(f)
disp('DONE!')
end