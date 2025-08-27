% Chapter 2 Exercises: Suggested Exercises

% Load color image
color_img = imread('../images/peppers.png');

% Exercise 1: Convert RGB to grayscale using luminosity method
gray_img = 0.299 * color_img(:,:,1) + 0.587 * color_img(:,:,2) + 0.114 * color_img(:,:,3);
figure;
imshow(uint8(gray_img));
title('Grayscale - Luminosity Method');

% Exercise 3: Histogram equalization on each channel separately
R = color_img(:,:,1);
G = color_img(:,:,2);
B = color_img(:,:,3);

R_eq = histeq(R);
G_eq = histeq(G);
B_eq = histeq(B);

equalized_img = cat(3, R_eq, G_eq, B_eq);
figure;
imshow(equalized_img);
title('Histogram Equalized Image');

% Exercise 2: Interactive brightness adjustment (run separately)
% Run: ch2_interactive_brightness
