% Chapter 8 Practice 2: Laplacian Pyramid

% 3.2 Constructing a Laplacian Pyramid
pkg load image;
img = im2double(imread('../images/peppers.png'));

% Check if image is RGB and convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

levels = 7;

% First create Gaussian pyramid
g_pyramid = cell(1, levels);
g_pyramid{1} = img;

for i = 2:levels
    g_pyramid{i} = impyramid(g_pyramid{i-1}, 'reduce');
end

% Create Laplacian pyramid
L_pyramid = cell(1, levels-1);
for i = 1:levels-1
    upsampled = impyramid(g_pyramid{i+1}, 'expand');
    upsampled = imresize(upsampled, size(g_pyramid{i})); % Align sizes
    L_pyramid{i} = g_pyramid{i} - upsampled;
end

% Display Laplacian pyramid
figure('Position', [100, 100, 1200, 400]);
for i = 1:levels-1
    subplot(1, levels-1, i);
    imshow(L_pyramid{i}, []);
    title(['Laplacian Level ', num2str(i)], 'FontWeight', 'bold');
end
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Laplacian Pyramid', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

fprintf('Laplacian pyramid created with %d levels\n', levels-1);
for i = 1:levels-1
    fprintf('L_pyramid{%d} range: [%.3f, %.3f]\n', i, min(L_pyramid{i}(:)), max(L_pyramid{i}(:)));
end
