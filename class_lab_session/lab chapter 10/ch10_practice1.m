% Chapter 10 Practice 1: Edge Detection as Features

% 2.1 Canny Edge Detector
pkg load image;
img = im2double(imread('../images/cameraman.tif'));
edges = edge(img, 'canny');
imshow(edges);
title('Canny Edge Detection');

% Additional edge detection methods for comparison
figure('Position', [100, 100, 1400, 600]);

subplot(2, 4, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(2, 4, 2);
imshow(edges);
title('Canny Edge Detection');

% Compare with other edge detection methods
edges_sobel = edge(img, 'sobel');
subplot(2, 4, 3);
imshow(edges_sobel);
title('Sobel Edge Detection');

edges_prewitt = edge(img, 'prewitt');
subplot(2, 4, 4);
imshow(edges_prewitt);
title('Prewitt Edge Detection');

edges_roberts = edge(img, 'roberts');
subplot(2, 4, 5);
imshow(edges_roberts);
title('Roberts Edge Detection');

edges_log = edge(img, 'log');
subplot(2, 4, 6);
imshow(edges_log);
title('LoG Edge Detection');

% Edge statistics
subplot(2, 4, 7);
methods = {'Canny', 'Sobel', 'Prewitt', 'Roberts', 'LoG'};
edge_pixels = [sum(edges(:)), sum(edges_sobel(:)), sum(edges_prewitt(:)), ...
               sum(edges_roberts(:)), sum(edges_log(:))];
bar(edge_pixels);
set(gca, 'XTickLabel', methods);
title('Edge Pixels Count');
ylabel('Number of Edge Pixels');

subplot(2, 4, 8);
imshow(img);
title('Reference', 'FontWeight', 'bold');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Edge Detection Methods Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Edge Detection Analysis:\n');
fprintf('- Canny edges: %d pixels (%.2f%% of image)\n', sum(edges(:)), 100*sum(edges(:))/numel(img));
fprintf('- Sobel edges: %d pixels (%.2f%% of image)\n', sum(edges_sobel(:)), 100*sum(edges_sobel(:))/numel(img));
fprintf('- Prewitt edges: %d pixels (%.2f%% of image)\n', sum(edges_prewitt(:)), 100*sum(edges_prewitt(:))/numel(img));
fprintf('- Roberts edges: %d pixels (%.2f%% of image)\n', sum(edges_roberts(:)), 100*sum(edges_roberts(:))/numel(img));
fprintf('- LoG edges: %d pixels (%.2f%% of image)\n', sum(edges_log(:)), 100*sum(edges_log(:))/numel(img));
