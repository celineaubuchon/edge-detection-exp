%analysis of experiment
%% Pulling Human Data

% change the file path to 'data/(your data).txt' inorder to see how you
% measure up compared to our sobel edge detector!
datafile = fopen('data/ca1.txt', 'r');

% set up arrays to hold data based on image
% collapses all data from all trials
tserreData = [];
slothData = []; 
logoData = [];

tserreb1Data = [];
slothb1Data = []; 
logob1Data = [];

tserreb2Data = [];
slothb2Data = []; 
logob2Data = [];

% read file line by line
% fgetl grabs the next line of a text file
currLine = fgetl(datafile); % skipping this first line (just column names)
currLine = fgetl(datafile); % starting with this line
while ischar(currLine) % while currLine is a string (has data)
    string_data = strsplit(currLine); % cell array of string data from currLine
    % read subject name, idx 1 (skip for now)
    % read trial number, idx 2 (skip for now)
    % read image name, idx 3
    % read probe data, idx 4 to idx end
    probe_data = []; % initialize empy container for probe data
    
    % loop thtough string_data to populate probe_data
    for i = 4:length(string_data) 
        % adds probe point to probe data array as int
        probe_data = [probe_data, str2num(string_data{i})];
    end
    if string_data{3} == "tserre.jpg"
        % add probe points to tserreData
        tserreData = [tserreData, probe_data];
    end
    if string_data{3} == "sloth.jpg"
        % add probe points to slothData
        slothData = [slothData, [probe_data]];
    end 
    if string_data{3} == "logo.jpg"
        % add probe points to slothData
        logoData = [logoData, [probe_data]];
    end 
    if string_data{3} == "tserre_blur1.jpg"
        % add probe points to tserreData
        tserreb1Data = [tserreb1Data, probe_data];
    end
    if string_data{3} == "sloth_blur1.jpg"
        % add probe points to slothData
        slothb1Data = [slothb1Data, [probe_data]];
    end 
    if string_data{3} == "logo_blur1.jpg"
        % add probe points to slothData
        logob1Data = [logob1Data, [probe_data]];
    end 
    if string_data{3} == "tserre_blur2.jpg"
        % add probe points to tserreData
        tserreb2Data = [tserreb2Data, probe_data];
    end
    if string_data{3} == "sloth_blur2.jpg"
        % add probe points to slothData
        slothb2Data = [slothb2Data, [probe_data]];
    end 
    if string_data{3} == "logo_blur2.jpg"
        % add probe points to slothData
        logob2Data = [logob2Data, [probe_data]];
    end 
    % get next line of file
    currLine = fgetl(datafile);
end

% convert probe data to image rows representing edges
tserre_human_row = zeros(1, 500); % an image row is 500px
tserreb1_human_row = zeros(1, 500);
tserreb2_human_row = zeros(1, 500);

sloth_human_row = zeros(1, 500);
slothb1_human_row = zeros(1, 500);
slothb2_human_row = zeros(1, 500);

logo_human_row = zeros(1, 500);
logob1_human_row = zeros(1, 500);
logob2_human_row = zeros(1, 500);

%%%%%%%%%%%%%%%%%%%%%%%%% POPULATING IMAGE ROWS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tserre data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for p = tserreData
    tserre_human_row(p) = 1;
end

for p = tserreb1Data
    tserreb1_human_row(p) = 1;
end

for p = tserreb2Data
    tserreb2_human_row(p) = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sloth data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for p = slothData
    sloth_human_row(p) = 1;
end

for p = slothb1Data
    slothb1_human_row(p) = 1;
end

for p = slothb2Data
    slothb2_human_row(p) = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% logo data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for p = logoData
    logo_human_row(p) = 1;
end

for p = logob1Data
    logob1_human_row(p) = 1;
end

for p = logob2Data
    logob2_human_row(p) = 1;
end

% at this point, all of the human_data arrays are populated with data


%% Creating Images
comp_tserreData = imread('images/tserreDetected.jpg');
comp_slothData = imread('images/slothDetected.jpg');
comp_logoData = imread('images/logoDetected.jpg');

comp_tserreb1Data = imread('images/tserre_blur1Detected.jpg');
comp_slothb1Data = imread('images/sloth_blur1Detected.jpg');
comp_logob1Data = imread('images/logo_blur1Detected.jpg');

comp_tserreb2Data = imread('images/tserre_blur2Detected.jpg');
comp_slothb2Data = imread('images/sloth_blur2Detected.jpg');
comp_logob2Data = imread('images/logo_blur2Detected.jpg');

tserreImage = imread('images/tserre.jpg');
slothImage = imread('images/sloth.jpg');
logoImage = imread('images/logo.jpg');

tserreb1Image = imread('images/tserre.jpg');
slothb1Image = imread('images/sloth_blur1.jpg');
logob1Image = imread('images/logo_blur1.jpg');

tserreb2Image = imread('images/tserre_blur2.jpg');
slothb2Image = imread('images/sloth_blur2.jpg');
logob2Image = imread('images/logo_blur2.jpg');


%blurTime("sloth");
t_annotated = overlayHumanData(tserreImage, tserre_human_row, comp_tserreData);
s_annotated = overlayHumanData(slothImage, sloth_human_row, comp_slothData);
l_annotated = overlayHumanData(logoImage, logo_human_row, comp_logoData);

t_b1_annotated = overlayHumanData(tserreb1Image, tserreb1_human_row, comp_tserreb1Data);
s_b1_annotated = overlayHumanData(slothb1Image, slothb1_human_row, comp_slothb1Data);
l_b1_annotated = overlayHumanData(logob1Image, logob1_human_row, comp_logob1Data);

t_b2_annotated = overlayHumanData(tserreb2Image, tserreb2_human_row, comp_tserreb2Data);
s_b2_annotated = overlayHumanData(slothb2Image, slothb2_human_row, comp_slothb2Data);
l_b2_annotated = overlayHumanData(logob2Image, logob2_human_row, comp_logob2Data);

figure(1); title('No Noise: red = computer, green = human');
subplot(3, 1, 1); imshow(l_annotated); title('logo');
subplot(3, 1, 2); imshow(s_annotated); title('sloth');
subplot(3, 1, 3); imshow(t_annotated); title('tserre');

figure(2); title('Noise 1: red = computer, green = human');
subplot(3, 1, 1); imshow(l_b1_annotated); title('logo blur 1');
subplot(3, 1, 2); imshow(s_b1_annotated); title('sloth blur 1');
subplot(3, 1, 3); imshow(t_b1_annotated); title('tserre blur 1');

figure(3); title('Noise 2: red = computer, green = human');
subplot(3, 1, 1); imshow(l_b2_annotated); title('logo blur 2');
subplot(3, 1, 2); imshow(s_b2_annotated); title('sloth blur 2');
subplot(3, 1, 3); imshow(t_b2_annotated); title('tserre blur 2');



%% Functions
function resultImage = overlayImage(computerData, originalImage)
    computerData(computerData > 200) = 255; %capture values that are almost white to decrease noise when pixels turn red
 
    compData = repmat(computerData,[1,1,3]); %turn computerData from black and white to color image
    originalImage = repmat(originalImage,[1,1,3]);
 
    %separate color channels in computerData
    redChannel = compData(:,:,1); 
    greenChannel = compData(:,:,2);
    blueChannel = compData(:,:,3);
 
    %white pixels
    whitepixels= redChannel == 255 & greenChannel == 255 & blueChannel == 255;
    
    %turn white pixels red
    redChannel(whitepixels)=255;
    greenChannel(whitepixels)=0;
    blueChannel(whitepixels)=0;
 
    %recombine color channels
    compData = cat(3, redChannel, greenChannel, blueChannel);
 
    %separate color channels in originalImage
    redChannelOrig = originalImage(:,:,1);
    greenChannelOrig = originalImage(:,:,2);
    blueChannelOrig = originalImage(:,:,3);
 
    %turn white pixels red
    redChannelOrig(whitepixels)=255;
    greenChannelOrig(whitepixels)=0;
    blueChannelOrig(whitepixels)=0;

    %recombine color channels
    origImage = cat(3, redChannelOrig, greenChannelOrig, blueChannelOrig);

 
    %display images with red where edge detection program detected edges
    %figure(1);
    %subplot(1, 1, 1);
    %imshow(compData);
    %imshow(origImage);
    resultImage = origImage;
end

function returnImg = overlayHumanData(originalImage, humanData, compData)
    overlay = overlayImage(compData, originalImage);
    originalImage = overlay;
    humanData = logical(humanData);
    orig_red = originalImage(250,:,1);
    orig_green = originalImage(250,:,2);
    orig_blue = originalImage(250,:,3);
    
    orig_red(humanData) = 0;
    orig_green(humanData) = 255;
    orig_blue(humanData) = 0;
    
    for i = 248:252
        originalImage(i,:, 1) = orig_red;
        originalImage(i,:, 2) = orig_green;
        originalImage(i,:, 3) = orig_blue;
    end
    
    %imshow(originalImage(241:260, :, :));
    returnImg = originalImage(241:260, :, :);
end

function funGif = blurTime(fileName)
    for jj = 0:0.01:0.5 %increments of blur
        oimage = imread(strcat("blurred/",fileName,"blur",num2str(jj),".jpg"));
        image = imread(strcat("blurred/",fileName,"blur",num2str(jj),"Detected",".jpg"));
        [compData, origImage] = overlayImage(image, oimage);
    
        figure(1);hold all
        subplot(1, 3, 1); imshow(oimage); title('Original Image'); %original image with increasing noise
        subplot(1, 3, 2); imshow(image); title('Computer Sees'); %edge detection image 
        subplot(1, 3, 3); imshow(compData); imshow(origImage); title('Overlay'); %Overlay image
        pause(0.001);
    end
end