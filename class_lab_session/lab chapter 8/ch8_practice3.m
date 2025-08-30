% Chapter 8 Practice 3: Image Reconstruction from Laplacian Pyramid

% 4. Image Reconstruction from Laplacian Pyramid
pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

levels = 4;

% Create Gaussian pyramid
g_pyramid = cell(1, levels);
g_pyramid{1} = img;
for i = 2:levels
    g_pyramid{i} = impyramid(g_pyramid{i-1}, 'reduce');
end

% Create Laplacian pyramid
L_pyramid = cell(1, levels-1);
for i = 1:levels-1
    upsampled = impyramid(g_pyramid{i+1}, 'expand');
    upsampled = imresize(upsampled, size(g_pyramid{i})); % Align sizes
    L_pyramid{i} = g_pyramid{i} - upsampled;
end

% Reconstruct image from Laplacian pyramid
reconstructed = g_pyramid{levels};
for i = levels-1:-1:1
    upsampled = impyramid(reconstructed, 'expand');
    upsampled = imresize(upsampled, size(L_pyramid{i}));
    reconstructed = L_pyramid{i} + upsampled;
end

% Display reconstruction comparison
figure('Position', [100, 100, 1000, 400]);
subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(reconstructed);
title('Reconstructed Image', 'FontWeight', 'bold');

subplot(1, 3, 3);
difference = abs(img - reconstructed);
imshow(difference, []);
title('Absolute Difference', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Laplacian Pyramid Reconstruction', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Calculate reconstruction error
mse = mean((img(:) - reconstructed(:)).^2);
psnr_value = 10 * log10(1 / mse);

% Calculate information loss percentage
total_pixels = numel(img);
different_pixels = sum(difference(:) > 0);
info_loss_percentage = (different_pixels / total_pixels) * 100;

% Calculate average pixel difference percentage
avg_pixel_diff = mean(difference(:));
avg_pixel_diff_percentage = (avg_pixel_diff / 1) * 100; % Since image is normalized to [0,1]

fprintf('Reconstruction Quality:\n');
fprintf('MSE: %.6f\n', mse);
fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('Max absolute difference: %.6f\n', max(difference(:)));
fprintf('Information loss percentage: %.2f%%\n', info_loss_percentage);
fprintf('Average pixel difference percentage: %.4f%%\n', avg_pixel_diff_percentage);

% Reconstruction Quality:
% MSE: 0.000000
% PSNR: 353.52 dB
% Max absolute difference: 0.000000
% Information loss percentage: 1.10%
% Average pixel difference percentage: 0.0000%
