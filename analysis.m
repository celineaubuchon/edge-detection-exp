%analysis of experiment
%% Pulling Human Data
datafile = fopen('data/junk.txt', 'r');
A = fscanf(datafile, '%s %i %s %s');

%probe_array
%% Pulling data
computerData = imread('images/slothDetected.jpg');
 
originalImage = imread('images/sloth.jpg');


%pull the human data for this image
%% Creating figures
%takes in the original images and images from the experiment and overlays with red where edge detection program detected edges
 
computerData(computerData > 200) = 255; %capture values that are almost white to decrease noise when pixels turn red
 
 
computerData = repmat(computerData,[1,1,3]); %turn computerData from black and white to color image
 
 
%separate color channels in computerData
redChannel = computerData(:,:,1); 
greenChannel = computerData(:,:,2);
blueChannel = computerData(:,:,3);
 
%white pixels
whitepixels= redChannel == 255 & greenChannel == 255 & blueChannel == 255;
    
%turn white pixels red
redChannel(whitepixels)=255;
greenChannel(whitepixels)=0;
blueChannel(whitepixels)=0;
 
%recombine color channels
computerData = cat(3, redChannel, greenChannel, blueChannel);
 
%separate color channels in originalImage
redChannelOrig = originalImage(:,:,1);
greenChannelOrig = originalImage(:,:,2);
blueChannelOrig = originalImage(:,:,3);
 
%turn white pixels red
redChannelOrig(whitepixels)=255;
greenChannelOrig(whitepixels)=0;
blueChannelOrig(whitepixels)=0;
originalImage = cat(3, redChannelOrig, greenChannelOrig, blueChannelOrig);
 
%display images with red where edge detection program detected edges
imshow(computerData);
imshow(originalImage);
