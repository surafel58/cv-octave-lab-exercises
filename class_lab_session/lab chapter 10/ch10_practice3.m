% Chapter 10 Practice 3: Blob Detection using LoG

% Load image
pkg load image;
img = im2double(imread('../images/cameraman.tif'));

% 4. Blob Detection using LoG (Laplacian of Gaussian)
log_filter = fspecial('log', [5 5], 0.5);
blob_img = imfilter(img, log_filter, 'replicate');
imshow(blob_img, []);
title('Blob Detection via LoG');

% Extended analysis with different LoG parameters
figure('Position', [100, 100, 1400, 800]);

subplot(2, 4, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

% Different LoG filter sizes and sigmas
log_3x3 = fspecial('log', [3 3], 0.3);
blob_3x3 = imfilter(img, log_3x3, 'replicate');
subplot(2, 4, 2);
imshow(blob_3x3, []);
title('LoG 3x3, σ=0.3');

log_5x5 = fspecial('log', [5 5], 0.5);
blob_5x5 = imfilter(img, log_5x5, 'replicate');
subplot(2, 4, 3);
imshow(blob_5x5, []);
title('LoG 5x5, σ=0.5');

log_7x7 = fspecial('log', [7 7], 0.8);
blob_7x7 = imfilter(img, log_7x7, 'replicate');
subplot(2, 4, 4);
imshow(blob_7x7, []);
title('LoG 7x7, σ=0.8');

% Detect blob centers (local maxima in negative response)
blob_response = -blob_5x5; % Negative for blob detection
blob_thresh = blob_response > 0.02;
blob_centers = blob_thresh;

% Clean up small responses
se = strel('disk', 2);
blob_centers = imopen(blob_centers, se);

subplot(2, 4, 5);
imshow(blob_centers);
title('Blob Centers (Thresholded)');

% Mark blobs on original image
[blob_r, blob_c] = find(blob_centers);
subplot(2, 4, 6);
imshow(img); hold on;
plot(blob_c, blob_r, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title(sprintf('Detected Blobs (%d found)', length(blob_r)));

% LoG filter visualization
subplot(2, 4, 7);
surf(log_5x5);
title('LoG Filter 5x5');
axis tight;

% Response histogram
subplot(2, 4, 8);
histogram(blob_response(:), 50);
title('LoG Response Distribution');
xlabel('Response Value');
ylabel('Frequency');
grid on;

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Laplacian of Gaussian Blob Detection', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Blob Detection Analysis:\n');
fprintf('- LoG 3x3 (σ=0.3): Response range [%.4f, %.4f]\n', min(blob_3x3(:)), max(blob_3x3(:)));
fprintf('- LoG 5x5 (σ=0.5): Response range [%.4f, %.4f]\n', min(blob_5x5(:)), max(blob_5x5(:)));
fprintf('- LoG 7x7 (σ=0.8): Response range [%.4f, %.4f]\n', min(blob_7x7(:)), max(blob_7x7(:)));
fprintf('- Detected blob centers: %d\n', length(blob_r));
fprintf('- Blob density: %.2f blobs per 1000 pixels\n', 1000*length(blob_r)/numel(img));
