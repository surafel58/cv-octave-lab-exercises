% Q11: Pixel Value Adjustments Using Mathematical Operations
% This function demonstrates various mathematical operations on pixel values

function Q11_pixel_operations(image_path)
    if nargin < 1
        image_path = 'images/test_images/portrait.png';
    end
    
    fprintf('=== Q11: Pixel Value Mathematical Operations ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        fprintf('Processing image: %s\n', image_path);
        fprintf('Original dimensions: %dx%dx%d\n', size(original_img));
        
        % Convert to double for mathematical operations
        img_double = double(original_img);
        
        % 1. SCALING OPERATIONS
        fprintf('\n=== 1. SCALING OPERATIONS ===\n');
        
        % Brightness scaling (multiplication)
        bright_scale = 1.5;  % 50% brighter
        dark_scale = 0.7;    % 30% darker
        
        img_bright = img_double * bright_scale;
        img_dark = img_double * dark_scale;
        
        % Contrast scaling (around midpoint)
        contrast_scale = 1.8;
        midpoint = 128;
        img_contrast = (img_double - midpoint) * contrast_scale + midpoint;
        
        fprintf('Brightness scaling: x%.1f (bright), x%.1f (dark)\n', bright_scale, dark_scale);
        fprintf('Contrast scaling: x%.1f around midpoint\n', contrast_scale);
        
        % 2. TRANSLATION OPERATIONS
        fprintf('\n=== 2. TRANSLATION OPERATIONS ===\n');
        
        % Brightness translation (addition/subtraction)
        bright_offset = 50;   % Add 50 to all pixels
        dark_offset = -40;    % Subtract 40 from all pixels
        
        img_bright_add = img_double + bright_offset;
        img_dark_sub = img_double + dark_offset;
        
        fprintf('Brightness translation: +%d (bright), %d (dark)\n', bright_offset, dark_offset);
        
        % 3. GAMMA CORRECTION
        fprintf('\n=== 3. GAMMA CORRECTION ===\n');
        
        gamma_high = 2.2;    % Darken midtones
        gamma_low = 0.5;     % Brighten midtones
        
        % Normalize to 0-1, apply gamma, scale back
        img_gamma_high = ((img_double / 255) .^ gamma_high) * 255;
        img_gamma_low = ((img_double / 255) .^ gamma_low) * 255;
        
        fprintf('Gamma correction: γ=%.1f (darken), γ=%.1f (brighten)\n', gamma_high, gamma_low);
        
        % 4. LOGARITHMIC TRANSFORMATION
        fprintf('\n=== 4. LOGARITHMIC TRANSFORMATION ===\n');
        
        % Log transformation: s = c * log(1 + r)
        c_log = 255 / log(1 + 255);  % Scaling constant
        img_log = c_log * log(1 + img_double);
        
        fprintf('Log transformation: s = %.1f * log(1 + r)\n', c_log);
        
        % 5. POWER LAW TRANSFORMATION
        fprintf('\n=== 5. POWER LAW TRANSFORMATION ===\n');
        
        % Power law: s = c * r^γ
        c_power = 1;
        gamma_power = 0.4;
        
        img_power = c_power * (img_double .^ gamma_power);
        
        fprintf('Power law: s = %.1f * r^%.1f\n', c_power, gamma_power);
        
        % 6. PIECEWISE LINEAR TRANSFORMATION
        fprintf('\n=== 6. PIECEWISE LINEAR TRANSFORMATION ===\n');
        
        % Create contrast stretching transformation
        img_piecewise = piecewise_linear_transform(img_double);
        
        fprintf('Piecewise linear: contrast stretching applied\n');
        
        % 7. HISTOGRAM OPERATIONS
        fprintf('\n=== 7. HISTOGRAM OPERATIONS ===\n');
        
        % Convert to uint8 for histogram operations
        img_uint8 = uint8(img_double);
        
        % Histogram equalization
        if size(img_uint8, 3) == 3
            img_histeq = zeros(size(img_uint8));
            for c = 1:3
                img_histeq(:, :, c) = histeq(img_uint8(:, :, c));
            end
        else
            img_histeq = histeq(img_uint8);
        end
        
        fprintf('Histogram equalization applied\n');
        
        % 8. BITWISE OPERATIONS
        fprintf('\n=== 8. BITWISE OPERATIONS ===\n');
        
        % Bit plane slicing
        img_bit_slice = bitwise_operations(img_uint8);
        
        fprintf('Bit plane operations applied\n');
        
        % 9. ARITHMETIC OPERATIONS BETWEEN IMAGES
        fprintf('\n=== 9. ARITHMETIC OPERATIONS BETWEEN IMAGES ===\n');
        
        % Create a pattern to blend with the image
        [h, w, c] = size(img_double);
        pattern = create_pattern(h, w, c);
        
        % Addition
        img_add = img_double + pattern * 50;
        
        % Subtraction
        img_sub = img_double - pattern * 30;
        
        % Multiplication (blending)
        img_mult = img_double .* (pattern * 0.3 + 0.7);
        
        % Division
        pattern_safe = pattern + 0.1;  % Avoid division by zero
        img_div = img_double ./ pattern_safe;
        
        fprintf('Arithmetic operations with pattern: +, -, *, /\n');
        
        % Clamp all results to valid range
        processed_images = {img_bright, img_dark, img_contrast, img_bright_add, img_dark_sub, ...
                          img_gamma_high, img_gamma_low, img_log, img_power, img_piecewise, ...
                          double(img_histeq), double(img_bit_slice), img_add, img_sub, img_mult, img_div};
        
        for i = 1:length(processed_images)
            processed_images{i} = clamp_image(processed_images{i});
        end
        
        % Display results
        display_pixel_operations(original_img, processed_images);
        
        % Analyze the effects
        analyze_pixel_operation_effects(original_img, processed_images);
        
        % Save processed images
        save_processed_images(image_path, processed_images);
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Piecewise linear transformation for contrast stretching
function img_out = piecewise_linear_transform(img_in)
    % Define piecewise linear function for contrast stretching
    % Input range: 0-255, output range: 0-255
    
    % Find 1st and 99th percentiles for contrast stretching
    img_vec = img_in(:);
    low_thresh = prctile(img_vec, 1);
    high_thresh = prctile(img_vec, 99);
    
    % Create piecewise linear mapping
    img_out = zeros(size(img_in));
    
    % Lower segment: 0 to low_thresh -> 0 to 30
    mask1 = img_in <= low_thresh;
    img_out(mask1) = img_in(mask1) * (30 / low_thresh);
    
    % Middle segment: low_thresh to high_thresh -> 30 to 225
    mask2 = (img_in > low_thresh) & (img_in <= high_thresh);
    img_out(mask2) = 30 + (img_in(mask2) - low_thresh) * ((225 - 30) / (high_thresh - low_thresh));
    
    % Upper segment: high_thresh to 255 -> 225 to 255
    mask3 = img_in > high_thresh;
    img_out(mask3) = 225 + (img_in(mask3) - high_thresh) * ((255 - 225) / (255 - high_thresh));
end

% Bitwise operations for bit plane slicing
function img_out = bitwise_operations(img_in)
    % Extract most significant bit plane (bit 7)
    bit_plane = bitget(img_in, 8);  % 8th bit (most significant)
    
    % Convert back to image intensity
    img_out = bit_plane * 255;
    
    % If color image, apply to all channels
    if size(img_in, 3) == 3
        for c = 1:3
            bit_plane_c = bitget(img_in(:, :, c), 8);
            img_out(:, :, c) = bit_plane_c * 255;
        end
    end
end

% Create a pattern for arithmetic operations
function pattern = create_pattern(height, width, channels)
    [X, Y] = meshgrid(1:width, 1:height);
    
    % Create sinusoidal pattern
    pattern_2d = 0.5 + 0.3 * sin(X/20) .* cos(Y/15);
    
    % Extend to all channels
    if channels == 3
        pattern = repmat(pattern_2d, [1, 1, 3]);
    else
        pattern = pattern_2d;
    end
end

% Clamp image values to valid range [0, 255]
function img_clamped = clamp_image(img)
    img_clamped = max(0, min(255, img));
    img_clamped = uint8(img_clamped);
end

% Display all pixel operations
function display_pixel_operations(original, processed_list)
    figure('Name', 'Q11: Pixel Mathematical Operations', 'Position', [50, 50, 1600, 1200]);
    
    operation_names = {
        'Original', 'Bright Scale', 'Dark Scale', 'Contrast Scale',
        'Bright Add', 'Dark Sub', 'Gamma High', 'Gamma Low',
        'Log Transform', 'Power Law', 'Piecewise', 'Hist Equalize',
        'Bit Slice', 'Pattern Add', 'Pattern Sub', 'Pattern Mult', 'Pattern Div'
    };
    
    % Calculate subplot arrangement
    total_images = 1 + length(processed_list);
    cols = ceil(sqrt(total_images));
    rows = ceil(total_images / cols);
    
    % Display original
    subplot(rows, cols, 1);
    imshow(original);
    title(operation_names{1}, 'FontSize', 10);
    
    % Display processed images
    for i = 1:length(processed_list)
        subplot(rows, cols, i + 1);
        imshow(processed_list{i});
        title(operation_names{min(i + 1, length(operation_names))}, 'FontSize', 10);
    end
end

% Analyze effects of pixel operations
function analyze_pixel_operation_effects(original, processed_list)
    fprintf('\n=== PIXEL OPERATION EFFECTS ANALYSIS ===\n');
    
    % Convert original to double for analysis
    orig_double = double(original);
    
    operation_names = {
        'Bright Scale', 'Dark Scale', 'Contrast Scale', 'Bright Add', 'Dark Sub',
        'Gamma High', 'Gamma Low', 'Log Transform', 'Power Law', 'Piecewise',
        'Hist Equalize', 'Bit Slice', 'Pattern Add', 'Pattern Sub', 'Pattern Mult', 'Pattern Div'
    };
    
    fprintf('Operation\t\tMean\tStd\tMin\tMax\tRange\n');
    fprintf('--------------------------------------------------------\n');
    
    % Original statistics
    orig_stats = calculate_image_stats(orig_double);
    fprintf('Original\t\t%.1f\t%.1f\t%d\t%d\t%d\n', ...
            orig_stats.mean, orig_stats.std, orig_stats.min, orig_stats.max, orig_stats.range);
    
    % Process each operation
    for i = 1:min(length(processed_list), length(operation_names))
        proc_stats = calculate_image_stats(double(processed_list{i}));
        fprintf('%-15s\t%.1f\t%.1f\t%d\t%d\t%d\n', ...
                operation_names{i}, proc_stats.mean, proc_stats.std, ...
                proc_stats.min, proc_stats.max, proc_stats.range);
    end
    
    % Visual effect descriptions
    fprintf('\n=== VISUAL EFFECTS DESCRIPTION ===\n');
    
    effects = {
        'Bright Scale: Multiplicative brightening - increases all values proportionally',
        'Dark Scale: Multiplicative darkening - decreases all values proportionally',
        'Contrast Scale: Stretches values around midpoint - enhances contrast',
        'Bright Add: Additive brightening - shifts all values up uniformly',
        'Dark Sub: Additive darkening - shifts all values down uniformly',
        'Gamma High: Non-linear darkening - compresses bright regions',
        'Gamma Low: Non-linear brightening - expands dark regions',
        'Log Transform: Expands dark regions, compresses bright regions',
        'Power Law: Controlled contrast adjustment with power function',
        'Piecewise: Custom contrast stretching with multiple segments',
        'Hist Equalize: Redistributes intensities for uniform histogram',
        'Bit Slice: Shows only most significant bit information',
        'Pattern Add: Adds geometric pattern to image',
        'Pattern Sub: Subtracts geometric pattern from image',
        'Pattern Mult: Multiplies image by pattern (local dimming)',
        'Pattern Div: Divides image by pattern (local brightening)'
    };
    
    for i = 1:length(effects)
        fprintf('%s\n', effects{i});
    end
    
    % Practical applications
    fprintf('\n=== PRACTICAL APPLICATIONS ===\n');
    fprintf('1. Brightness Adjustment: Scaling and translation for exposure correction\n');
    fprintf('2. Contrast Enhancement: Gamma and contrast scaling for visibility\n');
    fprintf('3. Dynamic Range Compression: Log transform for high dynamic range\n');
    fprintf('4. Histogram Equalization: Automatic contrast enhancement\n');
    fprintf('5. Bit Operations: Digital watermarking and steganography\n');
    fprintf('6. Pattern Operations: Texture synthesis and blending\n');
end

% Calculate image statistics
function stats = calculate_image_stats(img)
    img_vec = img(:);
    
    stats.mean = mean(img_vec);
    stats.std = std(img_vec);
    stats.min = min(img_vec);
    stats.max = max(img_vec);
    stats.range = stats.max - stats.min;
end

% Save processed images
function save_processed_images(original_path, processed_list)
    [~, name, ~] = fileparts(original_path);
    
    operation_suffixes = {
        'bright_scale', 'dark_scale', 'contrast_scale', 'bright_add', 'dark_sub',
        'gamma_high', 'gamma_low', 'log_transform', 'power_law', 'piecewise',
        'hist_equalize', 'bit_slice', 'pattern_add', 'pattern_sub', 'pattern_mult', 'pattern_div'
    };
    
    fprintf('\n=== SAVING PROCESSED IMAGES ===\n');
    
    for i = 1:min(length(processed_list), length(operation_suffixes))
        filename = sprintf('Lab2/images/pixel_ops_%s_%s.jpg', operation_suffixes{i}, name);
        try
            imwrite(processed_list{i}, filename);
            fprintf('Saved: %s\n', filename);
        catch
            fprintf('Failed to save: %s\n', filename);
        end
    end
end

% Demonstrate advanced pixel operations
function demonstrate_advanced_operations(image_path)
    if nargin < 1
        image_path = 'images/test_images/portrait.png';
    end
    
    fprintf('\n=== ADVANCED PIXEL OPERATIONS DEMO ===\n');
    
    try
        img = imread(image_path);
        img_double = double(img);
        
        % 1. Threshold operations
        threshold_binary = img_double > 128;
        threshold_binary = double(threshold_binary) * 255;
        
        % 2. Window/Level operations (medical imaging)
        window_width = 100;
        window_center = 128;
        img_windowed = window_level_operation(img_double, window_center, window_width);
        
        % 3. Sigmoid transformation
        img_sigmoid = sigmoid_transform(img_double, 128, 0.1);
        
        % 4. Adaptive operations based on local statistics
        img_adaptive = adaptive_enhancement(img_double);
        
        % Display advanced operations
        figure('Name', 'Q11: Advanced Pixel Operations', 'Position', [100, 100, 1200, 600]);
        
        subplot(2, 3, 1);
        imshow(uint8(img_double));
        title('Original');
        
        subplot(2, 3, 2);
        imshow(uint8(threshold_binary));
        title('Binary Threshold');
        
        subplot(2, 3, 3);
        imshow(uint8(img_windowed));
        title('Window/Level');
        
        subplot(2, 3, 4);
        imshow(uint8(img_sigmoid));
        title('Sigmoid Transform');
        
        subplot(2, 3, 5);
        imshow(uint8(img_adaptive));
        title('Adaptive Enhancement');
        
        subplot(2, 3, 6);
        % Show histogram comparison
        hist_original = imhist(uint8(img_double(:, :, 1)));
        hist_adaptive = imhist(uint8(img_adaptive(:, :, 1)));
        plot(hist_original, 'b-', 'LineWidth', 2);
        hold on;
        plot(hist_adaptive, 'r-', 'LineWidth', 2);
        title('Histogram Comparison');
        legend('Original', 'Adaptive', 'Location', 'best');
        hold off;
        
    catch ME
        fprintf('Error in advanced operations: %s\n', ME.message);
    end
end

% Window/Level operation (common in medical imaging)
function img_out = window_level_operation(img_in, center, width)
    lower = center - width/2;
    upper = center + width/2;
    
    % Linear mapping from [lower, upper] to [0, 255]
    img_out = (img_in - lower) * (255 / width);
    img_out = max(0, min(255, img_out));
end

% Sigmoid transformation
function img_out = sigmoid_transform(img_in, center, gain)
    % Sigmoid: 1 / (1 + exp(-gain * (x - center)))
    img_normalized = img_in / 255;
    center_norm = center / 255;
    
    img_sigmoid = 1 ./ (1 + exp(-gain * (img_normalized - center_norm)));
    img_out = img_sigmoid * 255;
end

% Adaptive enhancement based on local statistics
function img_out = adaptive_enhancement(img_in)
    % Use local mean and standard deviation for enhancement
    
    if size(img_in, 3) == 3
        img_gray = rgb2gray(uint8(img_in));
    else
        img_gray = img_in;
    end
    
    % Calculate local statistics using sliding window
    window_size = 15;
    local_mean = filter2(ones(window_size)/window_size^2, img_gray, 'same');
    local_var = filter2(ones(window_size)/window_size^2, img_gray.^2, 'same') - local_mean.^2;
    local_std = sqrt(max(local_var, 0));
    
    % Adaptive enhancement formula
    global_mean = mean(img_gray(:));
    global_std = std(double(img_gray(:)));
    
    enhancement_factor = global_std ./ (local_std + 1);
    img_enhanced = local_mean + enhancement_factor .* (img_gray - local_mean);
    
    % Apply to all channels if color image
    if size(img_in, 3) == 3
        img_out = img_in;
        for c = 1:3
            img_out(:, :, c) = local_mean + enhancement_factor .* (img_in(:, :, c) - local_mean);
        end
    else
        img_out = img_enhanced;
    end
    
    img_out = max(0, min(255, img_out));
end