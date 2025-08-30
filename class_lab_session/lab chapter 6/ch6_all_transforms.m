% Chapter 6: Complete Image Transforms Overview

% Load required packages
pkg load image;

% Load and prepare image
img = imread('../images/cameraman.tif');
img = im2double(img);

% Apply all transforms
% DFT
F = fft2(img);
F_shifted = fftshift(F);
F_magnitude = log(1 + abs(F_shifted));
reconstructed_dft = real(ifft2(F));

% Fast DCT implementation
function dct_result = fast_dct2(img)
    [M, N] = size(img);
    img_extended = zeros(2*M, 2*N);
    img_extended(1:M, 1:N) = img;
    img_extended(M+1:2*M, 1:N) = img(M:-1:1, :);
    img_extended(1:M, N+1:2*N) = img(:, N:-1:1);
    img_extended(M+1:2*M, N+1:2*N) = img(M:-1:1, N:-1:1);
    
    fft_result = fft2(img_extended);
    dct_result = real(fft_result(1:M, 1:N));
    
    for u = 1:M
        for v = 1:N
            if u == 1
                alpha_u = 1/sqrt(2);
            else
                alpha_u = 1;
            end
            
            if v == 1
                alpha_v = 1/sqrt(2);
            else
                alpha_v = 1;
            end
            
            dct_result(u, v) = dct_result(u, v) * alpha_u * alpha_v * sqrt(2/M) * sqrt(2/N);
        end
    end
end

function idct_result = fast_idct2(dct_img)
    [M, N] = size(dct_img);
    scaled_dct = dct_img;
    for u = 1:M
        for v = 1:N
            if u == 1
                alpha_u = 1/sqrt(2);
            else
                alpha_u = 1;
            end
            
            if v == 1
                alpha_v = 1/sqrt(2);
            else
                alpha_v = 1;
            end
            
            scaled_dct(u, v) = scaled_dct(u, v) / (alpha_u * alpha_v * sqrt(2/M) * sqrt(2/N));
        end
    end
    
    extended_dct = zeros(2*M, 2*N);
    extended_dct(1:M, 1:N) = scaled_dct;
    extended_dct(M+1:2*M, 1:N) = scaled_dct(M:-1:1, :);
    extended_dct(1:M, N+1:2*N) = scaled_dct(:, N:-1:1);
    extended_dct(M+1:2*M, N+1:2*N) = scaled_dct(M:-1:1, N:-1:1);
    
    ifft_result = real(ifft2(extended_dct));
    idct_result = ifft_result(1:M, 1:N);
end

% DCT
fprintf('Computing DCT...\n');
dct_img = fast_dct2(img);
dct_display = log(abs(dct_img));
reconstructed_dct = fast_idct2(dct_img);

% Manual DWT implementation
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

function reconstructed = simple_idwt2(LL, LH, HL, HH)
    [sub_rows, sub_cols] = size(LL);
    rows = sub_rows * 2; cols = sub_cols * 2;
    
    g0 = [1, 1] / sqrt(2); g1 = [1, -1] / sqrt(2);
    temp_L = zeros(rows, sub_cols); temp_H = zeros(rows, sub_cols);
    
    for j = 1:sub_cols
        upsampled_LL = zeros(rows, 1); upsampled_LH = zeros(rows, 1);
        upsampled_HL = zeros(rows, 1); upsampled_HH = zeros(rows, 1);
        upsampled_LL(1:2:end) = LL(:, j); upsampled_LH(1:2:end) = LH(:, j);
        upsampled_HL(1:2:end) = HL(:, j); upsampled_HH(1:2:end) = HH(:, j);
        temp_L(:, j) = conv(upsampled_LL, g0, 'same') + conv(upsampled_LH, g1, 'same');
        temp_H(:, j) = conv(upsampled_HL, g0, 'same') + conv(upsampled_HH, g1, 'same');
    end
    
    reconstructed = zeros(rows, cols);
    for i = 1:rows
        upsampled_L = zeros(1, cols); upsampled_H = zeros(1, cols);
        upsampled_L(1:2:end) = temp_L(i, :); upsampled_H(1:2:end) = temp_H(i, :);
        reconstructed(i, :) = conv(upsampled_L, g0, 'same') + conv(upsampled_H, g1, 'same');
    end
end

% DWT
fprintf('Computing DWT...\n');
[LL, LH, HL, HH] = simple_dwt2(img);
reconstructed_dwt = simple_idwt2(LL, LH, HL, HH);

% Create comprehensive figure
figure('Position', [50, 50, 1400, 900], 'Name', 'Complete Image Transforms Overview');

% Original and reconstructions
subplot(3, 4, 1);
imshow(img);
title('Original Image', 'FontSize', 12, 'FontWeight', 'bold');

subplot(3, 4, 2);
imshow(reconstructed_dft);
title('DFT Reconstruction', 'FontSize', 12);

subplot(3, 4, 3);
imshow(reconstructed_dct);
title('DCT Reconstruction', 'FontSize', 12);

subplot(3, 4, 4);
imshow(reconstructed_dwt);
title('DWT Reconstruction', 'FontSize', 12);

% Transform domain representations
subplot(3, 4, 5);
imshow(F_magnitude, []);
title('DFT Magnitude Spectrum', 'FontSize', 12);

subplot(3, 4, 6);
imshow(dct_display, []);
title('DCT Coefficients', 'FontSize', 12);

subplot(3, 4, 7);
imshow(LL, []);
title('DWT Approximation (LL)', 'FontSize', 12);

subplot(3, 4, 8);
imshow(LH, []);
title('DWT Horizontal Detail (LH)', 'FontSize', 12);

% Additional DWT subbands
subplot(3, 4, 9);
imshow(HL, []);
title('DWT Vertical Detail (HL)', 'FontSize', 12);

subplot(3, 4, 10);
imshow(HH, []);
title('DWT Diagonal Detail (HH)', 'FontSize', 12);

% Add information panel
subplot(3, 4, [11, 12]);
axis off;
text(0.1, 0.9, 'Transform Summary:', 'FontSize', 14, 'FontWeight', 'bold');
text(0.1, 0.8, '• DFT: Frequency domain analysis', 'FontSize', 10);
text(0.1, 0.7, '• DCT: Compression applications', 'FontSize', 10);
text(0.1, 0.6, '• DWT: Multi-resolution analysis', 'FontSize', 10);
text(0.1, 0.5, '', 'FontSize', 10);
text(0.1, 0.4, 'Applications:', 'FontSize', 12, 'FontWeight', 'bold');
text(0.1, 0.3, '• DFT: Filtering, convolution', 'FontSize', 10);
text(0.1, 0.2, '• DCT: JPEG compression', 'FontSize', 10);
text(0.1, 0.1, '• DWT: Feature extraction, denoising', 'FontSize', 10);

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Complete Image Transforms: DFT, DCT, and DWT', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
