% Chapter 6 Exercises: Advanced Image Transform Techniques

% Load image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% Manual DWT implementations for exercises
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
    % Simplified Daubechies-2 approximation
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    % Daubechies-2 coefficients (approximation)
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

function [LL, LH, HL, HH] = manual_dwt2_sym4(img)
    % Simplified Symlet-4 approximation
    [rows, cols] = size(img);
    if mod(rows, 2) == 1; img = img(1:rows-1, :); rows = rows - 1; end
    if mod(cols, 2) == 1; img = img(:, 1:cols-1); cols = cols - 1; end
    
    % Symlet-4 coefficients (approximation)
    h0 = [0.0322, -0.0126, -0.0992, 0.2979, 0.8037, 0.4976, -0.0296, -0.0758];
    h1 = fliplr(h0); h1(2:2:end) = -h1(2:2:end);
    
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

function reconstructed = manual_idwt2_simple(LL, LH, HL, HH)
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

% Fast DCT2 implementation for exercises
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

% Exercise 1: Retain only low-frequency DCT coefficients and analyze compression
fprintf('Computing DCT for compression analysis...\n');
dct_img = fast_dct2(img);
[rows, cols] = size(dct_img);

% Create masks for different compression levels
mask_25 = zeros(rows, cols);
mask_25(1:round(rows/4), 1:round(cols/4)) = 1;  % Keep 25% of coefficients

mask_10 = zeros(rows, cols);
mask_10(1:round(rows/6), 1:round(cols/6)) = 1;  % Keep ~10% of coefficients

mask_5 = zeros(rows, cols);
mask_5(1:round(rows/8), 1:round(cols/8)) = 1;   % Keep ~5% of coefficients

% Apply compression
dct_compressed_25 = dct_img .* mask_25;
dct_compressed_10 = dct_img .* mask_10;
dct_compressed_5 = dct_img .* mask_5;

% Reconstruct images
reconstructed_25 = fast_idct2(dct_compressed_25);
reconstructed_10 = fast_idct2(dct_compressed_10);
reconstructed_5 = fast_idct2(dct_compressed_5);

figure('Position', [100, 100, 1200, 800]);
subplot(2,2,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2,2,2); imshow(reconstructed_25); title('25% DCT Coefficients');
subplot(2,2,3); imshow(reconstructed_10); title('10% DCT Coefficients');
subplot(2,2,4); imshow(reconstructed_5); title('5% DCT Coefficients');
annotation('textbox', [0.3, 0.95, 0.4, 0.05], 'String', 'Exercise 1: DCT Compression Analysis', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Exercise 2: Apply DWT using different wavelet bases
fprintf('Computing different wavelet transforms...\n');
[LL_haar, LH_haar, HL_haar, HH_haar] = manual_dwt2_haar(img);
[LL_db2, LH_db2, HL_db2, HH_db2] = manual_dwt2_db2(img);
[LL_sym4, LH_sym4, HL_sym4, HH_sym4] = manual_dwt2_sym4(img);

reconstructed_haar = manual_idwt2_simple(LL_haar, LH_haar, HL_haar, HH_haar);
reconstructed_db2 = manual_idwt2_simple(LL_db2, LH_db2, HL_db2, HH_db2);
reconstructed_sym4 = manual_idwt2_simple(LL_sym4, LH_sym4, HL_sym4, HH_sym4);

figure('Position', [100, 100, 1200, 800]);
subplot(2,2,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2,2,2); imshow(reconstructed_haar); title('Haar Wavelet');
subplot(2,2,3); imshow(reconstructed_db2); title('Daubechies 2 (db2)');
subplot(2,2,4); imshow(reconstructed_sym4); title('Symlet 4 (sym4)');
annotation('textbox', [0.3, 0.95, 0.4, 0.05], 'String', 'Exercise 2: Different Wavelet Bases Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Exercise 3: Remove high-frequency components in DFT and observe effects
F = fft2(img);
F_shifted = fftshift(F);
[rows, cols] = size(F_shifted);

% Create low-pass filters of different sizes
center_r = round(rows/2);
center_c = round(cols/2);

% Create masks for different cutoff frequencies
mask_large = zeros(rows, cols);
mask_medium = zeros(rows, cols);
mask_small = zeros(rows, cols);

% Large cutoff (keep more frequencies)
radius_large = min(rows, cols) * 0.3;
[X, Y] = meshgrid(1:cols, 1:rows);
mask_large = ((X - center_c).^2 + (Y - center_r).^2) <= radius_large^2;

% Medium cutoff
radius_medium = min(rows, cols) * 0.15;
mask_medium = ((X - center_c).^2 + (Y - center_r).^2) <= radius_medium^2;

% Small cutoff (keep only very low frequencies)
radius_small = min(rows, cols) * 0.05;
mask_small = ((X - center_c).^2 + (Y - center_r).^2) <= radius_small^2;

% Apply filters
F_filtered_large = F_shifted .* mask_large;
F_filtered_medium = F_shifted .* mask_medium;
F_filtered_small = F_shifted .* mask_small;

% Reconstruct images
reconstructed_large = real(ifft2(ifftshift(F_filtered_large)));
reconstructed_medium = real(ifft2(ifftshift(F_filtered_medium)));
reconstructed_small = real(ifft2(ifftshift(F_filtered_small)));

figure('Position', [100, 100, 1200, 800]);
subplot(2,2,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2,2,2); imshow(reconstructed_large); title('Large Cutoff (30%)');
subplot(2,2,3); imshow(reconstructed_medium); title('Medium Cutoff (15%)');
subplot(2,2,4); imshow(reconstructed_small); title('Small Cutoff (5%)');
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Exercise 3: DFT High-Frequency Removal Effects', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Summary output
fprintf('\n=== CHAPTER 6 TRANSFORM ANALYSIS ===\n');
fprintf('Exercise 1 - DCT Compression:\n');
fprintf('  25%% coefficients: Good quality, moderate compression\n');
fprintf('  10%% coefficients: Visible artifacts, high compression\n');
fprintf('  5%% coefficients: Strong artifacts, very high compression\n\n');

fprintf('Exercise 2 - Wavelet Comparison:\n');
fprintf('  Haar: Simple, good for step edges\n');
fprintf('  DB2: Better smoothness, good general purpose\n');
fprintf('  Sym4: More symmetric, good for natural images\n\n');

fprintf('Exercise 3 - DFT Frequency Filtering:\n');
fprintf('  Large cutoff: Slight blurring, preserves most details\n');
fprintf('  Medium cutoff: Noticeable blurring, reduced high frequencies\n');
fprintf('  Small cutoff: Strong blurring, only low frequencies remain\n');

% Complete transforms overview (run separately)
% Run: ch6_all_transforms
