% Chapter 9 Exercises: Advanced Noise Reduction and Restoration

pkg load image;
img = im2double(imread('../images/cameraman.tif'));

fprintf('Starting Chapter 9 Exercises...\n\n');

%% Exercise 1: Add noise of different types and levels; apply appropriate filters
fprintf('Exercise 1: Different Noise Types and Levels\n');

% Different noise levels
gauss_light = imnoise(img, 'gaussian', 0, 0.005);   % Light noise
gauss_medium = imnoise(img, 'gaussian', 0, 0.01);   % Medium noise
gauss_heavy = imnoise(img, 'gaussian', 0, 0.03);    % Heavy noise

sp_light = imnoise(img, 'salt & pepper', 0.02);     % Light salt & pepper
sp_medium = imnoise(img, 'salt & pepper', 0.05);    % Medium salt & pepper
sp_heavy = imnoise(img, 'salt & pepper', 0.10);     % Heavy salt & pepper

% Apply appropriate filters
% For Gaussian noise: Gaussian filter works best
gauss_light_filtered = imgaussfilt(gauss_light, 0.8);
gauss_medium_filtered = imgaussfilt(gauss_medium, 1.0);
gauss_heavy_filtered = imgaussfilt(gauss_heavy, 1.5);

% For Salt & Pepper: Median filter works best
sp_light_filtered = medfilt2(sp_light, [3 3]);
sp_medium_filtered = medfilt2(sp_medium, [3 3]);
sp_heavy_filtered = medfilt2(sp_heavy, [5 5]);

figure('Position', [50, 50, 1600, 800]);
% Row 1: Gaussian noise progression
subplot(3, 6, 1); imshow(gauss_light); title('Light Gaussian');
subplot(3, 6, 2); imshow(gauss_medium); title('Medium Gaussian');
subplot(3, 6, 3); imshow(gauss_heavy); title('Heavy Gaussian');
subplot(3, 6, 4); imshow(gauss_light_filtered); title('Filtered Light');
subplot(3, 6, 5); imshow(gauss_medium_filtered); title('Filtered Medium');
subplot(3, 6, 6); imshow(gauss_heavy_filtered); title('Filtered Heavy');

% Row 2: Salt & Pepper noise progression
subplot(3, 6, 7); imshow(sp_light); title('Light S&P');
subplot(3, 6, 8); imshow(sp_medium); title('Medium S&P');
subplot(3, 6, 9); imshow(sp_heavy); title('Heavy S&P');
subplot(3, 6, 10); imshow(sp_light_filtered); title('Median Light');
subplot(3, 6, 11); imshow(sp_medium_filtered); title('Median Medium');
subplot(3, 6, 12); imshow(sp_heavy_filtered); title('Median Heavy');

% Row 3: Original and comparison
subplot(3, 6, 13); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(3, 6, 14); imshow(img); title('Reference', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 1: Noise Types and Levels', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 2: Compare PSNR values of all restoration results
fprintf('Exercise 2: PSNR Comparison of All Methods\n');

% Calculate PSNR for all restoration methods
methods = {'Light Gauss + Gauss Filter', 'Medium Gauss + Gauss Filter', 'Heavy Gauss + Gauss Filter', ...
           'Light S&P + Median Filter', 'Medium S&P + Median Filter', 'Heavy S&P + Median Filter'};
filtered_images = {gauss_light_filtered, gauss_medium_filtered, gauss_heavy_filtered, ...
                   sp_light_filtered, sp_medium_filtered, sp_heavy_filtered};

psnr_values = zeros(1, length(filtered_images));
mse_values = zeros(1, length(filtered_images));

for i = 1:length(filtered_images)
    mse_values(i) = mean((img(:) - filtered_images{i}(:)).^2);
    psnr_values(i) = 10 * log10(1 / mse_values(i));
end

% Display PSNR comparison
figure('Position', [100, 100, 1200, 600]);
bar(psnr_values);
set(gca, 'XTickLabel', {'Light G', 'Med G', 'Heavy G', 'Light SP', 'Med SP', 'Heavy SP'});
title('PSNR Comparison of Restoration Methods', 'FontWeight', 'bold');
ylabel('PSNR (dB)');
xlabel('Noise Type and Level');
grid on;

% Print detailed PSNR table
fprintf('\n=== EXERCISE 2: PSNR COMPARISON TABLE ===\n');
fprintf('Method                        | PSNR (dB) | MSE\n');
fprintf('------------------------------|-----------|----------\n');
for i = 1:length(methods)
    fprintf('%-29s | %8.2f  | %.6f\n', methods{i}, psnr_values(i), mse_values(i));
end
fprintf('=========================================\n');

%% Exercise 3: Implement motion blur followed by inverse filtering
fprintf('Exercise 3: Motion Blur and Inverse Filtering\n');

% Create different motion blur kernels
PSF1 = fspecial('motion', 10, 30);   % 10 pixels, 30 degrees
PSF2 = fspecial('motion', 15, 45);   % 15 pixels, 45 degrees
PSF3 = fspecial('motion', 20, 60);   % 20 pixels, 60 degrees

% Apply motion blur
blurred1 = imfilter(img, PSF1, 'conv', 'circular');
blurred2 = imfilter(img, PSF2, 'conv', 'circular');
blurred3 = imfilter(img, PSF3, 'conv', 'circular');

% Apply inverse filtering
restored1 = deconvwnr(blurred1, PSF1);
restored2 = deconvwnr(blurred2, PSF2);
restored3 = deconvwnr(blurred3, PSF3);

figure('Position', [50, 100, 1400, 800]);
% Row 1: Motion blurred images
subplot(3, 4, 1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(3, 4, 2); imshow(blurred1); title('Motion 10px, 30°');
subplot(3, 4, 3); imshow(blurred2); title('Motion 15px, 45°');
subplot(3, 4, 4); imshow(blurred3); title('Motion 20px, 60°');

% Row 2: Restored images
subplot(3, 4, 5); imshow(img); title('Reference', 'FontWeight', 'bold');
subplot(3, 4, 6); imshow(restored1); title('Restored 10px, 30°');
subplot(3, 4, 7); imshow(restored2); title('Restored 15px, 45°');
subplot(3, 4, 8); imshow(restored3); title('Restored 20px, 60°');

% Row 3: PSF visualizations
subplot(3, 4, 9); imshow(PSF1, []); title('PSF 10px, 30°');
subplot(3, 4, 10); imshow(PSF2, []); title('PSF 15px, 45°');
subplot(3, 4, 11); imshow(PSF3, []); title('PSF 20px, 60°');

% Calculate restoration PSNR
psnr_restore1 = 10 * log10(1 / mean((img(:) - restored1(:)).^2));
psnr_restore2 = 10 * log10(1 / mean((img(:) - restored2(:)).^2));
psnr_restore3 = 10 * log10(1 / mean((img(:) - restored3(:)).^2));

subplot(3, 4, 12);
bar([psnr_restore1, psnr_restore2, psnr_restore3]);
set(gca, 'XTickLabel', {'10px,30°', '15px,45°', '20px,60°'});
title('Restoration PSNR');
ylabel('PSNR (dB)');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 3: Motion Blur and Inverse Filtering', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 4: Combine spatial and frequency domain filtering
fprintf('Exercise 4: Combined Spatial and Frequency Domain Filtering\n');

% Create heavily corrupted image
corrupted = imnoise(img, 'gaussian', 0, 0.02);
corrupted = imnoise(corrupted, 'salt & pepper', 0.03);

% Step 1: Spatial domain - Remove salt & pepper with median filter
spatial_cleaned = medfilt2(corrupted, [3 3]);

% Step 2: Frequency domain - Remove high-frequency noise with FFT
F = fft2(spatial_cleaned);
F_shifted = fftshift(F);

% Create low-pass filter in frequency domain
[rows, cols] = size(img);
center_row = floor(rows/2) + 1;
center_col = floor(cols/2) + 1;
cutoff = 50; % Low-pass cutoff radius

[X, Y] = meshgrid(1:cols, 1:rows);
distance = sqrt((X - center_col).^2 + (Y - center_row).^2);
freq_filter = double(distance <= cutoff);

% Apply frequency filter
F_filtered = F_shifted .* freq_filter;
F_ishifted = ifftshift(F_filtered);
freq_cleaned = real(ifft2(F_ishifted));

% Step 3: Final spatial enhancement with Wiener filter
final_restored = wiener2(freq_cleaned, [5 5]);

% Calculate quality metrics
psnr_corrupted = 10 * log10(1 / mean((img(:) - corrupted(:)).^2));
psnr_spatial = 10 * log10(1 / mean((img(:) - spatial_cleaned(:)).^2));
psnr_frequency = 10 * log10(1 / mean((img(:) - freq_cleaned(:)).^2));
psnr_final = 10 * log10(1 / mean((img(:) - final_restored(:)).^2));

figure('Position', [50, 150, 1400, 800]);
subplot(2, 4, 1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2, 4, 2); imshow(corrupted); title(sprintf('Corrupted\nPSNR: %.2f dB', psnr_corrupted));
subplot(2, 4, 3); imshow(spatial_cleaned); title(sprintf('Spatial (Median)\nPSNR: %.2f dB', psnr_spatial));
subplot(2, 4, 4); imshow(freq_cleaned); title(sprintf('Frequency (FFT)\nPSNR: %.2f dB', psnr_frequency));

subplot(2, 4, 5); imshow(final_restored); title(sprintf('Final (Wiener)\nPSNR: %.2f dB', psnr_final));
subplot(2, 4, 6); imshow(abs(F_shifted), []); title('FFT Magnitude'); colormap(gca, 'hot');
subplot(2, 4, 7); imshow(freq_filter); title('Frequency Filter');
subplot(2, 4, 8); 
restoration_steps = [psnr_corrupted, psnr_spatial, psnr_frequency, psnr_final];
plot(restoration_steps, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
set(gca, 'XTickLabel', {'Corrupted', 'Spatial', 'Frequency', 'Final'});
title('Restoration Progress');
ylabel('PSNR (dB)');
grid on;

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 4: Combined Spatial-Frequency Restoration', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('\n=== EXERCISE 4: COMBINED RESTORATION PIPELINE ===\n');
fprintf('Step                  | PSNR (dB) | Improvement\n');
fprintf('----------------------|-----------|------------\n');
fprintf('Original Corrupted    | %8.2f  | baseline\n', psnr_corrupted);
fprintf('After Spatial Filter  | %8.2f  | +%.2f dB\n', psnr_spatial, psnr_spatial - psnr_corrupted);
fprintf('After Frequency Filter| %8.2f  | +%.2f dB\n', psnr_frequency, psnr_frequency - psnr_spatial);
fprintf('After Final Wiener    | %8.2f  | +%.2f dB\n', psnr_final, psnr_final - psnr_frequency);
fprintf('Total Improvement     |          | +%.2f dB\n', psnr_final - psnr_corrupted);
fprintf('===============================================\n');

fprintf('\nAll exercises completed successfully!\n');
fprintf('Exercise 1: Tested 6 noise scenarios with appropriate filters\n');
fprintf('Exercise 2: Compared PSNR values across all methods\n');
fprintf('Exercise 3: Demonstrated motion blur and inverse filtering\n');
fprintf('Exercise 4: Combined spatial-frequency domain restoration pipeline\n');
