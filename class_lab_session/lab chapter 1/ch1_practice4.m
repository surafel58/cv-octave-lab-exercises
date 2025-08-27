% Chapter 1 Practice 4: Image Quantization

% Load image first
img = imread('../images/cameraman.tif');

% 4.2 Reducing to 4 Gray Levels (2-bit image)
quant_img = uint8(floor(double(img)/64) * 64);
figure;
imshow(quant_img);
title('Quantized Image - 4 Gray Levels');

% 4.3 Reducing to 2 Gray Levels (Binary Image)
binary_img = img > 128;
figure;
imshow(binary_img);
title('Binary Image (Threshold at 128)');
