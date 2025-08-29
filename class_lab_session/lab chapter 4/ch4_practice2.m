% Chapter 4 Practice 2: Opening and Closing Operations

% Load required package
pkg load image;

% Read and binarize image
img = imread('../images/coins.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);

% Create structuring element
se = strel('square', 3);

% 4.3 Opening
opened_img = imopen(binary_img, se);
figure;
imshow(opened_img);
title('Opened Image');

% 4.4 Closing
closed_img = imclose(binary_img, se);
figure;
imshow(closed_img);
title('Closed Image');
