% Chapter 10 Practice 2: Corner Detection

% Load image
pkg load image;
img = im2double(imread('../images/cameraman.tif'));

% Convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% 3.1 Manual Harris Corner Detector Implementation
% Following the blog approach: https://technicache.wordpress.com/2010/11/24/harris-corner-detector-in-matla/

% Step 1: Compute image gradients using Sobel operators
Ix = conv2(img, [-1 0 1; -2 0 2; -1 0 1], 'same');
Iy = conv2(img, [-1 -2 -1; 0 0 0; 1 2 1], 'same');

% Step 2: Compute products of derivatives
Ixx = Ix .* Ix;
Iyy = Iy .* Iy;
Ixy = Ix .* Iy;

% Step 3: Apply Gaussian smoothing to the products
sigma = 1.5;
g = fspecial('gaussian', 6*sigma+1, sigma);
Sxx = conv2(Ixx, g, 'same');
Syy = conv2(Iyy, g, 'same');
Sxy = conv2(Ixy, g, 'same');

% Step 4: Compute Harris corner response
% R = det(M) - k * trace(M)^2
% where M = [Sxx Sxy; Sxy Syy]
k = 0.04;  % Harris parameter
det_M = Sxx .* Syy - Sxy .* Sxy;
trace_M = Sxx + Syy;
corners = det_M - k * (trace_M .^ 2);

% 3.2 Display Results
figure('Position', [100, 100, 1200, 400]);

% Original image
subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

% Corner response heatmap
subplot(1, 3, 2);
imagesc(corners);
colormap('hot');
colorbar;
title('Harris Corner Response Heatmap', 'FontWeight', 'bold');
axis image;
axis off;

% Corner locations
subplot(1, 3, 3);
corner_thresh = corners > 0.05 * max(corners(:));
[r, c] = find(corner_thresh);
imshow(img); hold on;
plot(c, r, 'r*', 'MarkerSize', 4);
title('Detected Corner Locations');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Harris Corner Detection', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Harris Corner Detection Results:\n');
fprintf('- Corner response range: [%.6f, %.6f]\n', min(corners(:)), max(corners(:)));
fprintf('- Corners detected (5%% threshold): %d\n', length(r));
