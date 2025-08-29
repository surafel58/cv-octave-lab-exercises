% Chapter 5 Practice 2: Median and Sharpening Filters

% Load image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% 5.2 Applying Median Filter
median_filtered = medfilt2(img);

% 6.2 Applying Laplacian Filter
laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
laplacian_img = imfilter(img, laplacian_kernel);
sharpened_img = img + laplacian_img;

% Display all results in one figure
figure('Position', [100, 100, 1000, 400]);
subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(median_filtered);
title('Median Filtered Image');

subplot(1, 3, 3);
imshow(sharpened_img);
title('Sharpened Image (Laplacian)');

% Add overall title manually
annotation('textbox', [0.2, 0.95, 0.6, 0.05], 'String', 'Chapter 5 Practice 2: Median and Sharpening Filters', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
