% Chapter 1 Practice 3: Image Sampling

% Load image first
img = imread('../images/cameraman.tif');

% 3.2 Downsampling by a Factor of 2
sampled_img = img(1:2:end, 1:2:end);
figure;
imshow(sampled_img);
title('Sampled Image - Factor 2');

% 3.3 Downsampling by a Factor of 4
sampled_img_4 = img(1:4:end, 1:4:end);
figure;
imshow(sampled_img_4);
title('Sampled Image - Factor 4');
