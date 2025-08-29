% Chapter 2 Exercises: Suggested Exercises

% Load color image
color_img = imread('../images/peppers.png');

fprintf('=== EXERCISE 1: RGB to Grayscale Conversion ===\n');

% Exercise 1: Convert RGB to grayscale using luminosity method
gray_img = 0.299 * color_img(:,:,1) + 0.587 * color_img(:,:,2) + 0.114 * color_img(:,:,3);

% Display Exercise 1 results grouped together
figure('Name', 'Exercise 1: RGB to Grayscale Conversion', 'Position', [100, 100, 800, 400]);
subplot(1,2,1); imshow(color_img); title('Original Color Image');
subplot(1,2,2); imshow(uint8(gray_img)); title('Grayscale - Luminosity Method');

fprintf('Exercise 1 completed: RGB to grayscale using luminosity method\n');

fprintf('\n=== EXERCISE 3: Histogram Equalization ===\n');

% Exercise 3: Histogram equalization on each channel separately
R = color_img(:,:,1);
G = color_img(:,:,2);
B = color_img(:,:,3);

R_eq = histeq(R);
G_eq = histeq(G);
B_eq = histeq(B);

equalized_img = cat(3, R_eq, G_eq, B_eq);

% Display Exercise 3 results grouped together
figure('Name', 'Exercise 3: Histogram Equalization', 'Position', [150, 150, 800, 400]);
subplot(1,2,1); imshow(color_img); title('Original Color Image');
subplot(1,2,2); imshow(equalized_img); title('Histogram Equalized Image');

fprintf('Exercise 3 completed: Histogram equalization on each RGB channel\n');

fprintf('\n=== EXERCISE 2: Interactive Brightness Adjustment ===\n');
% Exercise 2: Interactive brightness adjustment (run separately)
% Run: ch2_interactive_brightness
fprintf('Run ch2_interactive_brightness for interactive brightness control\n');
