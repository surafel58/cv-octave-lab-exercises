% Chapter 8 Exercises: Multiresolution Image Processing

pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

fprintf('Starting Chapter 8 Exercises...\n\n');

%% Exercise 1: Vary the number of Gaussian pyramid levels and analyze effects
fprintf('Exercise 1: Varying Gaussian Pyramid Levels\n');

figure('Position', [100, 100, 1400, 800]);

level_counts = [2, 3, 4, 5];
for n = 1:length(level_counts)
    levels = level_counts(n);
    
    % Create Gaussian pyramid
    g_pyramid = cell(1, levels);
    g_pyramid{1} = img;
    for i = 2:levels
        g_pyramid{i} = impyramid(g_pyramid{i-1}, 'reduce');
    end
    
    % Display pyramid levels
    for lev = 1:levels
        subplot_idx = (n-1)*5 + lev;
        subplot(4, 5, subplot_idx);
        imshow(g_pyramid{lev});
        title(sprintf('%d Levels: L%d (%dx%d)', levels, lev, size(g_pyramid{lev})));
    end
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 1: Gaussian Pyramid Level Analysis', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 2: Reconstruct image using only some Laplacian levels
fprintf('Exercise 2: Partial Laplacian Reconstruction\n');

% Create 4-level pyramids
levels = 4;
g_pyr = cell(1, levels);
g_pyr{1} = img;
for i = 2:levels
    g_pyr{i} = impyramid(g_pyr{i-1}, 'reduce');
end

% Create Laplacian pyramid
l_pyr = cell(1, levels-1);
for i = 1:levels-1
    expanded = impyramid(g_pyr{i+1}, 'expand');
    expanded = imresize(expanded, size(g_pyr{i}));
    l_pyr{i} = g_pyr{i} - expanded;
end

% Reconstruction function
function reconstructed = reconstruct_from_laplacian(l_pyr, g_top, skip_levels)
    levels = length(l_pyr) + 1;
    reconstructed = g_top;
    
    for i = levels-1:-1:1
        if ~ismember(i, skip_levels)
            reconstructed = imresize(reconstructed, size(l_pyr{i}));
            reconstructed = reconstructed + l_pyr{i};
        else
            reconstructed = imresize(reconstructed, size(l_pyr{i}));
        end
    end
end

figure('Position', [100, 100, 1200, 600]);

% Full reconstruction
recon_full = reconstruct_from_laplacian(l_pyr, g_pyr{end}, []);
subplot(2, 3, 1); imshow(img); title('Original');
subplot(2, 3, 2); imshow(recon_full); title('Full Reconstruction');

% Skip different levels
skip_configs = {[2], [1, 3], [2, 3]};
titles = {'Skip Level 2', 'Skip Levels 1&3', 'Skip Levels 2&3'};

for i = 1:length(skip_configs)
    recon_partial = reconstruct_from_laplacian(l_pyr, g_pyr{end}, skip_configs{i});
    subplot(2, 3, i+3);
    imshow(recon_partial);
    title(titles{i});
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 2: Partial Laplacian Reconstruction', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 3: Apply wavelet decomposition using different wavelet bases
fprintf('Exercise 3: Different Wavelet Bases\n');

% Haar wavelet
function [LL, LH, HL, HH] = dwt_haar(img)
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    h0 = [1, 1] / sqrt(2); h1 = [1, -1] / sqrt(2);
    [LL, LH, HL, HH] = apply_dwt_filters(img, h0, h1);
end

% Daubechies-2 approximation
function [LL, LH, HL, HH] = dwt_db2(img)
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    % Simplified Daubechies-2 coefficients
    h0 = [0.4830, 0.8365, 0.2241, -0.1294];
    h1 = [-0.1294, -0.2241, 0.8365, -0.4830];
    [LL, LH, HL, HH] = apply_dwt_filters(img, h0, h1);
end

% Biorthogonal approximation
function [LL, LH, HL, HH] = dwt_bior(img)
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    % Simple biorthogonal-like coefficients
    h0 = [0.35, 0.71, 0.71, 0.35] / 2;
    h1 = [0.35, -0.71, 0.71, -0.35] / 2;
    [LL, LH, HL, HH] = apply_dwt_filters(img, h0, h1);
end

% Common DWT filter application
function [LL, LH, HL, HH] = apply_dwt_filters(img, h0, h1)
    [rows, cols] = size(img);
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

figure('Position', [100, 100, 1200, 900]);

wavelets = {'Haar', 'Daubechies-2', 'Biorthogonal'};
dwt_functions = {@dwt_haar, @dwt_db2, @dwt_bior};

for w = 1:3
    [LL, LH, HL, HH] = dwt_functions{w}(img);
    
    % Display results for each wavelet
    subplot(3, 4, (w-1)*4 + 1); imshow(LL, []); title(sprintf('%s: LL', wavelets{w}));
    subplot(3, 4, (w-1)*4 + 2); imshow(LH, []); title('LH');
    subplot(3, 4, (w-1)*4 + 3); imshow(HL, []); title('HL');
    subplot(3, 4, (w-1)*4 + 4); imshow(HH, []); title('HH');
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 3: Different Wavelet Bases Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 4: Multiresolution image blending
fprintf('Exercise 4: Multiresolution Image Blending\n');

% Load second image (use cameraman as second image)
img2 = im2double(imread('../images/cameraman.tif'));
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

% Resize to match first image
img2 = imresize(img2, size(img));

% Create simple mask (left half vs right half)
mask = zeros(size(img));
mask(:, 1:round(end/2)) = 1;

% Smooth the mask for better blending
mask = imgaussfilt(mask, 20);

% Create pyramids for both images and mask
levels = 4;

% Image 1 pyramid
pyr1 = cell(1, levels);
pyr1{1} = img;
for i = 2:levels
    pyr1{i} = impyramid(pyr1{i-1}, 'reduce');
end

% Image 2 pyramid
pyr2 = cell(1, levels);
pyr2{1} = img2;
for i = 2:levels
    pyr2{i} = impyramid(pyr2{i-1}, 'reduce');
end

% Mask pyramid
mask_pyr = cell(1, levels);
mask_pyr{1} = mask;
for i = 2:levels
    mask_pyr{i} = impyramid(mask_pyr{i-1}, 'reduce');
end

% Blend at each level
blended_pyr = cell(1, levels);
for i = 1:levels
    blended_pyr{i} = mask_pyr{i} .* pyr1{i} + (1 - mask_pyr{i}) .* pyr2{i};
end

% Reconstruct blended image
blended = blended_pyr{levels};
for i = levels-1:-1:1
    blended = impyramid(blended, 'expand');
    blended = imresize(blended, size(blended_pyr{i}));
    blended = blended + blended_pyr{i};
end

% Simple direct blending for comparison
direct_blend = mask .* img + (1 - mask) .* img2;

figure('Position', [100, 100, 1200, 600]);

subplot(2, 4, 1); imshow(img); title('Image 1 (Peppers)');
subplot(2, 4, 2); imshow(img2); title('Image 2 (Cameraman)');
subplot(2, 4, 3); imshow(mask); title('Blending Mask');
subplot(2, 4, 4); imshow(direct_blend); title('Direct Blending');

subplot(2, 4, 5); imshow(blended_pyr{1}); title('Blend Level 1');
subplot(2, 4, 6); imshow(blended_pyr{2}); title('Blend Level 2');
subplot(2, 4, 7); imshow(blended_pyr{3}); title('Blend Level 3');
subplot(2, 4, 8); imshow(blended); title('Multiresolution Blend');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 4: Multiresolution Image Blending', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');
