% Chapter 4 Practice 1: Basic Morphological Operations

% 2.1 Loading Required Package
pkg load image;

% 2.2 Reading and Binarizing an Image
img = imread('../images/coins.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);
figure;
imshow(binary_img);
title('Binary Input Image');

% 3.1 Creating a Structuring Element
se = strel('square', 3);  % 3x3 square structuring element

% 4.1 Erosion
eroded_img = imerode(binary_img, se);
figure;
imshow(eroded_img);
title('Eroded Image');

% 4.2 Dilation
dilated_img = imdilate(binary_img, se);
figure;
imshow(dilated_img);
title('Dilated Image');
