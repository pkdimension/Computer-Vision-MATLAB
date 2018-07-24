
cam = webcam(1)
preview(cam)
img = snapshot(cam);




I = rgb2ycbcr(img);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 66.000;
channel2Max = 111.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 112.000;
channel3Max = 173.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;



diskElem = strel('disk',15);
Res=imopen(BW,diskElem);

hBlobAnalysis = vision.BlobAnalysis();
[objArea,~,~] = step(hBlobAnalysis,Res);




if max(objArea)>25000
   RGB = insertText(img,[400,250],'Golden','FontSize',18,'BoxColor',...
    'yellow','BoxOpacity',0.4,'TextColor','white');    
    
    imshow(RGB)
    title('pk1')
else
    RGB = insertText(img,[400,250],'Normal','FontSize',18,'BoxColor',...
    'yellow','BoxOpacity',0.4,'TextColor','white');    
    
    imshow(RGB)
    title('pk2')
end



closePreview(cam);
delete(cam)

