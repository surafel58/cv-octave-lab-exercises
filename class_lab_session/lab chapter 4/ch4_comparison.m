% Chapter 4 Comparison: All Morphological Operations Side-by-Side

% Load required package
pkg load image;

% Read and binarize image
img = imread('../images/coins.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);

% Create structuring element
se = strel('square', 3);

% Apply all operations
eroded_img = imerode(binary_img, se);
dilated_img = imdilate(binary_img, se);
opened_img = imopen(binary_img, se);
closed_img = imclose(binary_img, se);
gradient_img = imdilate(binary_img, se) - imerode(binary_img, se);
tophat_img = imtophat(binary_img, se);
bothat_img = imbothat(binary_img, se);

% Display all results in one figure
figure('Position', [100, 100, 1200, 800]);

subplot(3, 3, 1); imshow(binary_img); title('Original Binary');
subplot(3, 3, 2); imshow(eroded_img); title('Erosion');
subplot(3, 3, 3); imshow(dilated_img); title('Dilation');
subplot(3, 3, 4); imshow(opened_img); title('Opening');
subplot(3, 3, 5); imshow(closed_img); title('Closing');
subplot(3, 3, 6); imshow(gradient_img); title('Morphological Gradient');
subplot(3, 3, 7); imshow(tophat_img); title('Top-hat Transform');
subplot(3, 3, 8); imshow(bothat_img); title('Bottom-hat Transform');

% Add overall title
sgtitle('Morphological Operations Comparison (3x3 Square SE)');
