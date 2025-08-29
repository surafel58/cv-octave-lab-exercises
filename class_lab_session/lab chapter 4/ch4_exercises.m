% Chapter 4 Exercises: Suggested Exercises

% Load required package
pkg load image;

% Read and binarize image
img = imread('../images/lena.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);

fprintf('=== EXERCISE 1: Different Structuring Elements Comparison ===\n');

% Exercise 1: Use different structuring elements and compare outputs
se_square = strel('square', 3);
se_diamond = strel('diamond', 2);
se_line_h = strel('line', 5, 0);    % Horizontal line
se_line_v = strel('line', 5, 90);   % Vertical line

% Apply erosion with different structuring elements
eroded_square = imerode(binary_img, se_square);
eroded_diamond = imerode(binary_img, se_diamond);
eroded_line_h = imerode(binary_img, se_line_h);
eroded_line_v = imerode(binary_img, se_line_v);

% Display comparison of different structuring elements
figure('Name', 'Exercise 1: Structuring Element Comparison', 'Position', [100, 100, 1000, 600]);
subplot(2,3,1); imshow(binary_img); title('Original Binary Image');
subplot(2,3,2); imshow(eroded_square); title('Erosion - Square 3x3');
subplot(2,3,3); imshow(eroded_diamond); title('Erosion - Diamond r=2');
subplot(2,3,4); imshow(eroded_line_h); title('Erosion - Horizontal Line');
subplot(2,3,5); imshow(eroded_line_v); title('Erosion - Vertical Line');

% Show structuring elements
subplot(2,3,6);
axis off;
text(0.1, 0.9, 'Structuring Elements:', 'FontSize', 12, 'FontWeight', 'bold');
text(0.1, 0.8, '• Square: Uniform shrinking', 'FontSize', 10);
text(0.1, 0.7, '• Diamond: Diagonal emphasis', 'FontSize', 10);
text(0.1, 0.6, '• Horizontal Line: Vertical features', 'FontSize', 10);
text(0.1, 0.5, '• Vertical Line: Horizontal features', 'FontSize', 10);
text(0.1, 0.3, 'Different shapes produce', 'FontSize', 10, 'Color', 'red');
text(0.1, 0.2, 'different morphological effects', 'FontSize', 10, 'Color', 'red');

fprintf('Exercise 1 completed: Different SE shapes show varying effects\n');

fprintf('\n=== EXERCISE 2: Noise Removal with Opening and Closing ===\n');

% Exercise 2: Apply opening and closing to a noisy image
% Create a noisy version of the binary image
img = imread('../images/lena.png');
gray = rgb2gray(img);
binary_img = im2bw(gray, 0.5);
noisy_img = binary_img;

% Add salt noise (random white pixels)
[rows, cols] = size(binary_img);
salt_noise = rand(rows, cols) < 0.05;  % 5% salt noise
noisy_img = noisy_img | salt_noise;

% Add pepper noise (random black pixels)
pepper_noise = rand(rows, cols) < 0.03;  % 3% pepper noise
noisy_img = noisy_img & ~pepper_noise;

% Apply morphological operations for noise removal
se_clean = strel('square', 2);
opened_clean = imopen(noisy_img, se_clean);          % Removes salt noise only
closed_only = imclose(noisy_img, se_clean);          % Removes pepper noise only
opening_closing = imclose(imopen(noisy_img, se_clean), se_clean); % Opening then closing
closing_opening = imopen(imclose(noisy_img, se_clean), se_clean); % Closing then opening

% Display noise removal results
figure('Name', 'Exercise 2: Noise Removal Effectiveness', 'Position', [150, 150, 1200, 400]);
subplot(1,5,1); imshow(noisy_img); title('Noisy Image');
subplot(1,5,2); imshow(opened_clean); title('Opening Only');
subplot(1,5,3); imshow(closed_only); title('Closing Only');
subplot(1,5,4); imshow(opening_closing); title('Opening → Closing');
subplot(1,5,5); imshow(closing_opening); title('Closing → Opening');

fprintf('Exercise 2 completed: Different operations show varying noise removal effectiveness\n');

fprintf('\n=== EXERCISE 3: Text Extraction from Stop Sign Image ===\n');

% Exercise 3: Text extraction using morphological operations
% Load actual text image (stop sign - excellent for text extraction)
text_source_img = imread('../images/stop-sign.jpg');

% Convert to grayscale and binary
if size(text_source_img, 3) == 3
    text_gray = rgb2gray(text_source_img);
else
    text_gray = text_source_img;
end

% Create binary image with thresholding optimized for stop sign (white text on red background)
text_binary = im2bw(text_gray, 0.6);  % Higher threshold for white text extraction

% Invert if text is dark on light background
text_mean = mean(text_binary(:));
if text_mean > 0.5
    text_binary = ~text_binary;  % Invert so text is white on black background
end

fprintf('Loaded text image: %dx%d pixels\n', size(text_binary,1), size(text_binary,2));

% Text extraction using different morphological operations
se_text_h = strel('rectangle', [1, 8]);   % Horizontal for text lines
se_text_v = strel('rectangle', [8, 1]);   % Vertical for removing vertical noise
se_small = strel('square', 2);            % Small square for noise removal

% Top-hat to extract text (bright objects smaller than SE)
tophat_text = imtophat(text_binary, se_text_h);

% Opening to remove small noise while preserving text
opened_text = imopen(text_binary, se_small);

% Closing to connect broken text characters
closed_text = imclose(opened_text, strel('rectangle', [2, 3]));

% Morphological gradient to highlight text boundaries
gradient_text = imdilate(text_binary, se_small) - imerode(text_binary, se_small);

% Combination: Opening + Closing for clean text
clean_text = imclose(imopen(text_binary, se_small), strel('rectangle', [2, 4]));

% Display text extraction results
figure('Name', 'Exercise 3: Real Text Extraction from Stop Sign', 'Position', [200, 200, 1200, 800]);
subplot(2,4,1); imshow(text_gray); title('Original Grayscale');
subplot(2,4,2); imshow(text_binary); title('Binary Text Image');
subplot(2,4,3); imshow(tophat_text); title('Top-hat Extraction');
subplot(2,4,4); imshow(opened_text); title('Opening (Noise Removal)');
subplot(2,4,5); imshow(closed_text); title('Closing (Connect Text)');
subplot(2,4,6); imshow(gradient_text); title('Morphological Gradient');
subplot(2,4,7); imshow(clean_text); title('Combined Clean Text');

% Show analysis
subplot(2,4,8);
axis off;
text(0.05, 0.95, 'Real Text Extraction Results:', 'FontSize', 11, 'FontWeight', 'bold');
text(0.05, 0.85, '• Top-hat: Extracts thin text features', 'FontSize', 9);
text(0.05, 0.75, '• Opening: Removes noise pixels', 'FontSize', 9);
text(0.05, 0.65, '• Closing: Connects broken characters', 'FontSize', 9);
text(0.05, 0.55, '• Gradient: Highlights text edges', 'FontSize', 9);
text(0.05, 0.45, '• Combined: Clean readable text', 'FontSize', 9);
text(0.05, 0.30, 'Best Result: Combined approach', 'FontSize', 9, 'Color', 'blue', 'FontWeight', 'bold');
text(0.05, 0.20, 'Application: OCR preprocessing', 'FontSize', 9, 'Color', 'red');
text(0.05, 0.10, 'Source: stop-sign.jpg', 'FontSize', 8, 'Color', 'black');

fprintf('Exercise 3 completed: Real text extraction from stop-sign.jpg image\n');