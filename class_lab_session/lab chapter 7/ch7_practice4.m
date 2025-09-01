% Chapter 7 Practice 4: Displaying Top 5 Eigenfaces

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

% 4.2 Displaying Top 5 Eigenfaces
figure;
for i = 1:5
    subplot(1,5,i);
    imshow(reshape(eigenfaces(:, end-i+1), img_size), []);
    title(['Eigenface ', num2str(i)]);
end
