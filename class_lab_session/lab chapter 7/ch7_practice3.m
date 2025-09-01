% Chapter 7 Practice 3: Computing Eigenimages using PCA

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

% 4.1 Covariance Matrix and Eigen Decomposition
C = centered_data' * centered_data; % Smaller covariance matrix
[Vec, Val] = eig(C);

% Project back to image space
eigenfaces = centered_data * Vec;

% Normalize eigenfaces
for i = 1:size(eigenfaces, 2)
    eigenfaces(:, i) = eigenfaces(:, i) / norm(eigenfaces(:, i));
end

fprintf('Computed %d eigenfaces\n', size(eigenfaces, 2));
fprintf('Eigenvalue range: [%.6f, %.6f]\n', min(diag(Val)), max(diag(Val)));
