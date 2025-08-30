% Chapter 9 Practice 4: Comparing Restoration Results

% 5. Comparing Results using PSNR
pkg load image;
img = im2double(imread('../images/cameraman.tif'));

% Add different types of noise
gauss_img = imnoise(img, 'gaussian', 0, 0.01);
sp_img = imnoise(img, 'salt & pepper', 0.05);

% Apply different filters
kernel = ones(3,3)/9;
mean_filtered = imfilter(gauss_img, kernel);
median_filtered = medfilt2(sp_img);
gaussian_filtered = imgaussfilt(gauss_img, 1);
wiener_img = wiener2(gauss_img, [5 5]);

% Calculate PSNR for each method
mse_mean = mean((img(:) - mean_filtered(:)).^2);
psnr_mean = 10 * log10(1 / mse_mean);

mse_median = mean((img(:) - median_filtered(:)).^2);
psnr_median = 10 * log10(1 / mse_median);

mse_gaussian = mean((img(:) - gaussian_filtered(:)).^2);
psnr_gaussian = 10 * log10(1 / mse_gaussian);

mse_wiener = mean((img(:) - wiener_img(:)).^2);
psnr_wiener = 10 * log10(1 / mse_wiener);

% Display comparison
figure('Position', [100, 100, 1400, 800]);

subplot(2, 4, 1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2, 4, 2); imshow(gauss_img); title('Gaussian Noise');
subplot(2, 4, 3); imshow(sp_img); title('Salt & Pepper Noise');
subplot(2, 4, 4); imshow(img); title('Reference', 'FontWeight', 'bold');

subplot(2, 4, 5); imshow(mean_filtered); title(sprintf('Mean Filter\nPSNR: %.2f dB', psnr_mean));
subplot(2, 4, 6); imshow(gaussian_filtered); title(sprintf('Gaussian Filter\nPSNR: %.2f dB', psnr_gaussian));
subplot(2, 4, 7); imshow(median_filtered); title(sprintf('Median Filter\nPSNR: %.2f dB', psnr_median));
subplot(2, 4, 8); imshow(wiener_img); title(sprintf('Wiener Filter\nPSNR: %.2f dB', psnr_wiener));

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Restoration Performance Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Print detailed comparison
fprintf('=== RESTORATION PERFORMANCE COMPARISON ===\n');
fprintf('Method              | PSNR (dB) | MSE      | Best For\n');
fprintf('--------------------|-----------|----------|------------------\n');
fprintf('Mean Filter         | %8.2f  | %.6f | Gaussian noise\n', psnr_mean, mse_mean);
fprintf('Gaussian Filter     | %8.2f  | %.6f | Gaussian noise\n', psnr_gaussian, mse_gaussian);
fprintf('Median Filter       | %8.2f  | %.6f | Salt & pepper\n', psnr_median, mse_median);
fprintf('Wiener Filter       | %8.2f  | %.6f | Adaptive filtering\n', psnr_wiener, mse_wiener);
fprintf('===========================================\n');
