% Chapter 2 Practice 1: Color Image Representation

% 1.2 Reading and Displaying a Color Image
color_img = imread('../images/peppers.png');
figure;
imshow(color_img);
title('Original Color Image');

% 1.3 Separating RGB Channels
R = color_img(:,:,1);
G = color_img(:,:,2);
B = color_img(:,:,3);

figure;
subplot(1,3,1); imshow(R); title('Red Channel');
subplot(1,3,2); imshow(G); title('Green Channel');
subplot(1,3,3); imshow(B); title('Blue Channel');
