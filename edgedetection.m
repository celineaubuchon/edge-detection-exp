%% EDGE DETECTION PROGRAM %%

% This script will implement basic sobel edge detection, and preform edge
% detection on some images, saving the results in a folder

%% Setup
    % load in our images
    
    
%% Main script
    % preforms the operations
    

%% Functions
    % functions we will write to be called in main script
    
    % ColorToGray Function
    % Convolution Function (1D or 2D convolution?
        % What will w edo when the parts of the kernel are outside our
        % image boundaries? 
    % (?) functions that load in images, and save our output images? Or
    % just put this code in the main script?
    

    
%% Notes (should be deleted later)

% Sobel edge detection is preformed by convolving image matrix's using a
% vertical and horizontal sobel operator (this is the 'kernel').

% x_kernel = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
% y_kernel = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

% Convolution is preformed by centering a small matrix, called a kernel,
% over each "pixel" in an image matrix, and using the values of the kernel
% to weight and combine the values of the neighboring pixels in the image.
% The current pixel (where the kernel is centered) is then set to the value
% that resulted from weighting and summing the values of the adjacent
% pixels using the sobel operator.

% The result of this convolution is a black and white image, with white
% values outlining the detected edges.

% Before applying a sobel operator, images are converted to grayscale. It
% can also improve preformance if you blur or 'average' the image matric
% before applying the sobel operators. (This can be done after we achieve
% functionality).


