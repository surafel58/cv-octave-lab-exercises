% Chapter 4 Practice 3: Advanced Morphological Operations

% Load required package
pkg load image;

% Read and binarize image
img = imread('../images/coins.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);

% Create structuring element
se = strel('square', 3);

% 5.1 Morphological Gradient
gradient_img = imdilate(binary_img, se) - imerode(binary_img, se);
figure;
imshow(gradient_img);
title('Morphological Gradient');

% 5.2 Top-hat Transformation
tophat_img = imtophat(binary_img, se);
figure;
imshow(tophat_img);
title('Top-hat Transformed Image');

% 5.3 Bottom-hat Transformation
bothat_img = imbothat(binary_img, se);
figure;
imshow(bothat_img);
title('Bottom-hat Transformed Image');
