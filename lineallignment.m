vidReader = vision.VideoFileReader('vpk.mp4');
vidReader.VideoOutputDataType = 'double';

diskElem = strel('disk',3);
hBlobAnalysis = vision.BlobAnalysis();


vidPlayer = vision.DeployableVideoPlayer;

while ~isDone(vidReader)
    vidFrame = step(vidReader);
    
    % Convert RGB image to chosen color space
    I = rgb2hsv(vidFrame);

    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 0.369;
    channel1Max = 0.251;

    % Define thresholds for channel 2 based on histogram settings
    channel2Min = 0.000;
    channel2Max = 0.258;

    % Define thresholds for channel 3 based on histogram settings
    channel3Min = 0.000;
    channel3Max = 1.000;

    % Create mask based on chosen histogram thresholds
    sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    
    Res=imopen(BW,diskElem);
    
    [~,objCentroid,bboxOut] = step(hBlobAnalysis,Res);
    Ishape=insertShape(vidFrame,'rectangle',bboxOut,'Linewidth',15);
    text = ['Centroid: ' num2str(objCentroid(1))];
    RGB = insertText(Ishape,[400,250],text,'FontSize',18,'BoxColor',...
    'yellow','BoxOpacity',0.4,'TextColor','white');
    step(vidPlayer,RGB);
end

release(vidReader)
release(hBlobAnalysis)
release(vidPlayer)