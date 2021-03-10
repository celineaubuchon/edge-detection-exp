%analysis of experiment
%% Pulling Human Data
datafile = fopen('data/junk.txt', 'r');
A = fscanf(datafile, '%s %i %s %s');
A
%probe_array
%% Pulling data
computerData = imread('images/slothDetected.jpg');
 
originalImage = imread('images/sloth.jpg');
%originalImage = zeros(500,500,3);
%originalImage(250,:,:) = ones(1,500,3);


%pull the human data for this image
%% Creating graphs
%index to (250,:)row 250 by all the columns
%index by computer data and whichever pixels equal 1 we color red and index
%and show that row (for both humans and computer)
%first for the computer data 
 
%computerData(250,:)
 
%originalImage(250,:)
%matrix = zeros(size(computerData));
 
computerData(computerData > 200) = 255;
 
 
computerData = repmat(computerData,[1,1,3]);
 
 
redChannel = computerData(:,:,1);
greenChannel = computerData(:,:,2);
blueChannel = computerData(:,:,3);
 
whitepixels= redChannel == 255 & greenChannel == 255 & blueChannel == 255;
%whitepixels = logical(computerData == 1);
    
 
redChannel(whitepixels)=255;
greenChannel(whitepixels)=0;
blueChannel(whitepixels)=0;
 
computerData = cat(3, redChannel, greenChannel, blueChannel);
 
redChannelOrig = originalImage(:,:,1);
greenChannelOrig = originalImage(:,:,2);
blueChannelOrig = originalImage(:,:,3);
 
redChannelOrig(whitepixels)=255;
greenChannelOrig(whitepixels)=0;
blueChannelOrig(whitepixels)=0;
originalImage = cat(3, redChannelOrig, greenChannelOrig, blueChannelOrig);
 
imshow(computerData);
imshow(originalImage);
 
% computerData = cat(3, computerData, computerData, computerData);
% computerData = computerData/255;
% computerData(250,computerData==1) = 255;
% imshow(computerData);
 
%disp(size(originalImage));
%disp(size(computerData));
%disp(computerData(:,:,3));
%disp(max(max(computerData)));
