% Chapter 2 Practice 2: Point Operations

% Load color image
color_img = imread('../images/peppers.png');

% 2.2 Brightness Increase
bright_img = color_img + 50;
figure;
imshow(bright_img);
title('Brightness Increased');

% 2.3 Brightness Decrease
dark_img = color_img - 50;
figure;
imshow(dark_img);
title('Brightness Decreased');

% 2.4 Image Negative
negative_img = 255 - color_img;
figure;
imshow(negative_img);
title('Negative Image');

% 2.5 Contrast Stretching
double_img = im2double(color_img);
contrast_img = imadjust(double_img, stretchlim(double_img), []);
figure;
imshow(contrast_img);
title('Contrast Stretched Image');
