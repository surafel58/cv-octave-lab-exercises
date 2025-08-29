% Chapter 3 Practice 1: Global Thresholding

% Load image
img = imread('../images/cameraman.tif');

% 2.1 Binary Segmentation using a Fixed Threshold
bw_img = img > 100;
figure;
imshow(bw_img);
title('Binary Image (Threshold = 100)');

% 2.2 Otsu's Method for Adaptive Thresholding
level = graythresh(img);
bw_otsu = imbinarize(img, level);
figure;
imshow(bw_otsu);
title('Otsu''s Thresholding');
