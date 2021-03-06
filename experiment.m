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

% sets regonizable names for keycodes
enter = KbName('Return');
left = KbName('LeftArrow'); right = KbName('RightArrow');

% These will be "utility" keys
spaceKey = KbName('space'); escKey = KbName('ESCAPE');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probabily a good place to set up a file to write data to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% show experiment instructions

% Draw a new black rectangle on the mainwin buffer
Screen('FillRect', mainwin, [0 0 0]);
% set the size of the text
Screen('TextSize', mainwin, 50);
% write text to mainwin buffer
DrawFormattedText(mainwin, ['press spacebar'], ...
    'center', 'center', [255 255 255  ]);
%Draw what is currently in mainwin buffer
Screen('Flip', mainwin);

% start infinite loop to wait for keypresses
    % if user presses the space bar, break out out of the loop and continue
    % the experiment
    % if user presses the escape key, close window and end experiment
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break;
        elseif keyCode(escKey)
            ShowCursor;
            Screen('CloseAll');
            return;
        end
    end
end

% Draw a new black rectangle on the mainwin buffer
Screen('FillRect', mainwin, [0 0 0]);
% add stimulus drawing to mainwin buffer
drawStimulus(mainwin, center, "images/tserre.jpg");
% draw mainwin buffer
Screen(mainwin, 'Flip'); % draw whats in the mainwin buffer

%main trial loop
keyIsDown = 0;

% start infinite loop to wait for keypresses
    % if user presses the space bar, save data and advance trial
    % if user presses the escape key, close window and end experiment
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            % advance trial 
        elseif keyCode(escKey)
            ShowCursor;
            Screen('CloseAll');
            return;
        end
    end
end


%% Draw Functions
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






