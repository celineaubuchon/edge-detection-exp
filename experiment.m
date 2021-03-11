%% EXPERIMENT CODE %%

% This script will will run our behavioral experiment.
%% Generate Images
% to be used as stimuli
tserre = imread("images/tserre.jpg");
sloth = imread("images/sloth.jpg");
logo = imread("images/Matlab_Logo copy.png");

tserre_blur1 = imnoise(tserre, 'gaussian', 0.2);
tserre_blur2 = imnoise(tserre, 'gaussian', 0.4);

sloth_blur1 = imnoise(sloth, 'gaussian', 0.2);
sloth_blur2 = imnoise(sloth, 'gaussian', 0.4);

logo_blur1 = imnoise(logo, 'gaussian', 0.2);
logo_blur2 = imnoise(logo, 'gaussian', 0.4);

imwrite(tserre_blur1, "images/tserre_blur1.jpg");
imwrite(tserre_blur2, "images/tserre_blur2.jpg");

imwrite(sloth_blur1, "images/sloth_blur1.jpg");
imwrite(sloth_blur2, "images/sloth_blur2.jpg");

imwrite(logo, "images/logo.jpg");
imwrite(logo_blur1, "images/logo_blur1.jpg");
imwrite(logo_blur2, "images/logo_blur2.jpg");

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

outputfilename = strcat('data\', subj, '.txt');

if ~exist('data', 'dir')
    disp('made directory');
    mkdir('data');
end

datafile = fopen(outputfilename, 'wt');
fprintf(datafile, 'subj\t trial\t stim\t probearray\t\n');

%% Conditions

% set up the conditional variables
    % repetitions
    % stim: each image, and each image rotated 90 
    % scan line: 1 2

reps = 1; 
stimuli = ["tserre.jpg", "sloth.jpg", "logo.jpg", ... 
    "tserre_blur1.jpg", "sloth_blur1.jpg", "logo_blur1.jpg",...
    "tserre_blur2.jpg", "sloth_blur2.jpg", "logo_blur2.jpg"];

stim_count = length(stimuli);

totalTrials = reps * stim_count;

% create random trial order
stim_order = zeros(1, totalTrials);

i = 1;
for r = 1:reps
    for stm = 1:stim_count
        stim_order(i) = stm;
        i = i + 1;
    end
end


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
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            KbReleaseWait;
            break;
        elseif keyCode(escKey)
            fclose(datafile);
            ShowCursor;
            Screen('CloseAll');
            return;
        end
    end
end

%main trial loop

keyIsDown = 0;
offset = 0;

probe_points = [];
moving_probe = false;

trial = 1;
stim = stim_order(trial);

% start infinite loop to wait for keypresses
    % if user presses the space bar, save data and advance trial
    % if user presses enter, set probe point
    % if user presses the escape key, close window and end experiment
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    FlushEvents('keyDown');
    if keyIsDown
        if keyCode(right)
            offset = min(offset + 5, 500);
            if moving_probe
                sz = length(probe_points);
                probe_points(sz) = floor(offset);
            else
                moving_probe = true;
                probe_points = [probe_points, offset];
            end
        elseif keyCode(left)
            if(moving_probe)
                offset = max(offset - 5, 0);
                sz = length(probe_points);
                probe_points(sz) = floor(offset);
            end
        elseif keyCode(enter)
            moving_probe = false;
        elseif keyCode(spaceKey)
            writeSubjData(datafile, subj, trial, stimuli(stim), probe_points)
            offset = 0;
            probe_points = [];
            if trial < totalTrials
                trial = trial + 1;
                stim = stim_order(trial);
            else
                endExperiment(mainwin, datafile);
                Screen('CloseAll');
                return;
            end
            
        elseif keyCode(escKey)
            fclose(datafile);
            ShowCursor;
            ListenChar(1); % returns keyboard to command window
            Screen('CloseAll');
            return;
        end
        KbReleaseWait;
    else
        % Draw a new black rectangle on the mainwin buffer
        Screen('FillRect', mainwin, [0 0 0]);
        % add stimulus drawing to mainwin buffer
        drawStimulus(mainwin, center, strcat("images/", stimuli(stim)));
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

function writeSubjData(datafile, subj, trial, image, probe_points)
    probe_string = repmat(' %i', 1, length(probe_points));
    fprintf(datafile, strcat('%s %i %s', probe_string, '\n'),...
        subj, trial, image, probe_points);
end






