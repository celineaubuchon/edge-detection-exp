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
subinit = answer{1};

outputfilename = strcat('data\', subinit, '.txt');

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

reps = 2; 
stimuli = ["tserre.jpg", "sloth.jpg"];


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

disp(stim_order);


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
stim = stimuli(stim_order(trial));

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
                probe_points(end) = floor(offset);
            else
                moving_probe = true;
                probe_points(end + 1) = offset;
            end
        elseif keyCode(left)
            offset = max(offset - 5, 0);
            probe_points(end) = floor(offset);
        elseif keyCode(enter)
            moving_probe = false;
        elseif keyCode(spaceKey)
            offset = 0;
            probe_points = [];
            if trial < totalTrials
                % write the data to the file
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
        DrawFormattedText(mainwin, [int2str(offset)], ...
            100, 100, [255 255 255]);
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






