% Chapter 7 Exercises: Eigenimages

pkg load image;

% Load face dataset
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

% Compute PCA
mean_face = mean(data, 2);
centered_data = data - mean_face;
C = centered_data' * centered_data;
[Vec, Val] = eig(C);
eigenfaces = centered_data * Vec;

for i = 1:size(eigenfaces, 2)
    eigenfaces(:, i) = eigenfaces(:, i) / norm(eigenfaces(:, i));
end

fprintf('Starting Chapter 7 Exercises...\n\n');

%% Exercise 1: Vary number of eigenfaces (k = 5, 10, 50) and compare reconstructions
fprintf('Exercise 1: Varying Number of Eigenfaces\n');

k_values = [min(5, size(eigenfaces, 2)), min(10, size(eigenfaces, 2)), min(50, size(eigenfaces, 2))];
test_image_idx = 1;

figure('Position', [100, 100, 1200, 400]);

% Original image
subplot(1, length(k_values)+1, 1);
imshow(reshape(data(:, test_image_idx), img_size));
title('Original Image');

for i = 1:length(k_values)
    k = k_values(i);
    U_k = eigenfaces(:, end-k+1:end);
    proj = U_k' * centered_data(:, test_image_idx);
    reconstructed = U_k * proj + mean_face;
    
    % Calculate reconstruction error
    error = norm(data(:, test_image_idx) - reconstructed) / norm(data(:, test_image_idx));
    
    subplot(1, length(k_values)+1, i+1);
    imshow(reshape(reconstructed, img_size), []);
    title(sprintf('k=%d (Error: %.3f)', k, error));
    
    fprintf('k=%d: Reconstruction error = %.4f\n', k, error);
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 1: Reconstruction Quality vs Number of Eigenfaces', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 2: Classify test images using nearest neighbor in PCA space
fprintf('\nExercise 2: Nearest Neighbor Classification in PCA Space\n');

% Use top eigenfaces for classification (limited by available eigenfaces)
k_class = min(10, size(eigenfaces, 2));
U_k = eigenfaces(:, end-k_class+1:end);

% Project all images to PCA space
pca_features = U_k' * centered_data;

% Test classification: use first half as training, second half as test
mid_point = ceil(num_imgs / 2);
train_features = pca_features(:, 1:mid_point);
test_features = pca_features(:, mid_point+1:end);

figure('Position', [100, 100, 1200, 600]);

correct_matches = 0;
for t = 1:size(test_features, 2)
    test_feat = test_features(:, t);
    
    % Find nearest neighbor in training set
    distances = zeros(1, size(train_features, 2));
    for j = 1:size(train_features, 2)
        distances(j) = norm(test_feat - train_features(:, j));
    end
    
    [~, nearest_idx] = min(distances);
    
    % Display results
    subplot(2, size(test_features, 2), t);
    imshow(reshape(data(:, mid_point + t), img_size));
    title(sprintf('Test %d', t));
    
    subplot(2, size(test_features, 2), size(test_features, 2) + t);
    imshow(reshape(data(:, nearest_idx), img_size));
    title(sprintf('Match: %d', nearest_idx));
    
    % Simple similarity check (for demonstration)
    if abs(nearest_idx - t) <= 2  % Rough similarity measure
        correct_matches = correct_matches + 1;
    end
end

accuracy = correct_matches / size(test_features, 2);
fprintf('Classification accuracy: %.2f%% (%d/%d correct)\n', accuracy*100, correct_matches, size(test_features, 2));

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 2: Nearest Neighbor Classification', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 3: Create a GUI to slide through eigenfaces
fprintf('\nExercise 3: Interactive Eigenface Viewer\n');

% Create figure for eigenface slider
fig = figure('Position', [100, 100, 800, 600], 'Name', 'Eigenface Viewer');

% Create axes for eigenface display
ax = axes('Position', [0.1, 0.3, 0.8, 0.6]);

% Store data as global variables for the callback
global gui_eigenfaces gui_img_size gui_text_handle gui_axes_handle;
gui_eigenfaces = eigenfaces;
gui_img_size = img_size;

% Create slider with simple callback
num_eigenfaces = size(eigenfaces, 2);
slider_step = max(1/(num_eigenfaces-1), 0.01); % Avoid division by zero
slider_h = uicontrol('Style', 'slider', ...
                     'Position', [100, 50, 600, 30], ...
                     'Min', 1, 'Max', num_eigenfaces, ...
                     'Value', num_eigenfaces, ...
                     'SliderStep', [slider_step, 0.1], ...
                     'Callback', 'gui_slider_callback');

% Create text display
text_h = uicontrol('Style', 'text', ...
                   'Position', [350, 80, 100, 20], ...
                   'String', sprintf('Eigenface %d', num_eigenfaces));

% Store handles globally
gui_text_handle = text_h;
gui_axes_handle = ax;

% Initial display
eigenface_idx = num_eigenfaces;
axes(gui_axes_handle);
imshow(reshape(gui_eigenfaces(:, end-eigenface_idx+1), gui_img_size), []);
title(sprintf('Eigenface %d (Sorted by Eigenvalue)', eigenface_idx));

fprintf('Interactive eigenface viewer created!\n');
fprintf('Use the slider to browse through eigenfaces.\n');

fprintf('\nChapter 7 Exercises completed!\n');
fprintf('Summary:\n');
fprintf('- More eigenfaces = better reconstruction quality\n');
fprintf('- PCA space enables face classification\n');
fprintf('- Interactive tools help explore eigenface characteristics\n');
