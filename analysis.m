%analysis of experiment
%% Pulling Human Data
datafile = fopen('data/junk.txt', 'r');
%A = fscanf(datafile, '%s %i %s %s', 4);
%A

% set up arrays to hold data based on image
% collapses all data from all trials
tserreData = [];
slothData = []; 

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
    
    % if the image for this trial was of tserre
    if string_data{3} == "tserre.jpg"
        % add probe points to tserreData
        tserreData = [tserreData, probe_data];
    end
    % if the image for this trial was of sloth
    if string_data{1} == "sloth.jpg"
        % add probe points to slothData
        slothData = [slothData, [probe_data]];
    end 
    % get next line of file
    currLine = fgetl(datafile);
end

% convert probe data to image rows representing edges

% just with tserre as an example
tserre_human_row = zeros(1, 500);
% for every
for p = tserreData
    tserre_human_row(p) = 1;
end
% this is just to show the edges to be taller so it is easier to see while
% we are testing
test = zeros(5, 500);
test(1, :) = tserre_human_row;
test(2, :) = tserre_human_row;
test(3, :) = tserre_human_row;
test(4, :) = tserre_human_row;
test(5, :) = tserre_human_row;
imshow(test);

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
