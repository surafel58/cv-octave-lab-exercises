% Chapter 5 Exercises: Advanced Filtering Techniques

% Load image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% Exercise 1: Apply filters of different sizes (5x5, 7x7) and compare results
kernel_3x3 = ones(3,3)/9;
kernel_5x5 = ones(5,5)/25;
kernel_7x7 = ones(7,7)/49;

filtered_3x3 = imfilter(img, kernel_3x3);
filtered_5x5 = imfilter(img, kernel_5x5);
filtered_7x7 = imfilter(img, kernel_7x7);

figure('Position', [100, 100, 1000, 700]);
subplot(2,2,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2,2,2); imshow(filtered_3x3); title('3×3 Filter');
subplot(2,2,3); imshow(filtered_5x5); title('5×5 Filter');
subplot(2,2,4); imshow(filtered_7x7); title('7×7 Filter');
% Add overall title manually
annotation('textbox', [0.3, 0.95, 0.4, 0.05], 'String', 'Exercise 1: Filter Size Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');

% Exercise 2: Implement unsharp masking manually
gaussian_blur = imgaussfilt(img, 1.5);
unsharp_mask = img - gaussian_blur;
sharpened_unsharp = img + 1.5 * unsharp_mask;  % Enhancement factor of 1.5
figure('Position', [100, 100, 1200, 400]);
subplot(1,3,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(1,3,2); imshow(gaussian_blur); title('Blurred (σ=1.5)');
subplot(1,3,3); imshow(sharpened_unsharp); title('Unsharp Masked (×1.5)');
% Add overall title manually
annotation('textbox', [0.3, 0.95, 0.4, 0.05], 'String', 'Exercise 2: Manual Unsharp Masking', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');

% Exercise 3: Test filtering on noisy images and evaluate PSNR
noisy_img = imnoise(img, 'gaussian', 0, 0.01);  % Add Gaussian noise
filtered_noisy = imgaussfilt(noisy_img, 1);

% Calculate PSNR
mse_original = mean((img(:) - noisy_img(:)).^2);
mse_filtered = mean((img(:) - filtered_noisy(:)).^2);
psnr_noisy = 10 * log10(1 / mse_original);
psnr_filtered = 10 * log10(1 / mse_filtered);

figure('Position', [100, 100, 1200, 400]);
subplot(1,3,1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(1,3,2); imshow(noisy_img); title(sprintf('Noisy (PSNR: %.2f dB)', psnr_noisy));
subplot(1,3,3); imshow(filtered_noisy); title(sprintf('Filtered (PSNR: %.2f dB)', psnr_filtered));
% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Exercise 3: Noise Filtering and PSNR Evaluation', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');

fprintf('PSNR Improvement: %.2f dB\n', psnr_filtered - psnr_noisy);

% Exercise 4: Template Matching with Cross-Correlation
patch_size = 55;
patch_x = 85;
patch_y = 35;
patch = img(patch_y:patch_y+patch_size-1, patch_x:patch_x+patch_size-1);

% Perform normalized cross-correlation
correlation_result = normxcorr2(patch, img);
[max_corr, max_idx] = max(correlation_result(:));
[y_peak, x_peak] = ind2sub(size(correlation_result), max_idx);

% Adjust coordinates for display
y_offset = y_peak - size(patch, 1);
x_offset = x_peak - size(patch, 2);

figure('Position', [100, 100, 1200, 600]);

subplot(2,3,1); 
imshow(img); 
title('Original Image', 'FontWeight', 'bold');
hold on;
rectangle('Position', [patch_x, patch_y, patch_size, patch_size], 'EdgeColor', 'red', 'LineWidth', 2);
text(patch_x+5, patch_y-5, 'Template', 'Color', 'red', 'FontWeight', 'bold');
hold off;

subplot(2,3,2); 
imshow(patch); 
title('Template Patch');

subplot(2,3,3); 
imshow(correlation_result, []); 
colormap(gca, 'hot'); 
colorbar;
title('Correlation Result');

subplot(2,3,4);
imshow(img); 
title('Best Match Found');
hold on;
rectangle('Position', [x_offset, y_offset, patch_size, patch_size], 'EdgeColor', 'green', 'LineWidth', 3);
plot(x_offset + patch_size/2, y_offset + patch_size/2, 'g+', 'MarkerSize', 15, 'LineWidth', 3);
text(x_offset+5, y_offset-5, 'Match', 'Color', 'green', 'FontWeight', 'bold');
hold off;

subplot(2,3,5);
imagesc(correlation_result); 
colormap(gca, 'jet'); 
colorbar;
title('Correlation Map (Enhanced)');
axis equal; axis tight;

subplot(2,3,6);
center_line = correlation_result(round(size(correlation_result,1)/2), :);
plot(center_line, 'b-', 'LineWidth', 2);
title('Correlation Profile'); 
xlabel('X Position');
ylabel('Correlation');
grid on;

% Add overall title manually
annotation('textbox', [0.2, 0.95, 0.6, 0.05], 'String', 'Exercise 4: Template Matching with Cross-Correlation', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');

fprintf('\n=== TEMPLATE MATCHING RESULTS ===\n');
fprintf('Template extracted from: (%d, %d)\n', patch_x, patch_y);
fprintf('Template size: %d x %d pixels\n', patch_size, patch_size);
fprintf('Maximum correlation: %.4f\n', max_corr);
fprintf('Best match found at: (%d, %d)\n', x_offset, y_offset);
fprintf('Distance from original: %.2f pixels\n', sqrt((x_offset-patch_x)^2 + (y_offset-patch_y)^2));

if max_corr > 0.9
    fprintf('RESULT: Excellent match (>0.9)!\n');
elseif max_corr > 0.7
    fprintf('RESULT: Good match (0.7-0.9)\n');
else
    fprintf('RESULT: Poor match (<0.7)\n');
end

% Interactive filter comparison (run separately)
% Run: ch5_interactive_filters

% Complete filter overview (run separately)
% Run: ch5_all_filters