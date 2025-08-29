% Chapter 2 Practice 2: Point Operations

% Load color image
color_img = imread('../images/peppers.png');

% 2.2 Brightness Increase
bright_img = color_img + 50;

% 2.3 Brightness Decrease
dark_img = color_img - 50;

% 2.4 Image Negative
negative_img = 255 - color_img;

% 2.5 Contrast Stretching
double_img = im2double(color_img);
contrast_img = imadjust(double_img, stretchlim(double_img), []);

% Display all results in one figure
figure('Position', [100, 100, 1200, 800]);
subplot(2,3,1); imshow(color_img); title('Original Image');
subplot(2,3,2); imshow(bright_img); title('Brightness Increased');
subplot(2,3,3); imshow(dark_img); title('Brightness Decreased');
subplot(2,3,4); imshow(negative_img); title('Negative Image');
subplot(2,3,5); imshow(contrast_img); title('Contrast Stretched Image');
