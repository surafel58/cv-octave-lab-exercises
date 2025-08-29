% Chapter 4: All Morphological Operations in One Figure

% Load required package
pkg load image;

% Read and prepare image
img = imread('../images/coins.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);

% Create structuring element (3x3 square)
se = strel('square', 3);

% Apply all morphological operations
eroded_img = imerode(binary_img, se);
dilated_img = imdilate(binary_img, se);
opened_img = imopen(binary_img, se);
closed_img = imclose(binary_img, se);
gradient_img = imdilate(binary_img, se) - imerode(binary_img, se);
tophat_img = imtophat(binary_img, se);
bothat_img = imbothat(binary_img, se);

% Create comprehensive figure with all operations
figure('Position', [50, 50, 1400, 900], 'Name', 'All Morphological Operations');

% Display all results
subplot(3, 3, 1);
imshow(binary_img);
title('Original Binary Image', 'FontSize', 12, 'FontWeight', 'bold');

subplot(3, 3, 2);
imshow(eroded_img);
title('Erosion', 'FontSize', 12);

subplot(3, 3, 3);
imshow(dilated_img);
title('Dilation', 'FontSize', 12);

subplot(3, 3, 4);
imshow(opened_img);
title('Opening (Erosion + Dilation)', 'FontSize', 12);

subplot(3, 3, 5);
imshow(closed_img);
title('Closing (Dilation + Erosion)', 'FontSize', 12);

subplot(3, 3, 6);
imshow(gradient_img);
title('Morphological Gradient', 'FontSize', 12);

subplot(3, 3, 7);
imshow(tophat_img);
title('Top-hat Transform', 'FontSize', 12);

subplot(3, 3, 8);
imshow(bothat_img);
title('Bottom-hat Transform', 'FontSize', 12);

% Add information panel in the last subplot
subplot(3, 3, 9);
axis off;
text(0.1, 0.9, 'Morphological Operations Summary:', 'FontSize', 14, 'FontWeight', 'bold');
text(0.1, 0.8, '• Erosion: Shrinks objects', 'FontSize', 10);
text(0.1, 0.7, '• Dilation: Expands objects', 'FontSize', 10);
text(0.1, 0.6, '• Opening: Removes noise', 'FontSize', 10);
text(0.1, 0.5, '• Closing: Fills gaps', 'FontSize', 10);
text(0.1, 0.4, '• Gradient: Highlights edges', 'FontSize', 10);
text(0.1, 0.3, '• Top-hat: Extracts bright objects', 'FontSize', 10);
text(0.1, 0.2, '• Bottom-hat: Extracts dark objects', 'FontSize', 10);
text(0.1, 0.05, 'Structuring Element: 3×3 Square', 'FontSize', 10, 'FontWeight', 'bold');

% Add overall title
sgtitle('Complete Morphological Image Processing Operations', 'FontSize', 16, 'FontWeight', 'bold');
