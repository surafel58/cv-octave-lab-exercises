% Chapter 7 Practice 5: Image Reconstruction with Eigenfaces

% Load and prepare data
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

mean_face = mean(data, 2);
centered_data = data - mean_face;

% Compute eigenfaces
C = centered_data' * centered_data;
[Vec, Val] = eig(C);
eigenfaces = centered_data * Vec;

for i = 1:size(eigenfaces, 2)
    eigenfaces(:, i) = eigenfaces(:, i) / norm(eigenfaces(:, i));
end

% 5.1 Using Top k Eigenfaces
k = min(20, size(eigenfaces, 2));
U_k = eigenfaces(:, end-k+1:end);

proj = U_k' * centered_data(:, 1); % Projection of first image
reconstructed = U_k * proj + mean_face;

figure;
imshow(reshape(reconstructed, img_size), []);
title(['Reconstructed Image with ', num2str(k), ' Eigenfaces']);
