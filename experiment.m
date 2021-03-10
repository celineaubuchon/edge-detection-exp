%% EXPERIMENT CODE %%

% This script will will run our behavioral experiment.

%% Clean start
clear; % clears all variables
Screen('Preference', 'SkipSyncTests', 1); % Disables timing tests that we 
%don't need

screen_number = Screen('Screens'); % label the screen with a number
screen_specs = Screen('Resolution', screen_number); % get the specs of the 
%labeled screen

%% Keyboard Setup
KbName('UnifyKeyNames'); % Cross-platform compatibility

% sets recognizable names for keycodes
enter = KbName('Return');
left = KbName('LeftArrow'); right = KbName('RightArrow');

% these will be for utilities 
spaceKey = KbName('space'); escKey = KbName('ESCAPE'); 

%% Setup Data file 
% prompts for subject information and opens a file to write data into

prompt = {'Subject Initials'};
default = {'junk'};

answer = inputdlg(prompt, 'Experiment', 1, default);
subj = answer{1};

% create filepath name for subject's data file
outputfilename = strcat('data\', subj, '.txt');

% open the data file to write to
datafile = fopen(outputfilename, 'wt');

% print the column titles to the data file
fprintf(datafile, 'subj\t trial\t stim\t probearray\t\n');

%% Conditions
% set up the conditional variables
    % repetitions
    % stim: each image
    % scan line: 1 2

reps = 3; % number of repetitions per image
stimuli = ["tserre.jpg", "sloth.jpg"]; % image names

stim_count = length(stimuli); % number of images

totalTrials = reps * stim_count; % total number of trials

% create random trial order
stim_order = zeros(1, totalTrials); % array of zeros to be populated with 
%the random image order

% populate stim order with the number of images that will be display, with
% repetitions
i = 1;
for r = 1:reps
    for stm = 1:stim_count
        stim_order(i) = stm;
        i = i + 1;
    end
end

% randomly re-order stim_order to create a random trial order
stim_order = stim_order(randperm(length(stim_order)));

%% Window Setup
% gets a buffer for the window, mainwin, and the screen dimensions,
% screenrect
[mainwin, screenrect] = Screen('OpenWindow', screen_number);
width = screenrect(3); % width of screen 
height = screenrect(4); % height of screen
Screen('FillRect', mainwin, [0 0 0]); % Fills mainwin with black
center = [width/2 height/2]; % Get center coords
Screen(mainwin, 'Flip'); % Show what has been drawn so far in mainwin


%% Experiment

% We will present information to the subject by 'drawing' it on mainwindow
% We can do this by drawing things in the mainwin buffer, and then calling 
% 'Flip' to show everything in the buffer. The buffer holds all of the 
% drawings we make until we are ready to show them.

HideCursor; % hides the users cursor
%ListenChar(2) % stops keyboard interaction with command window

% show experiment instructions

% Draw a new black rectangle on the mainwin buffer
Screen('FillRect', mainwin, [0 0 0]);
% set the size of the text
Screen('TextSize', mainwin, 50);
% write text to mainwin buffer
DrawFormattedText(mainwin, ['press spacebar'], ...
    'center', 'center', [255 255 255]);
%Draw what is currently in mainwin buffer
Screen('Flip', mainwin);

% start infinite loop to wait for keypresses
    % if user presses the space bar, break out of the loop and continue
    % the experiment
    % if user presses the escape key, close window and end experiment
while 1
    [keyIsDown, secs, keyCode] = KbCheck; % checks keyboard activity
    if keyIsDown % if a key is pressed
        if keyCode(spaceKey) % check if its the space key
            KbReleaseWait; % wait for a key to be released to continue the loop
            break; % if so, break out of the loop and continue
        elseif keyCode(escKey) % if the key is esc, close program
            fclose(datafile);
            ShowCursor;
            Screen('CloseAll');
            return;
        end
    end
end

% MAIN TRIAL LOOP

% initialize some variables
keyIsDown = 0; % bool representing if a key is pressed
offset = 0; % num of pixels from left edge that the probe has been moved

probe_points = []; % empty array to store the probe point x coordinates
moving_probe = false; % boolean indicating if a probe is being adjusted

trial = 1; % trial number, this is the first trial so trial = 1
stim = stim_order(trial); % get the current stim by indexing stim_order
% by trial

% start infinite loop to wait for keypresses
    % if user presses the space bar, save data and advance trial
    % if user presses enter, set probe point
    % if user presses the escape key, close window and end experiment
    % if user presses right or left, move probe point
    
while 1
    [keyIsDown, secs, keyCode] = KbCheck; % check for keyboard activity
    FlushEvents('keyDown'); % clear queue of keypresses
    if keyIsDown % if a key is pressed
        if keyCode(right) % if the key is right
            offset = min(offset + 5, 500); % add to the offset
            if moving_probe % if there is a probe to be adjusted
                probe_points(end) = floor(offset); % update probe value in array
            else % if there is no current probe
                moving_probe = true; % set moving_probe to true
                probe_points(end + 1) = offset; % add a probe to the array
            end
        elseif keyCode(left)% if the key is left
            offset = max(offset - 5, 0); % substract from offset
            probe_points(end) = floor(offset); % update the recent probe in the array
        elseif keyCode(enter) % if the key is enter
            moving_probe = false; % set the current probe's position
        elseif keyCode(spaceKey) % if the key is space
            writeSubjData(datafile, subj, trial, stimuli(stim), probe_points);
            offset = 0; % reset the offset value for a new trial
            probe_points = []; % reset probe points array for new trial
            if trial < totalTrials % if it wasn't the last trial
                trial = trial + 1; % set trial to next trial
                stim = stim_order(trial); % get new stim index
            else % if all trials were completed
                endExperiment(mainwin, datafile); % end the experiment
                Screen('CloseAll'); % close all screens
                return;
            end
            
        elseif keyCode(escKey) % if the key was escape
            fclose(datafile); % close the data file
            ShowCursor; % show the cursor
            ListenChar(1); % returns keyboard to command window
            Screen('CloseAll'); % close all screens
            return;
        end
        KbReleaseWait; % wait for a key to be released to continue the loop
    else % if a key wasn't pressed
        % Draw a new black rectangle on the mainwin buffer
        Screen('FillRect', mainwin, [0 0 0]);
        % add stimulus drawing to mainwin buffer
        drawStimulus(mainwin, center, strcat("images/", stimuli(stim)));
        % add probe drawing to mainwin buffer
        drawProbe(mainwin, center, probe_points);
        % draw mainwin buffer
        Screen(mainwin, 'Flip'); % draw whats in the mainwin buffer
    end
    keyIsDown = 0; keyCode = 0;
end

%% Functions
% functions we write that draw stuff we need. These will be called in the 
% Experiment section

function drawStimulus(mainwin, center, currStimPath)
    % drawStimulus reads in the image from currStimPath and adds it to the 
        % mainwin buffer in the form of a texture centered on the screen
        % it has no output
    img = imread(currStimPath); % reads in image from currStimPath
    img = imresize(img, [500 500]); % resizes the image to 500x500
    imgsize = size(img); % gets dimension of the img
    tex = Screen('MakeTexture', mainwin, img); % makes a texture out of img
    
    % DrawTexture takes in mainwin, texture pointer, texture source,
    % destination rect
    dest_rec = [center(1)-imgsize(2)/2 center(2)-imgsize(2)/2 ...
        center(1)+imgsize(2)/2 center(2)+imgsize(2)/2];
    Screen('DrawTexture', mainwin, tex, [0 0 imgsize(2) imgsize(1)],...
        dest_rec);
end

function drawProbe(mainwin, center, probe_points)
    %%% draw scan line %%%
    xTop = center(1)-250;
    xBot = center(1)+250;
    yTop = center(2)-7; 
    yBot = center(2)+7;
    
    % draws outline of rectangle
    Screen('FrameRect', mainwin, [255 0 0], [xTop yTop xBot yBot], 3);
    
    % draw prob points
    for p = 1:length(probe_points)
        if ~isempty(probe_points)
            move = probe_points(p);
            Screen('DrawLine', mainwin, [255 0 0], ...
                xTop + move, yTop, xTop + move, yBot, 3);
        end
    end
end

% trial functions

function endExperiment(mainwin, datafile)
    Screen('FillRect', mainwin, [0 0 0]);
    DrawFormattedText(mainwin, ['Experiment over :) closing now'], ...
        'center', 'center', [255 255 255]);
    Screen('Flip', mainwin);
    fclose(datafile);
    ShowCursor;
    ListenChar(1);
    pause(3);
end

function writeSubjData(datafile, initials, trial, stim, probePoints)
    count = length(probePoints);
    arraySpec = repmat(' %i', 1, count);
    fprintf(datafile, strcat('%s %i %s', arraySpec,'\n'),...
        initials, trial, stim, probePoints);
end





