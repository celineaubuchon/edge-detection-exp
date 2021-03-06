%% EDGE DETECTION PROGRAM %%

% This script will implement basic sobel edge detection, and preform edge
% detection on some images, saving the results in a folder

%% Setup
    % load in our images
    
    
%% Main script
    % preforms the operations
    img = imread("images/tserre.jpg");
    convolve(zeros(10,10), img);
    

%% Functions
    % functions we will write to be called in main script
    
    % ColorToGray Function
    % Convolution Function (1D or 2D convolution?
        % What will w edo when the parts of the kernel are outside our
        % image boundaries? 
    % (?) functions that load in images, and save our output images? Or
    % just put this code in the main script?
    
function framed = convolve(kernel, photo)
    photo = im2bw(photo);
    photoSize = size(photo);
    kernelSize = size(kernel);
    kWidth = floor(kernelSize(2));
    
    framed = zeros(photoSize(1) + kWidth, photoSize(2) + kWidth);
    framed(kWidth/2:end-kWidth/2, kWidth/2:end-kWidth/2) = photo;
    
    imshow(framed);
    
    for col = 1:size(framed, 2)
        for row = 1:size(framed, 1)
            % (row, col) is current pixel
%             sample_code = photo(row : row + size(QR_code, 1)-1, col : col + size(QR_code, 2)-1);
%             if(isequal(sample_code, QR_code))
%                 detected = true;
%             elseif(isequal(sample_code, rot90(QR_code)))
%                 detected = true;
%             end
        end
    end
end

     
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

