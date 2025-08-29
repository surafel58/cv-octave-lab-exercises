% Chapter 5: Complete Filter Comparison in One Figure

% Load required package
pkg load image;

% Load and prepare image
img = imread('../images/cameraman.tif');
img = im2double(img);

% Apply all filtering techniques
avg_filtered = imfilter(img, ones(3,3)/9);
gauss_filtered = imgaussfilt(img, 1);
median_filtered = medfilt2(img);

% Laplacian sharpening
laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
laplacian_response = imfilter(img, laplacian_kernel);
sharpened_img = img + laplacian_response;

% Edge detection
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
gx = imfilter(img, sobel_x);
gy = imfilter(img, sobel_y);
edges = sqrt(gx.^2 + gy.^2);

% 2D Correlation example
corr_output = conv2(img, ones(5,5)/25, 'same');

% Unsharp masking
gaussian_blur = imgaussfilt(img, 1.5);
unsharp_mask = img - gaussian_blur;
unsharp_result = img + 1.5 * unsharp_mask;

% Create comprehensive figure
figure('Position', [50, 50, 1400, 900], 'Name', 'Complete Image Filtering Techniques');

% Display all results
subplot(3, 3, 1);
imshow(img);
title('Original Image', 'FontSize', 12, 'FontWeight', 'bold');

subplot(3, 3, 2);
imshow(avg_filtered);
title('Averaging Filter (3×3)', 'FontSize', 12);

subplot(3, 3, 3);
imshow(gauss_filtered);
title('Gaussian Filter (σ=1)', 'FontSize', 12);

subplot(3, 3, 4);
imshow(median_filtered);
title('Median Filter', 'FontSize', 12);

subplot(3, 3, 5);
imshow(sharpened_img);
title('Laplacian Sharpening', 'FontSize', 12);

subplot(3, 3, 6);
imshow(edges);
title('Edge Detection (Sobel)', 'FontSize', 12);

subplot(3, 3, 7);
imshow(corr_output);
title('2D Correlation', 'FontSize', 12);

subplot(3, 3, 8);
imshow(unsharp_result);
title('Unsharp Masking', 'FontSize', 12);

% Add information panel in the last subplot
subplot(3, 3, 9);
axis off;
text(0.1, 0.9, 'Filter Summary:', 'FontSize', 14, 'FontWeight', 'bold');
text(0.1, 0.8, '• Averaging: Noise reduction, blurring', 'FontSize', 10);
text(0.1, 0.7, '• Gaussian: Smooth noise reduction', 'FontSize', 10);
text(0.1, 0.6, '• Median: Salt & pepper noise removal', 'FontSize', 10);
text(0.1, 0.5, '• Laplacian: Edge enhancement', 'FontSize', 10);
text(0.1, 0.4, '• Sobel: Edge detection', 'FontSize', 10);
text(0.1, 0.3, '• Correlation: Template matching', 'FontSize', 10);
text(0.1, 0.2, '• Unsharp: Detail enhancement', 'FontSize', 10);

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Image Filtering and Correlation Techniques', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
