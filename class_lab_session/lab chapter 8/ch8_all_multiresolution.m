% Chapter 8: Complete Multiresolution Processing Overview

pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Using impyramid functions from the PDF

function [LL, LH, HL, HH] = simple_dwt2(img)
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

% Create pyramids
levels = 4;
fprintf('Building multiresolution representations...\n');

% Gaussian pyramid
g_pyramid = cell(1, levels);
g_pyramid{1} = img;
for i = 2:levels
    g_pyramid{i} = impyramid(g_pyramid{i-1}, 'reduce');
end

% Laplacian pyramid
l_pyramid = cell(1, levels-1);
for i = 1:levels-1
    upsampled = impyramid(g_pyramid{i+1}, 'expand');
    upsampled = imresize(upsampled, size(g_pyramid{i})); % Align sizes
    l_pyramid{i} = g_pyramid{i} - upsampled;
end

% Wavelet decomposition
[LL, LH, HL, HH] = simple_dwt2(img);

% Reconstruction from Laplacian
reconstructed = g_pyramid{levels};
for i = levels-1:-1:1
    upsampled = impyramid(reconstructed, 'expand');
    upsampled = imresize(upsampled, size(l_pyramid{i}));
    reconstructed = l_pyramid{i} + upsampled;
end

% Create comprehensive display
figure('Position', [50, 50, 1600, 1000], 'Name', 'Complete Multiresolution Overview');

% Row 1: Original and Gaussian Pyramid
subplot(3, 5, 1); imshow(img); title('Original', 'FontWeight', 'bold', 'FontSize', 12);
for i = 1:min(4, levels)
    subplot(3, 5, i+1);
    imshow(g_pyramid{i});
    title(sprintf('Gaussian L%d', i), 'FontSize', 10);
end

% Row 2: Laplacian Pyramid
for i = 1:levels-1
    subplot(3, 5, 5+i);
    imshow(l_pyramid{i}, []);
    title(sprintf('Laplacian L%d', i), 'FontSize', 10);
end
subplot(3, 5, 10); imshow(reconstructed); title('Reconstructed', 'FontWeight', 'bold', 'FontSize', 10);

% Row 3: Wavelet Decomposition
subplot(3, 5, 11); imshow(LL); title('Wavelet LL', 'FontWeight', 'bold', 'FontSize', 10);
subplot(3, 5, 12); imshow(LH, []); title('Wavelet LH', 'FontSize', 10);
subplot(3, 5, 13); imshow(HL, []); title('Wavelet HL', 'FontSize', 10);
subplot(3, 5, 14); imshow(HH, []); title('Wavelet HH', 'FontSize', 10);

% Show difference between original and reconstructed
difference = abs(img - reconstructed);
subplot(3, 5, 15); imshow(difference, []); title('Reconstruction Error', 'FontSize', 10);

% Add main title
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Complete Multiresolution Processing Overview', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Add section labels
annotation('textbox', [0.02, 0.78, 0.08, 0.03], 'String', 'Gaussian:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.52, 0.08, 0.03], 'String', 'Laplacian:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.26, 0.08, 0.03], 'String', 'Wavelet:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');

% Calculate and display statistics
mse = mean((img(:) - reconstructed(:)).^2);
psnr_value = 10 * log10(1 / mse);

fprintf('\nMultiresolution Analysis Complete:\n');
fprintf('- Gaussian pyramid: %d levels\n', levels);
fprintf('- Laplacian pyramid: %d levels\n', levels-1);
fprintf('- Wavelet decomposition: 4 subbands\n');
fprintf('- Reconstruction PSNR: %.2f dB\n', psnr_value);
fprintf('- Original image size: %dx%d\n', size(img, 1), size(img, 2));
fprintf('- Finest Gaussian level: %dx%d\n', size(g_pyramid{levels}, 1), size(g_pyramid{levels}, 2));
fprintf('- Wavelet subband size: %dx%d\n', size(LL, 1), size(LL, 2));
