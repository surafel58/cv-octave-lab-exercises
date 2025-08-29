% Chapter 5 Practice 1: Basic Filtering (Averaging and Gaussian)

% 2.1 Load Required Package and Image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% 3.2 Applying a 3x3 Averaging Filter
kernel = ones(3,3)/9;
avg_filtered = imfilter(img, kernel);

% 4.2 Applying Gaussian Filter
gauss_filtered = imgaussfilt(img, 1);

% Display all results in one figure
figure('Position', [100, 100, 1000, 400]);
subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(avg_filtered);
title('Averaging Filter (3×3)');

subplot(1, 3, 3);
imshow(gauss_filtered);
title('Gaussian Filter (σ = 1)');

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Chapter 5 Practice 1: Basic Filtering', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
