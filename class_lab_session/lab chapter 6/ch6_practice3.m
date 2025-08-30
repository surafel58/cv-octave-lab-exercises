% Chapter 6 Practice 3: Discrete Wavelet Transform (DWT)

% 5.2 Applying 2D DWT (Manual Implementation)
pkg load image;

% Load image
img = imread('../images/cameraman.tif');
img = im2double(img);

% Manual Haar Wavelet Transform Implementation
function [LL, LH, HL, HH] = manual_dwt2(img)
    [rows, cols] = size(img);
    
    % Ensure even dimensions for simplicity
    if mod(rows, 2) == 1
        img = img(1:rows-1, :);
        rows = rows - 1;
    end
    if mod(cols, 2) == 1
        img = img(:, 1:cols-1);
        cols = cols - 1;
    end
    
    % Haar wavelet coefficients
    h0 = [1, 1] / sqrt(2);  % Low-pass filter
    h1 = [1, -1] / sqrt(2); % High-pass filter
    
    % Row-wise filtering and downsampling
    temp_L = zeros(rows, cols/2);
    temp_H = zeros(rows, cols/2);
    
    for i = 1:rows
        row = img(i, :);
        % Convolve with filters and downsample
        conv_L = conv(row, h0, 'same');
        conv_H = conv(row, h1, 'same');
        temp_L(i, :) = conv_L(1:2:end);
        temp_H(i, :) = conv_H(1:2:end);
    end
    
    % Column-wise filtering and downsampling
    LL = zeros(rows/2, cols/2);
    LH = zeros(rows/2, cols/2);
    HL = zeros(rows/2, cols/2);
    HH = zeros(rows/2, cols/2);
    
    for j = 1:cols/2
        % Low-pass from row processing
        col_L = temp_L(:, j);
        conv_LL = conv(col_L, h0, 'same');
        conv_LH = conv(col_L, h1, 'same');
        LL(:, j) = conv_LL(1:2:end);
        LH(:, j) = conv_LH(1:2:end);
        
        % High-pass from row processing
        col_H = temp_H(:, j);
        conv_HL = conv(col_H, h0, 'same');
        conv_HH = conv(col_H, h1, 'same');
        HL(:, j) = conv_HL(1:2:end);
        HH(:, j) = conv_HH(1:2:end);
    end
end

% Manual Inverse Haar Wavelet Transform
function reconstructed = manual_idwt2(LL, LH, HL, HH)
    [sub_rows, sub_cols] = size(LL);
    rows = sub_rows * 2;
    cols = sub_cols * 2;
    
    % Haar reconstruction filters
    g0 = [1, 1] / sqrt(2);  % Low-pass reconstruction
    g1 = [1, -1] / sqrt(2); % High-pass reconstruction
    
    % Upsample and filter columns first
    temp_L = zeros(rows, sub_cols);
    temp_H = zeros(rows, sub_cols);
    
    for j = 1:sub_cols
        % Reconstruct from LL and LH
        upsampled_LL = zeros(rows, 1);
        upsampled_LH = zeros(rows, 1);
        upsampled_LL(1:2:end) = LL(:, j);
        upsampled_LH(1:2:end) = LH(:, j);
        temp_L(:, j) = conv(upsampled_LL, g0, 'same') + conv(upsampled_LH, g1, 'same');
        
        % Reconstruct from HL and HH
        upsampled_HL = zeros(rows, 1);
        upsampled_HH = zeros(rows, 1);
        upsampled_HL(1:2:end) = HL(:, j);
        upsampled_HH(1:2:end) = HH(:, j);
        temp_H(:, j) = conv(upsampled_HL, g0, 'same') + conv(upsampled_HH, g1, 'same');
    end
    
    % Upsample and filter rows
    reconstructed = zeros(rows, cols);
    for i = 1:rows
        upsampled_L = zeros(1, cols);
        upsampled_H = zeros(1, cols);
        upsampled_L(1:2:end) = temp_L(i, :);
        upsampled_H(1:2:end) = temp_H(i, :);
        reconstructed(i, :) = conv(upsampled_L, g0, 'same') + conv(upsampled_H, g1, 'same');
    end
end

% Apply 2D DWT with manual Haar wavelet
fprintf('Computing DWT with Haar wavelet...\n');
[LL, LH, HL, HH] = manual_dwt2(img);

% 5.3 Inverse DWT
fprintf('Computing inverse DWT...\n');
reconstructed_dwt = manual_idwt2(LL, LH, HL, HH);

% Display all results in one figure
figure('Position', [100, 100, 1200, 800]);

subplot(2, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(2, 3, 2);
imshow(LL, []);
title('Approximation (LL)');

subplot(2, 3, 3);
imshow(LH, []);
title('Horizontal Detail (LH)');

subplot(2, 3, 4);
imshow(HL, []);
title('Vertical Detail (HL)');

subplot(2, 3, 5);
imshow(HH, []);
title('Diagonal Detail (HH)');

subplot(2, 3, 6);
imshow(reconstructed_dwt);
title('Reconstructed Image from DWT');

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Chapter 6 Practice 3: Discrete Wavelet Transform', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
