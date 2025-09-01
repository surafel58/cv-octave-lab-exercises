% Chapter 7 Practice 1: Loading Multiple Images from a Folder

% 2.2 Loading Multiple Images from a Folder
pkg load image;
img_dir = '../images/faces/'; % Folder with images
img_files = dir(fullfile(img_dir, '*.pgm'));

% Preallocate matrix
img_size = [92, 112];
num_imgs = length(img_files);
data = zeros(prod(img_size), num_imgs);

for i = 1:num_imgs
    img = im2double(imread(fullfile(img_dir, img_files(i).name)));
    img = imresize(img, img_size);
    data(:, i) = img(:); % Flatten and store as column
end

fprintf('Loaded %d images of size %dx%d\n', num_imgs, img_size(1), img_size(2));
fprintf('Data matrix size: %dx%d\n', size(data, 1), size(data, 2));
