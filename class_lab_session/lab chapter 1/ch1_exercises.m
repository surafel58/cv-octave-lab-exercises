% Chapter 1 Exercises: Suggested Exercises

% Load image first
img = imread('../images/cameraman.tif');

fprintf('=== EXERCISE 1: Downsampling Comparison ===\n');

% Exercise 1: Apply different downsampling factors (e.g., 3, 5) and compare results
sampled_img_3 = img(1:3:end, 1:3:end);
sampled_img_5 = img(1:5:end, 1:5:end);

% Display Exercise 1 results grouped together
figure('Name', 'Exercise 1: Downsampling Comparison', 'Position', [100, 100, 900, 400]);
subplot(1,3,1); imshow(img); title('Original Image');
subplot(1,3,2); imshow(sampled_img_3); title('Sampled - Factor 3');
subplot(1,3,3); imshow(sampled_img_5); title('Sampled - Factor 5');

fprintf('Exercise 1 completed: Downsampling with factors 3 and 5\n');

fprintf('\n=== EXERCISE 2: Quantization Comparison ===\n');

% Exercise 2: Experiment with quantizing to 8, 16, and 32 gray levels
quant_img_8 = uint8(floor(double(img)/32) * 32);
quant_img_16 = uint8(floor(double(img)/16) * 16);
quant_img_32 = uint8(floor(double(img)/8) * 8);

% Display Exercise 2 results grouped together
figure('Name', 'Exercise 2: Quantization Comparison', 'Position', [150, 150, 1000, 500]);
subplot(2,2,1); imshow(img); title('Original Image (256 levels)');
subplot(2,2,2); imshow(quant_img_8); title('Quantized - 8 Gray Levels');
subplot(2,2,3); imshow(quant_img_16); title('Quantized - 16 Gray Levels');
subplot(2,2,4); imshow(quant_img_32); title('Quantized - 32 Gray Levels');

fprintf('Exercise 2 completed: Quantization to 8, 16, and 32 gray levels\n');

fprintf('\n=== EXERCISE 3: Interactive UI ===\n');
% Exercise 3: Interactive UI (run separately)
% Run: ch1_interactive_ui
fprintf('Run ch1_interactive_ui for interactive exploration\n');