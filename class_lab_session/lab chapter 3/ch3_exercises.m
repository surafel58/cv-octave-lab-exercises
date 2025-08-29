% Chapter 3 Exercises: Suggested Exercises

% Load image
img = imread('../images/lena.png');
% Convert to grayscale if it's a color image
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Exercise 1: Apply Otsu's thresholding to different test images
level = graythresh(img);
bw_otsu = imbinarize(img, level);
figure;
imshow(bw_otsu);
title('Otsu Thresholding on Cameraman');

% Exercise 2: Compare Sobel, Prewitt, and Canny edge detectors
edge_sobel = edge(img, 'sobel');
edge_prewitt = edge(img, 'prewitt');
edge_canny = edge(img, 'canny');

figure;
subplot(1,3,1); imshow(edge_sobel); title('Sobel');
subplot(1,3,2); imshow(edge_prewitt); title('Prewitt');
subplot(1,3,3); imshow(edge_canny); title('Canny');

% Exercise 3: Different threshold values comparison
thresh_50 = img > 50;
thresh_100 = img > 100;
thresh_150 = img > 150;

figure;
subplot(1,3,1); imshow(thresh_50); title('Threshold = 50');
subplot(1,3,2); imshow(thresh_100); title('Threshold = 100');
subplot(1,3,3); imshow(thresh_150); title('Threshold = 150');

% Interactive threshold adjustment (run separately)
% Run: ch3_interactive_threshold
