% Chapter 7: Complete Eigenfaces Overview

pkg load image;

% Load face dataset
img_dir = '../images/faces/';
img_files = dir(fullfile(img_dir, '*.pgm'));
img_size = [92, 112];
num_imgs = length(img_files);
data = zeros(prod(img_size), num_imgs);

fprintf('Building complete eigenface analysis...\n');

for i = 1:num_imgs
    img = im2double(imread(fullfile(img_dir, img_files(i).name)));
    img = imresize(img, img_size);
    data(:, i) = img(:);
end

% Complete PCA Analysis
mean_face = mean(data, 2);
centered_data = data - mean_face;
C = centered_data' * centered_data;
[Vec, Val] = eig(C);
eigenfaces = centered_data * Vec;

% Normalize eigenfaces
for i = 1:size(eigenfaces, 2)
    eigenfaces(:, i) = eigenfaces(:, i) / norm(eigenfaces(:, i));
end

% Sort eigenvalues in descending order
[sorted_vals, sort_idx] = sort(diag(Val), 'descend');
sorted_eigenfaces = eigenfaces(:, sort_idx);

% Create comprehensive visualization
figure('Position', [100, 100, 1400, 1000]);

% Original images
subplot(4, 5, 1);
montage_imgs = zeros(img_size(1), img_size(2), 1, min(9, num_imgs));
for i = 1:min(9, num_imgs)
    montage_imgs(:, :, 1, i) = reshape(data(:, i), img_size);
end
montage(montage_imgs, 'Size', [3, 3]);
title('Sample Face Images', 'FontWeight', 'bold');

% Mean face
subplot(4, 5, 2);
imshow(reshape(mean_face, img_size), []);
title('Mean Face', 'FontWeight', 'bold');

% Top eigenfaces
for i = 1:8
    subplot(4, 5, i+2);
    if i <= size(sorted_eigenfaces, 2)
        imshow(reshape(sorted_eigenfaces(:, i), img_size), []);
        title(sprintf('Eigenface %d', i));
    end
end

% Eigenvalue plot
subplot(4, 5, 11);
plot(sorted_vals, 'b-o', 'LineWidth', 2, 'MarkerSize', 4);
title('Eigenvalues (Sorted)');
xlabel('Eigenface Index');
ylabel('Eigenvalue');
grid on;

% Cumulative variance
cumvar = cumsum(sorted_vals) / sum(sorted_vals);
subplot(4, 5, 12);
plot(cumvar * 100, 'r-', 'LineWidth', 2);
title('Cumulative Variance Explained');
xlabel('Number of Eigenfaces');
ylabel('Variance Explained (%)');
grid on;

% Reconstruction comparison
k_values = [1, min(5, size(eigenfaces, 2)), min(10, size(eigenfaces, 2)), min(20, size(eigenfaces, 2))];
test_img = 1;

for i = 1:length(k_values)
    k = k_values(i);
    U_k = sorted_eigenfaces(:, 1:k);
    proj = U_k' * centered_data(:, test_img);
    reconstructed = U_k * proj + mean_face;
    
    subplot(4, 5, 12 + i);
    imshow(reshape(reconstructed, img_size), []);
    title(sprintf('k=%d faces', k));
end

% Face space visualization (if enough faces)
if num_imgs >= 3
    subplot(4, 5, 17:20);
    
    % Project first 3 eigenfaces for 3D visualization
    if size(sorted_eigenfaces, 2) >= 3
        proj_3d = sorted_eigenfaces(:, 1:3)' * centered_data;
        scatter3(proj_3d(1, :), proj_3d(2, :), proj_3d(3, :), 50, 1:num_imgs, 'filled');
        xlabel('1st Eigenface'); ylabel('2nd Eigenface'); zlabel('3rd Eigenface');
        title('Face Distribution in Eigenspace');
        colorbar;
        grid on;
    else
        % 2D projection if less than 3 eigenfaces
        proj_2d = sorted_eigenfaces(:, 1:2)' * centered_data;
        scatter(proj_2d(1, :), proj_2d(2, :), 50, 1:num_imgs, 'filled');
        xlabel('1st Eigenface'); ylabel('2nd Eigenface');
        title('Face Distribution in Eigenspace (2D)');
        colorbar;
        grid on;
    end
end

% Add overall title
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Chapter 7: Complete Eigenfaces Analysis', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Print summary statistics
fprintf('\n=== Eigenface Analysis Summary ===\n');
fprintf('Dataset: %d images of size %dx%d\n', num_imgs, img_size(1), img_size(2));
fprintf('Total eigenfaces computed: %d\n', size(eigenfaces, 2));
fprintf('Top eigenvalue: %.6f\n', sorted_vals(1));
fprintf('90%% variance explained by %d eigenfaces\n', find(cumvar >= 0.9, 1));
fprintf('99%% variance explained by %d eigenfaces\n', find(cumvar >= 0.99, 1));

% Reconstruction quality analysis
fprintf('\nReconstruction Quality:\n');
for k = [1, 5, 10, size(eigenfaces, 2)]
    if k <= size(eigenfaces, 2)
        U_k = sorted_eigenfaces(:, 1:k);
        total_error = 0;
        for img_idx = 1:num_imgs
            proj = U_k' * centered_data(:, img_idx);
            reconstructed = U_k * proj + mean_face;
            error = norm(data(:, img_idx) - reconstructed) / norm(data(:, img_idx));
            total_error = total_error + error;
        end
        avg_error = total_error / num_imgs;
        fprintf('k=%d: Average reconstruction error = %.4f\n', k, avg_error);
    end
end
