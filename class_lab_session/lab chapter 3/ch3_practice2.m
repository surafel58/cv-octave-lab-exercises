% Chapter 3 Practice 2: Edge-Based Segmentation

% Load image
% img = imread('../images/cameraman.tif');
img = imread('../images/coins.png');
% Convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Apply different edge detectors
edge_sobel   = edge(img, 'sobel');
edge_prewitt = edge(img, 'prewitt');
edge_canny   = edge(img, 'canny');
edge_log     = edge(img, 'log');     % Laplacian of Gaussian
edge_roberts = edge(img, 'roberts');

% Display results in subplots
figure;
subplot(2,3,1), imshow(img), title('Original Image');
subplot(2,3,2), imshow(edge_sobel), title('Sobel');
subplot(2,3,3), imshow(edge_prewitt), title('Prewitt');
subplot(2,3,4), imshow(edge_canny), title('Canny');
subplot(2,3,5), imshow(edge_log), title('LoG');
subplot(2,3,6), imshow(edge_roberts), title('Roberts');
