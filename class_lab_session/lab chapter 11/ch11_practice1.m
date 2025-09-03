% Chapter 11 Practice 1: Simulating a Transformed Image
% Creates moving image by applying rotation and translation

pkg load image;

% Load fixed image
fixed = im2double(imread('../images/cameraman.tif'));

% Simulate moving image (rotated + translated)
moving = imrotate(fixed, 10, 'bilinear', 'crop');
moving = circshift(moving, [10, 15]);

% Display both images
figure;
subplot(1,2,1); 
imshow(fixed); 
title('Fixed Image');

subplot(1,2,2); 
imshow(moving); 
title('Moving Image');

disp('Created transformed image with 10° rotation and [10,15] translation');
