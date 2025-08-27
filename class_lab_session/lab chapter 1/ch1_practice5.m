% Chapter 1 Practice 5: Cascaded Operations: Sampling + Quantization

% Load image first
img = imread('../images/cameraman.tif');

% 5.1 Combined Process
cascaded_img = img(1:2:end, 1:2:end);
cascaded_img = uint8(floor(double(cascaded_img)/64) * 64);
figure;
imshow(cascaded_img);
title('Sampled and Quantized Image');