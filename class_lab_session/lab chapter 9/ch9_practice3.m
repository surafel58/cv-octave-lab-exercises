% Chapter 9 Practice 3: Advanced Image Restoration Techniques

% Load and prepare images
pkg load image;
img = im2double(imread('../images/cameraman.tif'));
gauss_img = imnoise(img, 'gaussian', 0, 0.01);

% 4.1 Wiener Filter
wiener_img = wiener2(gauss_img, [5 5]);

% 4.2 Inverse Filtering (Deblurring)
PSF = fspecial('motion', 15, 45);
blurred = imfilter(img, PSF, 'conv', 'circular');
restored = deconvwnr(blurred, PSF);

% Display advanced restoration results
figure('Position', [100, 100, 1400, 600]);

subplot(2, 3, 1); imshow(img); title('Original Image', 'FontWeight', 'bold');
subplot(2, 3, 2); imshow(gauss_img); title('Gaussian Noisy Image');
subplot(2, 3, 3); imshow(wiener_img); title('Wiener Filtered Image');

subplot(2, 3, 4); imshow(img); title('Original (Reference)', 'FontWeight', 'bold');
subplot(2, 3, 5); imshow(blurred); title('Motion Blurred Image');
subplot(2, 3, 6); imshow(restored); title('Inverse Filtered (Deblurred) Image');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Advanced Image Restoration Techniques', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Advanced restoration completed:\n');
fprintf('- Wiener filter: 5x5 neighborhood, adaptive filtering\n');
fprintf('- Motion blur PSF: 15 pixels, 45 degrees\n');
fprintf('- Inverse filtering: deconvolution with known PSF\n');
