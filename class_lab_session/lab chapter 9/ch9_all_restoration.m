% Chapter 9: Complete Noise Reduction and Restoration Overview

pkg load image;
img = im2double(imread('../images/cameraman.tif'));

fprintf('Building complete noise reduction and restoration overview...\n');

% Generate different noise types
gauss_img = imnoise(img, 'gaussian', 0, 0.01);
sp_img = imnoise(img, 'salt & pepper', 0.05);

% Motion blur for restoration
PSF = fspecial('motion', 15, 45);
blurred = imfilter(img, PSF, 'conv', 'circular');

% Apply all filtering techniques
kernel = ones(3,3)/9;
mean_filtered = imfilter(gauss_img, kernel);
median_filtered = medfilt2(sp_img);
gaussian_filtered = imgaussfilt(gauss_img, 1);
wiener_filtered = wiener2(gauss_img, [5 5]);
inverse_filtered = deconvwnr(blurred, PSF);

% Advanced combined restoration
corrupted = imnoise(img, 'gaussian', 0, 0.02);
corrupted = imnoise(corrupted, 'salt & pepper', 0.03);
spatial_cleaned = medfilt2(corrupted, [3 3]);

% Frequency domain filtering
F = fft2(spatial_cleaned);
F_shifted = fftshift(F);
[rows, cols] = size(img);
center_row = floor(rows/2) + 1;
center_col = floor(cols/2) + 1;
[X, Y] = meshgrid(1:cols, 1:rows);
distance = sqrt((X - center_col).^2 + (Y - center_row).^2);
freq_filter = double(distance <= 60);
F_filtered = F_shifted .* freq_filter;
freq_cleaned = real(ifft2(ifftshift(F_filtered)));
final_restored = wiener2(freq_cleaned, [5 5]);

% Calculate all PSNR values
methods = {'Mean Filter', 'Gaussian Filter', 'Median Filter', 'Wiener Filter', ...
           'Inverse Filter', 'Combined Restoration'};
filtered_results = {mean_filtered, gaussian_filtered, median_filtered, wiener_filtered, ...
                    inverse_filtered, final_restored};

psnr_all = zeros(1, length(filtered_results));
for i = 1:length(filtered_results)
    mse = mean((img(:) - filtered_results{i}(:)).^2);
    psnr_all(i) = 10 * log10(1 / mse);
end

% Create comprehensive display
figure('Position', [50, 50, 1600, 1000], 'Name', 'Complete Noise Reduction Overview');

% Row 1: Original and noise types
subplot(4, 5, 1); imshow(img); title('Original', 'FontWeight', 'bold', 'FontSize', 11);
subplot(4, 5, 2); imshow(gauss_img); title('Gaussian Noise', 'FontSize', 10);
subplot(4, 5, 3); imshow(sp_img); title('Salt & Pepper', 'FontSize', 10);
subplot(4, 5, 4); imshow(blurred); title('Motion Blurred', 'FontSize', 10);
subplot(4, 5, 5); imshow(corrupted); title('Heavily Corrupted', 'FontSize', 10);

% Row 2: Basic filtering results
subplot(4, 5, 6); imshow(mean_filtered); title(sprintf('Mean Filter\n%.2f dB', psnr_all(1)), 'FontSize', 10);
subplot(4, 5, 7); imshow(gaussian_filtered); title(sprintf('Gaussian Filter\n%.2f dB', psnr_all(2)), 'FontSize', 10);
subplot(4, 5, 8); imshow(median_filtered); title(sprintf('Median Filter\n%.2f dB', psnr_all(3)), 'FontSize', 10);
subplot(4, 5, 9); imshow(wiener_filtered); title(sprintf('Wiener Filter\n%.2f dB', psnr_all(4)), 'FontSize', 10);
subplot(4, 5, 10); imshow(inverse_filtered); title(sprintf('Inverse Filter\n%.2f dB', psnr_all(5)), 'FontSize', 10);

% Row 3: Advanced restoration pipeline
subplot(4, 5, 11); imshow(spatial_cleaned); title('Step 1: Spatial', 'FontSize', 10);
subplot(4, 5, 12); imshow(freq_cleaned); title('Step 2: Frequency', 'FontSize', 10);
subplot(4, 5, 13); imshow(final_restored); title(sprintf('Step 3: Final\n%.2f dB', psnr_all(6)), 'FontSize', 10);
subplot(4, 5, 14); imshow(freq_filter); title('Frequency Mask', 'FontSize', 10);
subplot(4, 5, 15); imshow(abs(F_shifted), []); title('FFT Spectrum', 'FontSize', 10); colormap(gca, 'hot');

% Row 4: Performance comparison and PSF examples
subplot(4, 5, 16);
bar(psnr_all);
set(gca, 'XTickLabel', {'Mean', 'Gauss', 'Median', 'Wiener', 'Inverse', 'Combined'});
title('PSNR Comparison', 'FontSize', 10);
ylabel('PSNR (dB)');

subplot(4, 5, 17); imshow(PSF, []); title('Motion PSF', 'FontSize', 10);
subplot(4, 5, 18); imshow(kernel, []); title('Mean Kernel', 'FontSize', 10);

% Best and worst comparison
[best_psnr, best_idx] = max(psnr_all);
[worst_psnr, worst_idx] = min(psnr_all);
subplot(4, 5, 19); imshow(filtered_results{best_idx}); title(sprintf('Best: %s\n%.2f dB', methods{best_idx}, best_psnr), 'FontSize', 9);
subplot(4, 5, 20); imshow(filtered_results{worst_idx}); title(sprintf('Worst: %s\n%.2f dB', methods{worst_idx}, worst_psnr), 'FontSize', 9);

% Add main title
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Complete Noise Reduction and Restoration Overview', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Add section labels
annotation('textbox', [0.02, 0.82, 0.1, 0.03], 'String', 'Noise Types:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.62, 0.1, 0.03], 'String', 'Basic Filters:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.42, 0.1, 0.03], 'String', 'Advanced Pipeline:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.22, 0.1, 0.03], 'String', 'Analysis:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');

% Print comprehensive summary
fprintf('\n=== COMPLETE RESTORATION ANALYSIS ===\n');
fprintf('Technique             | PSNR (dB) | Application\n');
fprintf('----------------------|-----------|------------------\n');
for i = 1:length(methods)
    if i == 1, app = 'Gaussian noise'; end
    if i == 2, app = 'Gaussian noise'; end
    if i == 3, app = 'Salt & pepper'; end
    if i == 4, app = 'Adaptive filtering'; end
    if i == 5, app = 'Motion deblurring'; end
    if i == 6, app = 'Multi-domain'; end
    fprintf('%-21s | %8.2f  | %s\n', methods{i}, psnr_all(i), app);
end
fprintf('=======================================\n');
fprintf('Best method: %s (%.2f dB)\n', methods{best_idx}, best_psnr);
fprintf('Combined approach shows %.2f dB improvement over worst single method\n', best_psnr - worst_psnr);
