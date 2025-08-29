% Chapter 5 Practice 3: Correlation and Custom Filters

% Load image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% 7.2 Performing 2D Correlation
kernel = ones(3,3)/9;  % Simple averaging kernel for demonstration
corr_output = conv2(img, kernel, 'same');

% 8. Custom Filter Example: Edge Detection
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
gx = imfilter(img, sobel_x);
gy = imfilter(img, sobel_y);
gradient_magnitude = sqrt(gx.^2 + gy.^2);

% Display all results in one figure
figure('Position', [100, 100, 1000, 400]);
subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(corr_output);
title('2D Correlation Output');

subplot(1, 3, 3);
imshow(gradient_magnitude);
title('Edge Detection (Sobel)');

% Add overall title manually
annotation('textbox', [0.2, 0.95, 0.6, 0.05], 'String', 'Chapter 5 Practice 3: Correlation and Custom Filters', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
