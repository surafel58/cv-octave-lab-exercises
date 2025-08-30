% Chapter 9 Practice 2: Basic Noise Reduction Techniques

% Load and add noise
pkg load image;
img = im2double(imread('../images/cameraman.tif'));
gauss_img = imnoise(img, 'gaussian', 0, 0.01);
sp_img = imnoise(img, 'salt & pepper', 0.05);

% 3.1 Mean (Averaging) Filter
kernel = ones(3,3)/9;
mean_filtered = imfilter(gauss_img, kernel);

% 3.2 Median Filter (Best for Salt & Pepper)
median_filtered = medfilt2(sp_img);

% 3.3 Gaussian Filter
gaussian_filtered = imgaussfilt(gauss_img, 1);

% Display all filtering results
figure('Position', [100, 100, 1400, 800]);

% Row 1: Noisy images
subplot(2, 4, 1); imshow(img); title('Original', 'FontWeight', 'bold');
subplot(2, 4, 2); imshow(gauss_img); title('Gaussian Noise');
subplot(2, 4, 3); imshow(sp_img); title('Salt & Pepper Noise');
subplot(2, 4, 4); imshow(img); title('Reference', 'FontWeight', 'bold');

% Row 2: Filtered results
subplot(2, 4, 5); imshow(mean_filtered); title('Mean Filtered');
subplot(2, 4, 6); imshow(gaussian_filtered); title('Gaussian Filtered');
subplot(2, 4, 7); imshow(median_filtered); title('Median Filtered');
subplot(2, 4, 8); imshow(img); title('Original (Compare)');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Basic Noise Reduction Techniques', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Basic noise reduction completed:\n');
fprintf('- Mean filter: 3x3 averaging kernel\n');
fprintf('- Median filter: effective for salt & pepper\n');
fprintf('- Gaussian filter: sigma=1, smooths high-frequency noise\n');
