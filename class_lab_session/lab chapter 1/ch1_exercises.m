% Chapter 1 Exercises: Suggested Exercises

% Load image first
img = imread('../images/cameraman.tif');

% Exercise 1: Apply different downsampling factors (e.g., 3, 5) and compare results
sampled_img_3 = img(1:3:end, 1:3:end);
figure;
imshow(sampled_img_3);
title('Sampled Image - Factor 3');

sampled_img_5 = img(1:5:end, 1:5:end);
figure;
imshow(sampled_img_5);
title('Sampled Image - Factor 5');

% Exercise 2: Experiment with quantizing to 8, 16, and 32 gray levels
quant_img_8 = uint8(floor(double(img)/32) * 32);
figure;
imshow(quant_img_8);
title('Quantized Image - 8 Gray Levels');

quant_img_16 = uint8(floor(double(img)/16) * 16);
figure;
imshow(quant_img_16);
title('Quantized Image - 16 Gray Levels');

quant_img_32 = uint8(floor(double(img)/8) * 8);
figure;
imshow(quant_img_32);
title('Quantized Image - 32 Gray Levels');

% Exercise 3: Interactive UI (run separately)
% Run: ch1_interactive_ui