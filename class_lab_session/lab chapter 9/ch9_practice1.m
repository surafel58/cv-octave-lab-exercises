% Chapter 9 Practice 1: Adding Noise to Images

% 2.1 Gaussian Noise
pkg load image;
img = im2double(imread('../images/cameraman.tif'));
gauss_img = imnoise(img, 'gaussian', 0, 0.01);

% 2.2 Salt & Pepper Noise
sp_img = imnoise(img, 'salt & pepper', 0.05);

% Display all noise types
figure('Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(gauss_img);
title('Image with Gaussian Noise');

subplot(1, 3, 3);
imshow(sp_img);
title('Image with Salt & Pepper Noise');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Different Types of Image Noise', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Noise simulation completed:\n');
fprintf('- Gaussian noise: mean=0, variance=0.01\n');
fprintf('- Salt & pepper noise: density=0.05\n');
