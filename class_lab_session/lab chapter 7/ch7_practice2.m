% Chapter 7 Practice 2: Mean Face and Data Centering

% Load data from practice 1
pkg load image;
img_dir = '../images/faces/';
img_files = dir(fullfile(img_dir, '*.pgm'));
img_size = [92, 112];
num_imgs = length(img_files);
data = zeros(prod(img_size), num_imgs);

for i = 1:num_imgs
    img = im2double(imread(fullfile(img_dir, img_files(i).name)));
    img = imresize(img, img_size);
    data(:, i) = img(:);
end

% 3. Mean Face and Data Centering
mean_face = mean(data, 2);
centered_data = data - mean_face;

% Visualize Mean Face
figure;
imshow(reshape(mean_face, img_size), []);
title('Mean Face');
