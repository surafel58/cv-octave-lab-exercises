% Chapter 8 Practice 1: Gaussian Pyramid

% 2.2 Constructing a Gaussian Pyramid
pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

levels = 6;
g_pyramid = cell(1, levels);
g_pyramid{1} = img;

for i = 2:levels
    g_pyramid{i} = impyramid(g_pyramid{i-1}, 'reduce');
end

% Display Gaussian pyramid
figure('Position', [100, 100, 1200, 400]);
for i = 1:levels
    subplot(1, levels, i);
    imshow(g_pyramid{i});
    title(['Level ', num2str(i)], 'FontWeight', 'bold');
end
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Gaussian Pyramid', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Gaussian pyramid created with %d levels\n', levels);
fprintf('Original size: %dx%d\n', size(img, 1), size(img, 2));
for i = 2:levels
    fprintf('Level %d size: %dx%d\n', i, size(g_pyramid{i}, 1), size(g_pyramid{i}, 2));
end
