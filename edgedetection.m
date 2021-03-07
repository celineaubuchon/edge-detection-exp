%% EDGE DETECTION PROGRAM %%

% This script will implement basic sobel edge detection, and preform edge
% detection on some images, saving the results in a folder

%% Setup
    % load in our images
    
    
%% Main script
    % preforms the operations
    %img = imread("images/tserre.jpg");
    %convolve(zeros(10,10), img);
    img = ones(100) * 255/2;
    convolve(zeros(10,10), img);
    
    

%% Functions
    % functions we will write to be called in main script
    
    % ColorToGray Function
    % Convolution Function (1D or 2D convolution?
        % What will w edo when the parts of the kernel are outside our
        % image boundaries? 
    % (?) functions that load in images, and save our output images? Or
    % just put this code in the main script?
  % pair coded this section for 2 hours  
function edgeMatrix = convolve(kernel, photo) %output = matrix of gradient magnitudes (dimensions same as photo)
    photo = photo(:,:,1); 
    % im2bw(photo);
    photoSize = size(photo);
    kernelSize = size(kernel);
    kWidth = floor(kernelSize(2));
    horizEdge = zeros(photoSize); %copy matrix to fill in horizontal
    
    %output = horizontal convolution matrix (w/ photo dimensions)
    for col = 1:size(photo, 2)
        for row = 1:size(photo, 1)
            sum1 = 0;
            for k = 1:kWidth
                if ~(row - kWidth/2 + k -1 < 0) && ~(row - kWidth/2 + k - 1 > size(photo, 1)) %if indice of kernel exists on photo (if doesn't leak off left side and doesn't leak over on right side.)
                 %We originally put || up there ^^ but I think that's wrong so I changed it -Megan
                    pix = photo(row - kWidth/2 + k -1, col); %value of photo pixel
                    weight = kernel(k); %value of kenerl indice overlapping indice
                    sum1 = sum1 + pix*weight;
                end
            end
            horizEdge(row, col) = sum1;
        end
    end

%Megan worked on vertEdge - 1.5 hours
%output = vertical convolution matrix w/ photo's dimensions
%didn't flip photo, instead flipped kernel
    bigKernel = [1 0 -1; 2 0 -2; 1 0 -1];
    kernel = bigKernel'(1, :);
    kWidth = floor(size(kernel, 2));
    vertEdge = zeros(size(photo)); %copy matrix to fill in
    
    for col = 1:size(photo, 2)
        for row = 1:size(photo, 1)
            sum2 = 0;
            for k = 1:kWidth
                if ~ (row - kWidth/2 + k -1 < 0) || ~(row - kWidth/2 + k - 1 > photoSize(1)) 
                    pix = photo(row - kWidth/2 + k -1, col); %value of photo pixel
                    weight = kernel(k); %value of kernel indice overlapping pix
                    sum2 = sum2 + pix*weight; %running sum of product of surrounding kernel and pixel values
                end
            end
            vertEdge(row, col) = sum2*bigKernel'(:, 1); %based off wiki, need to check horizEdge after consulting group -M
        end
    end
    
    %Megan-combined edgeMatrix/gradient magnitude
    edgeMatrix = (horizEdge.^2 + vertEdge.^2).^0.5; %need to change vertEdge dimensions at some point before now    
end

function colorEdge = convolveColor(kernel, photo)
%for loop color channel 1
    %output = redgradientmag

%for loop for color channel 2
    %output = greengradientmag

%for loop for color channel 3
    %output = bluegradientmag
    
%if red || green || blue > threshold, then there's an edge

%hypothesis: as color hex codes get closer, more difficult for humn eye to discern difference but computer is able to.
end


     
%% Notes (should be deleted later)

% Sobel edge detection is preformed by convolving image matrix's using a
% vertical and horizontal sobel operator (this is the 'kernel').

% x_kernel = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
% y_kernel = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

%What M found on Wikipedia: https://en.wikipedia.org/wiki/Sobel_operator
   %x_kernel = [1 2 1]'*([1 0 -1]*photo)
   %y_kernel = [1 0 -1]'*([1 2 1]*photo) I'm having trouble finding 1D operations

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

% things to do independently:
% orientation of the edge detection
% megan - how to do it for color?
% the statistical tests we want to run and input titles 
% how to create the grain with computer program
% demo video??



%Framing the photo (didn't work)
    %imwrite(photo);
%     framed = zeros(photoSize(1) + kWidth -1, photoSize(2) + kWidth -1);
%     framed(kWidth/2:end-kWidth/2, kWidth/2:end-kWidth/2) = photo;
%     disp(framed(kWidth/2 + 1, 20:25));
%     disp(photo(1,20-kWidth/2:25-kWidth/2));
%     imwrite(framed, "images/result.jpeg");

%From QR_code assignment:
            % (row, col) is current pixel
%             sample_code = photo(row : row + size(QR_code, 1)-1, col : col + size(QR_code, 2)-1);
%             if(isequal(sample_code, QR_code))
%                 detected = true;
%             elseif(isequal(sample_code, rot90(QR_code)))
%                 detected = true;
%             end


% Original vertEdge
% %Megan worked on vertEdge
% %output = vertical convolution matrix w/ photo's dimensions
%     photo = photo(:,:,1);
%     photoFlipped = photo'; %photo matrix flipped
%     kWidth = floor(size(kernel, 2));
%     vertEdge = zeros(size(photoFlipped)); %copy matrix to fill in
%     
%     for col = 1:size(photoFlipped, 2)
%         for row = 1:size(photoFlipped, 1)
%             sum2 = 0;
%             for k = 1:kWidth
%                 if ~ (row - kWidth/2 + k -1 < 0) || ~(row - kWidth/2 + k - 1 > photoSize(1)) 
%                     pix = photoFlipped(row - kWidth/2 + k -1, col); %value of photo pixel
%                     weight = kernel(k); %value of kernel indice overlapping pix
%                     sum2 = sum2 + pix*weight; %running sum of product of surrounding kernel and pixel values
%                 end
%             end
%             vertEdge(row, col) = sum2*[1; 2; 1]; %based off wiki, need to check vertEdge after consulting group -M
%         end
%     end
