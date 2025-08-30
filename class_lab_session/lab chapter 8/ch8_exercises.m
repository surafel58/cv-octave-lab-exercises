% Chapter 8 Exercises: Multiresolution Image Processing

pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Helper function for pyramid operations using impyramid
function [g_pyr, l_pyr] = create_pyramids(img, levels)
    % Create Gaussian pyramid
    g_pyr = cell(1, levels);
    g_pyr{1} = img;
    for i = 2:levels
        g_pyr{i} = impyramid(g_pyr{i-1}, 'reduce');
    end
    
    % Create Laplacian pyramid
    l_pyr = cell(1, levels-1);
    for i = 1:levels-1
        upsampled = impyramid(g_pyr{i+1}, 'expand');
        upsampled = imresize(upsampled, size(g_pyr{i})); % Align sizes
        l_pyr{i} = g_pyr{i} - upsampled;
    end
end

% Manual DWT implementations for different wavelets
function [LL, LH, HL, HH] = manual_dwt2_haar(img)
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    h0 = [1, 1] / sqrt(2); h1 = [1, -1] / sqrt(2);
    temp_L = zeros(rows, cols/2); temp_H = zeros(rows, cols/2);
    
    for i = 1:rows
        row = img(i, :);
        conv_L = conv(row, h0, 'same'); conv_H = conv(row, h1, 'same');
        temp_L(i, :) = conv_L(1:2:end); temp_H(i, :) = conv_H(1:2:end);
    end
    
    LL = zeros(rows/2, cols/2); LH = zeros(rows/2, cols/2);
    HL = zeros(rows/2, cols/2); HH = zeros(rows/2, cols/2);
    
    for j = 1:cols/2
        col_L = temp_L(:, j); col_H = temp_H(:, j);
        conv_LL = conv(col_L, h0, 'same'); conv_LH = conv(col_L, h1, 'same');
        conv_HL = conv(col_H, h0, 'same'); conv_HH = conv(col_H, h1, 'same');
        LL(:, j) = conv_LL(1:2:end); LH(:, j) = conv_LH(1:2:end);
        HL(:, j) = conv_HL(1:2:end); HH(:, j) = conv_HH(1:2:end);
    end
end

function [LL, LH, HL, HH] = manual_dwt2_db2(img)
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    h0 = [0.4830, 0.8365, 0.2241, -0.1294];
    h1 = [-0.1294, -0.2241, 0.8365, -0.4830];
    
    temp_L = zeros(rows, cols/2); temp_H = zeros(rows, cols/2);
    for i = 1:rows
        row = img(i, :);
        conv_L = conv(row, h0, 'same'); conv_H = conv(row, h1, 'same');
        temp_L(i, :) = conv_L(1:2:end); temp_H(i, :) = conv_H(1:2:end);
    end
    
    LL = zeros(rows/2, cols/2); LH = zeros(rows/2, cols/2);
    HL = zeros(rows/2, cols/2); HH = zeros(rows/2, cols/2);
    
    for j = 1:cols/2
        col_L = temp_L(:, j); col_H = temp_H(:, j);
        conv_LL = conv(col_L, h0, 'same'); conv_LH = conv(col_L, h1, 'same');
        conv_HL = conv(col_H, h0, 'same'); conv_HH = conv(col_H, h1, 'same');
        LL(:, j) = conv_LL(1:2:end); LH(:, j) = conv_LH(1:2:end);
        HL(:, j) = conv_HL(1:2:end); HH(:, j) = conv_HH(1:2:end);
    end
end

fprintf('Starting Chapter 8 Exercises...\n\n');

%% Exercise 1: Vary the number of Gaussian pyramid levels and analyze effects
fprintf('Exercise 1: Gaussian Pyramid Level Analysis\n');
level_options = [3, 5, 7];
figure('Position', [50, 50, 1400, 500]);

for idx = 1:length(level_options)
    levels = level_options(idx);
    [g_pyr, ~] = create_pyramids(img, levels);
    
    % Show first 4 levels for comparison
    for i = 1:min(4, levels)
        subplot_idx = (idx-1)*4 + i;
        subplot(3, 4, subplot_idx);
        imshow(g_pyr{i});
        title(sprintf('%d Levels - L%d', levels, i), 'FontSize', 10);
    end
end
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 1: Gaussian Pyramid Level Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 2: Reconstruct using only some Laplacian levels
fprintf('Exercise 2: Partial Laplacian Reconstruction\n');
levels = 5;
[g_pyr, l_pyr] = create_pyramids(img, levels);

% Test different reconstruction strategies
reconstruction_cases = {[1, 2, 3, 4], [1, 2], [3, 4], [2, 3]};
case_names = {'All Levels', 'Fine Details', 'Coarse Details', 'Mid Levels'};

figure('Position', [50, 100, 1200, 800]);
subplot(2, 3, 1); imshow(img); title('Original', 'FontWeight', 'bold');

for case_idx = 1:length(reconstruction_cases)
    use_levels = reconstruction_cases{case_idx};
    
    % Start with coarsest level
    reconstructed = g_pyr{levels};
    
    % Add back selected Laplacian levels
    for i = levels-1:-1:1
        upsampled = impyramid(reconstructed, 'expand');
        upsampled = imresize(upsampled, size(l_pyr{i}));
        if ismember(i, use_levels)
            reconstructed = l_pyr{i} + upsampled;
        else
            reconstructed = upsampled; % Skip this level
        end
    end
    
    subplot(2, 3, case_idx + 1);
    imshow(reconstructed);
    title(case_names{case_idx}, 'FontWeight', 'bold');
end

% Full reconstruction for comparison
reconstructed_full = g_pyr{levels};
for i = levels-1:-1:1
    upsampled = impyramid(reconstructed_full, 'expand');
    upsampled = imresize(upsampled, size(l_pyr{i}));
    reconstructed_full = l_pyr{i} + upsampled;
end
subplot(2, 3, 6);
imshow(reconstructed_full);
title('Full Reconstruction', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 2: Selective Laplacian Reconstruction', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 3: Wavelet decomposition with different bases
fprintf('Exercise 3: Different Wavelet Bases Comparison\n');
[LL_haar, LH_haar, HL_haar, HH_haar] = manual_dwt2_haar(img);
[LL_db2, LH_db2, HL_db2, HH_db2] = manual_dwt2_db2(img);

figure('Position', [50, 150, 1200, 800]);
% Haar results
subplot(2, 4, 1); imshow(LL_haar); title('Haar - LL', 'FontWeight', 'bold');
subplot(2, 4, 2); imshow(LH_haar, []); title('Haar - LH');
subplot(2, 4, 3); imshow(HL_haar, []); title('Haar - HL');
subplot(2, 4, 4); imshow(HH_haar, []); title('Haar - HH');

% Daubechies-2 results
subplot(2, 4, 5); imshow(LL_db2); title('DB2 - LL', 'FontWeight', 'bold');
subplot(2, 4, 6); imshow(LH_db2, []); title('DB2 - LH');
subplot(2, 4, 7); imshow(HL_db2, []); title('DB2 - HL');
subplot(2, 4, 8); imshow(HH_db2, []); title('DB2 - HH');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 3: Wavelet Basis Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 4: Image blending using multiresolution
fprintf('Exercise 4: Multiresolution Image Blending\n');
% Create a second image (flipped version for demonstration)
img2 = fliplr(img);

levels = 4;
[g_pyr1, l_pyr1] = create_pyramids(img, levels);
[g_pyr2, l_pyr2] = create_pyramids(img2, levels);

% Create blending mask (smooth transition from left to right)
[rows, cols] = size(img);
mask = repmat(linspace(0, 1, cols), rows, 1);

% Create mask pyramid
[mask_g_pyr, mask_l_pyr] = create_pyramids(mask, levels);

% Blend at each level
blended_g_pyr = cell(1, levels);
blended_l_pyr = cell(1, levels-1);

for i = 1:levels
    blended_g_pyr{i} = mask_g_pyr{i} .* g_pyr1{i} + (1 - mask_g_pyr{i}) .* g_pyr2{i};
end

for i = 1:levels-1
    blended_l_pyr{i} = mask_l_pyr{i} .* l_pyr1{i} + (1 - mask_l_pyr{i}) .* l_pyr2{i};
end

% Reconstruct blended image
blended = blended_g_pyr{levels};
for i = levels-1:-1:1
    upsampled = impyramid(blended, 'expand');
    upsampled = imresize(upsampled, size(blended_l_pyr{i}));
    blended = blended_l_pyr{i} + upsampled;
end

% Simple direct blending for comparison
direct_blend = mask .* img + (1 - mask) .* img2;

figure('Position', [50, 200, 1200, 800]);
subplot(2, 3, 1); imshow(img); title('Image 1 (Original)', 'FontWeight', 'bold');
subplot(2, 3, 2); imshow(img2); title('Image 2 (Flipped)', 'FontWeight', 'bold');
subplot(2, 3, 3); imshow(mask); title('Blending Mask', 'FontWeight', 'bold');
subplot(2, 3, 4); imshow(direct_blend); title('Direct Blending', 'FontWeight', 'bold');
subplot(2, 3, 5); imshow(blended); title('Multiresolution Blending', 'FontWeight', 'bold');

% Show difference
difference = abs(direct_blend - blended);
subplot(2, 3, 6); imshow(difference, []); title('Blending Difference', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 4: Multiresolution Image Blending', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('\nAll exercises completed successfully!\n');
fprintf('Exercise 1: Analyzed %d different pyramid level configurations\n', length(level_options));
fprintf('Exercise 2: Demonstrated %d reconstruction strategies\n', length(reconstruction_cases));
fprintf('Exercise 3: Compared Haar vs Daubechies-2 wavelets\n');
fprintf('Exercise 4: Multiresolution blending shows smoother transitions\n');
