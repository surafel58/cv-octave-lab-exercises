% Chapter 1 Practice 2: Loading and Displaying Standard Test Images

% 2.2 Reading and Displaying an Image
img = imread('../images/cameraman.tif');
figure;
imshow(img);
title('Original Image');