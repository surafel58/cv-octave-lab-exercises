% Chapter 8 Practice 4: Wavelet-based Multiresolution

% 5.1 Decomposition using DWT
pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Manual DWT implementation (reused from Chapter 6)
function [LL, LH, HL, HH] = manual_dwt2(img)
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

% Apply single-level DWT
[LL, LH, HL, HH] = manual_dwt2(img);

% Display wavelet decomposition
figure('Position', [100, 100, 1000, 800]);
subplot(2, 2, 1); imshow(LL); title('Approximation (LL)', 'FontWeight', 'bold');
subplot(2, 2, 2); imshow(LH, []); title('Horizontal Details (LH)', 'FontWeight', 'bold');
subplot(2, 2, 3); imshow(HL, []); title('Vertical Details (HL)', 'FontWeight', 'bold');
subplot(2, 2, 4); imshow(HH, []); title('Diagonal Details (HH)', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Wavelet Decomposition (Haar)', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Wavelet decomposition completed\n');
fprintf('Original image size: %dx%d\n', size(img, 1), size(img, 2));
fprintf('Each subband size: %dx%d\n', size(LL, 1), size(LL, 2));
fprintf('Approximation (LL) range: [%.3f, %.3f]\n', min(LL(:)), max(LL(:)));
fprintf('Detail subbands contain edge information\n');
