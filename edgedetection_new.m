%% EDGE DETECTION PROGRAM %%

% This script will implement basic sobel edge detection, and preform edge
% detection on some images, saving the results in a folder

%% Setup
    % load in our images
    
    
%% Main script
    % preforms the operations
    fileVec = ["sloth"];
    for ii = 1:length(fileVec)
        image = imread(strcat("images/",fileVec(ii),".jpg"));
        image = im2gray(image)/255.0;
        %image = imgaussfilt(image, 2); % works well with the clip art
        imageDetected = convolve1D(image, [1 2 1], [1 0 -1]);
        imageDetected2 = rot90(convolve1D(rot90(image), [1 2 1], [1 0 -1]), 3);
        sens = 0.4;
        combined = (imageDetected.^2 + imageDetected2.^2).^0.5 * sens;
        combined(combined > 1) = 1;
        imshow(combined == 1);
        imwrite(combined == 1,strcat("images/",fileVec(ii),"Detected",".jpg"));
    end
        
    img = imread("images/sloth.jpg");
    %imshow(img);
    %img = imread("images/tserre.jpg");
    %convolve(zeros(10,10), img);
    %img = ones(100) * 255/2;
    convolve(zeros(10,10), img);
    
    

%% Functions
    % functions we will write to be called in main script
    
function edges = convolve1D(photo, kH, kV)
% Function to preform 1D convolution using two 1D kernels
    % inputs: a photo matrix, and a kH kernel, and kV kernel (assumed to
    % be the same size and smaller than either dimension of photo
    
    % output: edges, a matrix with the same size as photo representing the
    % output of the convolution
    
    
    photo = photo(:, :, 1); % temporary, grabs one channel of the photo
    photoSize = size(photo); % gets photo size
    kWidth = length(kH); % gets the width of the kernel
    half_kWidth = floor(kWidth/2); % half of kWidth, rounded down 
    
    result1 = zeros(photoSize); % creates an array of zeros to hold the
        % values that we get during convolution
    
    for col = 1:photoSize(2) % for every col in the photo
        for row = 1:photoSize(1) % for every row in the photo
            sum = 0; % an accumulator variable for the new value of the pixel
            for k = 1:kWidth % for each value in the kernel
                if(~(row - half_kWidth + k - 1 < 1) && ...
                        ~(row - half_kWidth + k - 1 > photoSize(1)))
                    % if the kernel centered on (row,col) is within bounds
                    
                    % grabs current pixel
                    pix = photo(row - half_kWidth + k - 1, col);
                    % grabs the current weight from the kernel
                    weight = kH(k);
                    % adds weighted pix value to the accumulated sum
                    sum = sum + pix * weight;
                end
            end
            % sets the corresponding pixel in result1 to the new value
            result1(row, col) = sum;
        end
    end

    %
    result2 = zeros(photoSize); % creates an array of zeros to hold the
        % values that we get during convolution
    
    for col = 1:photoSize(2) % for each col in the photo
        for row = 1:photoSize(1) % for each row in the photo
            sum = 0; % an accumulator variable for the new value of the pixel
            for k = 1:kWidth % for each value in the kernel
                if(~(col - half_kWidth + k - 1 < 1) && ...
                        ~(col - half_kWidth + k - 1 > photoSize(2)))
                    % if the kernel centered on (row,col) is within bounds
                    
                    % grabs the current pixel
                    pix = result1(row, col - half_kWidth + k - 1);
                    % grabs the weight from the kernel
                    weight = kV(k);
                    % adds the weighted value to the accumulated new value
                    sum = sum + pix * weight;
                end
            end
            % sets the corresponding pixel in result1 to the new value
            result2(row, col) = sum;
        end
    end
    % sets the output to result2
    edges = result2;
end


  % pair coded this section for 2 hours  
function edgeMatrix = convolve(kernel, photo) %output = matrix of gradient magnitudes (dimensions same as photo)
    photo = photo(:,:,1);
    %imshow(photo);
    % im2bw(photo);
    photoSize = size(photo);
    kernelSize = size(kernel);
    kWidth = floor(kernelSize(2));
    horizEdge = zeros(photoSize); %copy matrix to fill in horizontal
    
%     %output = horizontal convolution matrix (w/ photo dimensions)
%     for col = 1:size(photo, 2)
%         for row = 1:size(photo, 1)
%             sum1 = 0;
%             for k = 1:kWidth
%                 if ~(row - kWidth/2 + k -1 < 1) && ~(row - kWidth/2 + k - 1 > size(photo, 1))
%                     pix = photo(row - kWidth/2 + k -1, col); %value of photo pixel
%                     weight = kernel(k); %value of kenerl indice overlapping indice
%                     sum1 = sum1 + pix*weight;
%                 end
%             end
%             horizEdge(row, col) = sum1;
%         end
%     end

%Megan worked on vertEdge - 1.5 hours
%output = vertical convolution matrix w/ photo's dimensions
%didn't flip photo, instead flipped kernel

%Horizontal Array
    kernel = [1 2 1];
    kWidth = floor(size(kernel, 2));
    half_kWidth = floor(kWidth/2);
    vertEdge1 = zeros(size(photo)); %copy matrix to fill in
    %imshow(photo);
    for col = 1:size(photo, 2)
        for row = 1:size(photo, 1)
            sum1 = 0;
            for k = 1:kWidth
                if ~(row - half_kWidth +1 + k -1 < 1) && ~(row - half_kWidth +1 + k - 1 > photoSize(1))
                    pix = photo(row - half_kWidth+1 + k -1, col); %value of photo pixel
                    weight = kernel(k); %value of kernel indice overlapping pix
                    sum1 = sum1 + (pix)*weight; %running sum of product of surrounding kernel and pixel values
                %disp(pix);  
                end
            end
            vertEdge1(row, col) = sum1;
            %disp(sum2);
        end
    end
    %imshow(vertEdge1);

    %Vertical Array
    photo1 = vertEdge1;
    kernel = [1; 0; -1];
    kHeight = floor(size(kernel, 1));
    half_kHeight = floor(kWidth/2);
    vertEdge2 = zeros(size(photo1)); %copy matrix to fill in
        
    for col = 1:size(photo1, 2)
        for row = 1:size(photo1, 1)
            sumV2 = 0;
            for k = 1:kHeight
                if ~(col - half_kHeight+1 + k -1 < 1) && ~(col - half_kHeight+1 + k - 1 > photoSize(2))
                    pixV2 = photo1(row, col - half_kHeight+1 + k -1); %value of photo pixel vert
                    weight = kernel(k); %value of kernel indice overlapping pix
                    sumV2 = sumV2 +(pixV2)*weight;
                end
            end
            vertEdge2(row, col) = sumV2;
        end
    end
    edgeMatrix = vertEdge2;
    
    %imshow(vertEdge2);
    
    %combine Verticals
    %edgeMatrix = (horizEdge2.^2 + vertEdge2.^2).^0.5;
    %imshow(edgeMatrix);
    
    %Megan-combined edgeMatrix/gradient magnitude
    %edgeMatrix = (horizEdge.^2 + vertEdge.^2).^0.5; %need to change vertEdge dimensions at some point before now    
%Horizontal Array
    kernel = [1 0 -1];
    kWidth = floor(size(kernel, 2));
    half_kWidth = floor(kWidth/2);
    horizEdge1 = zeros(size(photo)); %copy matrix to fill in
    for col = 1:size(photo, 2)
        for row = 1:size(photo, 1)
            sum1 = 0;
            for k = 1:kWidth
                if ~(row - half_kWidth +1 + k -1 < 1) && ~(row - half_kWidth +1 + k - 1 > photoSize(1))
                    pix = photo(row - half_kWidth+1 + k -1, col); %value of photo pixel
                    weight = kernel(k); %value of kernel indice overlapping pix
                    sum1 = sum1 + (pix)*weight; %running sum of product of surrounding kernel and pixel values
                end
            end
            horizEdge1(row, col) = sum1;
%             if sum1 ~= 255
%             disp(sum1);
%             end
        end
        %imshow(horizEdge1);
    end
    %imshow(horizEdge1);
%         logical = horizEdge1(horizEdge1 ~= 255);
%         disp(size(logical));

    %Vertical Array
    photo1 = horizEdge1;
    kernel = [1; 2; 1];
    kHeight = floor(size(kernel, 1));
    half_kHeight = floor(kWidth/2);
    horizEdge2 = zeros(size(photo1)); %copy matrix to fill in
        
    for col = 1:size(photo1, 2)
        for row = 1:size(photo1, 1)
            sumV2 = 0;
            for k = 1:kHeight
                if ~(col - half_kHeight+1 + k -1 < 1) && ~(col - half_kHeight+1 + k - 1 > photoSize(2))
                    pixV2 = photo(row, col - half_kHeight+1 + k -1); %value of photo pixel vert
                    weight = kernel(k); %value of kernel indice overlapping pix
                    sumV2 = sumV2 +(pixV2)*weight;
                end
            end
            horizEdge2(row, col) = sumV2;
        end
    end
    %imshow(horizEdge2);
edgeMatrix = (vertEdge2.^2 +horizEdge2.^2).^0.5;
%imshow(edgeMatrix);
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

%Analysis: graphs -- Catherine
% graphs to show the success of human trials and the computer in finding the edges of the images. 
% separate graphs first. for the computer for each image graph the
% difference between the actual edge and the detected edge. for the humans
% show each human and the combined human? 
% then another graph showing the difference between the edge detected by
% the humans & the correct edge and the edge detected by the computer and
% the correct edge
% the human edges are detected by mapping points, can compare the correct
% points of the edge and teh points they map in a line graph
% the edges can be mapped by the correct pixels and the colvolved edges and
% the difference between then
%
%

