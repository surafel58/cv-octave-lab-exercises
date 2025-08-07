% Q9: Different Color Spaces Loading and Display
% This function loads and displays images in different color spaces

function Q9_color_spaces(image_path)
    if nargin < 1
        image_path = 'images/test_images/colorful.jpg';
    end
    
    fprintf('=== Q9: Color Spaces Analysis and Display ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        
        if size(original_img, 3) ~= 3
            error('Input image must be a color (RGB) image');
        end
        
        fprintf('Processing image: %s\n', image_path);
        fprintf('Original dimensions: %dx%dx%d\n', size(original_img));
        
        % Color space conversions
        fprintf('\n=== Converting to Different Color Spaces ===\n');
        
        % 1. RGB (original)
        rgb_img = original_img;
        fprintf('✓ RGB: Original color space\n');
        
        % 2. HSV (Hue, Saturation, Value)
        hsv_img = rgb2hsv(original_img);
        fprintf('✓ HSV: Hue-Saturation-Value conversion\n');
        
        % 3. YUV/YCbCr (Luminance and Chrominance)
        try
            ycbcr_img = rgb2ycbcr(original_img);
            fprintf('✓ YCbCr: Luminance-Chrominance conversion\n');
            has_ycbcr = true;
        catch
            % Fallback manual YUV conversion
            ycbcr_img = rgb_to_yuv_manual(original_img);
            fprintf('✓ YUV: Manual luminance-chrominance conversion\n');
            has_ycbcr = false;
        end
        
        % 4. LAB color space (if available)
        try
            lab_img = rgb2lab(original_img);
            fprintf('✓ LAB: Perceptually uniform color space\n');
            has_lab = true;
        catch
            % Fallback: create synthetic LAB representation
            lab_img = rgb_to_lab_approximation(original_img);
            fprintf('✓ LAB: Approximated perceptually uniform space\n');
            has_lab = false;
        end
        
        % 5. Grayscale (single channel)
        gray_img = rgb2gray(original_img);
        fprintf('✓ Grayscale: Single channel luminance\n');
        
        % 6. Individual RGB channels
        r_channel = original_img(:, :, 1);
        g_channel = original_img(:, :, 2);
        b_channel = original_img(:, :, 3);
        fprintf('✓ RGB Channels: Individual color components\n');
        
        % Display all color spaces
        display_color_spaces(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img, ...
                           r_channel, g_channel, b_channel);
        
        % Analyze color space characteristics
        analyze_color_space_properties(rgb_img, hsv_img, ycbcr_img, lab_img);
        
        % Demonstrate color space effects on processing
        demonstrate_processing_effects(original_img, hsv_img, ycbcr_img);
        
        % Save converted images
        save_color_space_images(image_path, rgb_img, hsv_img, ycbcr_img, lab_img, gray_img);
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Display all color spaces in a comprehensive figure
function display_color_spaces(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img, r_ch, g_ch, b_ch)
    figure('Name', 'Q9: Color Spaces Comparison', 'Position', [50, 50, 1600, 1000]);
    
    % RGB original and channels
    subplot(3, 4, 1);
    imshow(rgb_img);
    title('RGB Original');
    
    subplot(3, 4, 2);
    imshow(r_ch, []);
    colormap(gca, 'gray');
    title('Red Channel');
    
    subplot(3, 4, 3);
    imshow(g_ch, []);
    colormap(gca, 'gray');
    title('Green Channel');
    
    subplot(3, 4, 4);
    imshow(b_ch, []);
    colormap(gca, 'gray');
    title('Blue Channel');
    
    % HSV components
    subplot(3, 4, 5);
    imshow(hsv_img);
    title('HSV Composite');
    
    subplot(3, 4, 6);
    imshow(hsv_img(:, :, 1), []);
    colormap(gca, 'hsv');
    title('Hue Component');
    
    subplot(3, 4, 7);
    imshow(hsv_img(:, :, 2), []);
    colormap(gca, 'gray');
    title('Saturation Component');
    
    subplot(3, 4, 8);
    imshow(hsv_img(:, :, 3), []);
    colormap(gca, 'gray');
    title('Value Component');
    
    % YCbCr/YUV components
    subplot(3, 4, 9);
    if size(ycbcr_img, 3) == 3
        % Display as composite if 3-channel
        try
            imshow(ycbcr_img);
        catch
            imshow(ycbcr_img / 255);
        end
    else
        imshow(ycbcr_img, []);
    end
    title('YCbCr/YUV Composite');
    
    subplot(3, 4, 10);
    imshow(ycbcr_img(:, :, 1), []);
    colormap(gca, 'gray');
    title('Y (Luminance)');
    
    % LAB and grayscale
    subplot(3, 4, 11);
    if size(lab_img, 3) == 3
        try
            imshow(lab_img);
        catch
            % LAB values might be in different range
            lab_normalized = lab_img;
            lab_normalized(:, :, 1) = mat2gray(lab_img(:, :, 1));
            lab_normalized(:, :, 2) = mat2gray(lab_img(:, :, 2));
            lab_normalized(:, :, 3) = mat2gray(lab_img(:, :, 3));
            imshow(lab_normalized);
        end
    else
        imshow(lab_img, []);
    end
    title('LAB Color Space');
    
    subplot(3, 4, 12);
    imshow(gray_img);
    title('Grayscale');
end

% Analyze color space properties
function analyze_color_space_properties(rgb_img, hsv_img, ycbcr_img, lab_img)
    fprintf('\n=== Color Space Properties Analysis ===\n');
    
    % Convert to double for analysis
    rgb_double = double(rgb_img) / 255;
    hsv_double = double(hsv_img);
    
    % RGB analysis
    rgb_mean = squeeze(mean(mean(rgb_double, 1), 2));
    rgb_std = squeeze(std(reshape(rgb_double, [], 3), 0, 1));
    
    fprintf('RGB Statistics:\n');
    fprintf('  Mean values: R=%.3f, G=%.3f, B=%.3f\n', rgb_mean);
    fprintf('  Std deviation: R=%.3f, G=%.3f, B=%.3f\n', rgb_std);
    
    % HSV analysis
    h_values = hsv_double(:, :, 1);
    s_values = hsv_double(:, :, 2);
    v_values = hsv_double(:, :, 3);
    
    % Remove NaN values for hue (can occur when saturation is 0)
    h_valid = h_values(~isnan(h_values));
    
    fprintf('\nHSV Statistics:\n');
    fprintf('  Hue range: %.3f to %.3f (mean: %.3f)\n', ...
            min(h_valid(:)), max(h_valid(:)), mean(h_valid(:)));
    fprintf('  Saturation range: %.3f to %.3f (mean: %.3f)\n', ...
            min(s_values(:)), max(s_values(:)), mean(s_values(:)));
    fprintf('  Value range: %.3f to %.3f (mean: %.3f)\n', ...
            min(v_values(:)), max(v_values(:)), mean(v_values(:)));
    
    % Color dominance analysis
    [dominant_hue, hue_distribution] = analyze_hue_distribution(h_valid);
    fprintf('\nColor Dominance:\n');
    fprintf('  Dominant hue: %.1f° (%s)\n', dominant_hue * 360, hue_to_color_name(dominant_hue));
    
    % Saturation analysis
    low_sat = sum(s_values(:) < 0.3) / numel(s_values) * 100;
    high_sat = sum(s_values(:) > 0.7) / numel(s_values) * 100;
    fprintf('  Low saturation pixels: %.1f%%\n', low_sat);
    fprintf('  High saturation pixels: %.1f%%\n', high_sat);
    
    % Brightness analysis
    dark_pixels = sum(v_values(:) < 0.3) / numel(v_values) * 100;
    bright_pixels = sum(v_values(:) > 0.7) / numel(v_values) * 100;
    fprintf('  Dark pixels: %.1f%%\n', dark_pixels);
    fprintf('  Bright pixels: %.1f%%\n', bright_pixels);
end

% Demonstrate processing effects in different color spaces
function demonstrate_processing_effects(rgb_img, hsv_img, ycbcr_img)
    fprintf('\n=== Processing Effects in Different Color Spaces ===\n');
    
    % Example 1: Histogram equalization
    fprintf('1. Histogram Equalization:\n');
    
    % RGB histogram equalization (on each channel)
    rgb_eq = rgb_img;
    for c = 1:3
        rgb_eq(:, :, c) = histeq(rgb_img(:, :, c));
    end
    
    % HSV histogram equalization (on Value channel only)
    hsv_eq = hsv_img;
    hsv_eq(:, :, 3) = histeq(uint8(hsv_img(:, :, 3) * 255)) / 255;
    rgb_from_hsv_eq = hsv2rgb(hsv_eq);
    
    % YCbCr histogram equalization (on Y channel only)
    ycbcr_eq = ycbcr_img;
    if size(ycbcr_img, 3) == 3
        ycbcr_eq(:, :, 1) = histeq(ycbcr_img(:, :, 1));
        try
            rgb_from_ycbcr_eq = ycbcr2rgb(ycbcr_eq);
        catch
            rgb_from_ycbcr_eq = yuv_to_rgb_manual(ycbcr_eq);
        end
    else
        rgb_from_ycbcr_eq = rgb_img;  % Fallback
    end
    
    % Display histogram equalization results
    figure('Name', 'Q9: Histogram Equalization in Different Color Spaces', ...
           'Position', [100, 100, 1200, 400]);
    
    subplot(1, 4, 1);
    imshow(rgb_img);
    title('Original RGB');
    
    subplot(1, 4, 2);
    imshow(rgb_eq);
    title('RGB Channels Equalized');
    
    subplot(1, 4, 3);
    imshow(rgb_from_hsv_eq);
    title('HSV Value Equalized');
    
    subplot(1, 4, 4);
    imshow(rgb_from_ycbcr_eq);
    title('YCbCr Luminance Equalized');
    
    fprintf('   - RGB channel equalization: Can cause color shifts\n');
    fprintf('   - HSV value equalization: Preserves hue and saturation\n');
    fprintf('   - YCbCr luminance equalization: Preserves chrominance\n');
    
    % Example 2: Color enhancement
    fprintf('\n2. Color Enhancement Effects:\n');
    fprintf('   - HSV: Easy saturation/brightness adjustment\n');
    fprintf('   - LAB: Perceptually uniform adjustments\n');
    fprintf('   - RGB: Direct but can cause unrealistic colors\n');
    
    % Example 3: Noise sensitivity
    fprintf('\n3. Noise Sensitivity:\n');
    fprintf('   - RGB: Noise affects all color information\n');
    fprintf('   - YCbCr: Noise in chrominance less visible than luminance\n');
    fprintf('   - HSV: Noise in hue very noticeable\n');
end

% Save converted images
function save_color_space_images(original_path, rgb_img, hsv_img, ycbcr_img, lab_img, gray_img)
    [~, name, ~] = fileparts(original_path);
    
    % Save individual components
    imwrite(gray_img, sprintf('Lab2/images/colorspace_gray_%s.jpg', name));
    
    % Save HSV components as separate images
    imwrite(hsv_img(:, :, 1), sprintf('Lab2/images/colorspace_hue_%s.jpg', name));
    imwrite(hsv_img(:, :, 2), sprintf('Lab2/images/colorspace_saturation_%s.jpg', name));
    imwrite(hsv_img(:, :, 3), sprintf('Lab2/images/colorspace_value_%s.jpg', name));
    
    % Save Y component from YCbCr
    if size(ycbcr_img, 3) >= 1
        imwrite(ycbcr_img(:, :, 1), sprintf('Lab2/images/colorspace_luminance_%s.jpg', name));
    end
    
    fprintf('\nColor space images saved to Lab2/images/ directory\n');
end

% Manual RGB to YUV conversion
function yuv_img = rgb_to_yuv_manual(rgb_img)
    % Convert RGB to YUV using standard coefficients
    rgb_double = double(rgb_img) / 255;
    
    % YUV transformation matrix
    T = [0.299,  0.587,  0.114;
        -0.169, -0.331,  0.500;
         0.500, -0.419, -0.081];
    
    [h, w, ~] = size(rgb_double);
    yuv_img = zeros(h, w, 3);
    
    for i = 1:h
        for j = 1:w
            rgb_pixel = squeeze(rgb_double(i, j, :))';
            yuv_pixel = T * rgb_pixel';
            yuv_img(i, j, :) = yuv_pixel;
        end
    end
    
    % Normalize YUV values
    yuv_img(:, :, 1) = mat2gray(yuv_img(:, :, 1));  % Y: 0-1
    yuv_img(:, :, 2) = mat2gray(yuv_img(:, :, 2));  % U: normalized
    yuv_img(:, :, 3) = mat2gray(yuv_img(:, :, 3));  % V: normalized
    
    yuv_img = uint8(yuv_img * 255);
end

% Manual YUV to RGB conversion
function rgb_img = yuv_to_rgb_manual(yuv_img)
    % Convert YUV back to RGB
    yuv_double = double(yuv_img) / 255;
    
    % Inverse YUV transformation matrix
    T_inv = [1.000,  0.000,  1.402;
             1.000, -0.344, -0.714;
             1.000,  1.772,  0.000];
    
    [h, w, ~] = size(yuv_double);
    rgb_img = zeros(h, w, 3);
    
    for i = 1:h
        for j = 1:w
            yuv_pixel = squeeze(yuv_double(i, j, :))';
            rgb_pixel = T_inv * yuv_pixel';
            rgb_img(i, j, :) = rgb_pixel;
        end
    end
    
    % Clamp values
    rgb_img = max(0, min(1, rgb_img));
    rgb_img = uint8(rgb_img * 255);
end

% Approximated LAB conversion
function lab_img = rgb_to_lab_approximation(rgb_img)
    % Simplified LAB approximation for demonstration
    rgb_double = double(rgb_img) / 255;
    
    % L channel (lightness) - similar to grayscale
    L = 0.299 * rgb_double(:, :, 1) + 0.587 * rgb_double(:, :, 2) + 0.114 * rgb_double(:, :, 3);
    
    % A channel (green-red) - simplified
    A = (rgb_double(:, :, 1) - rgb_double(:, :, 2)) / 2 + 0.5;
    
    % B channel (blue-yellow) - simplified
    B = (rgb_double(:, :, 2) - rgb_double(:, :, 3)) / 2 + 0.5;
    
    lab_img = cat(3, L, A, B);
end

% Analyze hue distribution
function [dominant_hue, distribution] = analyze_hue_distribution(hue_values)
    % Create histogram of hue values
    edges = 0:1/12:1;  % 12 bins for 12 color regions
    [counts, ~] = histcounts(hue_values, edges);
    
    % Find dominant hue
    [~, max_idx] = max(counts);
    dominant_hue = edges(max_idx) + (edges(2) - edges(1)) / 2;
    
    distribution = counts / sum(counts);
end

% Convert hue value to color name
function color_name = hue_to_color_name(hue_value)
    % Convert hue (0-1) to approximate color name
    hue_degrees = hue_value * 360;
    
    if hue_degrees < 15 || hue_degrees >= 345
        color_name = 'Red';
    elseif hue_degrees < 45
        color_name = 'Orange';
    elseif hue_degrees < 75
        color_name = 'Yellow';
    elseif hue_degrees < 105
        color_name = 'Yellow-Green';
    elseif hue_degrees < 135
        color_name = 'Green';
    elseif hue_degrees < 165
        color_name = 'Cyan-Green';
    elseif hue_degrees < 195
        color_name = 'Cyan';
    elseif hue_degrees < 225
        color_name = 'Blue';
    elseif hue_degrees < 255
        color_name = 'Blue-Violet';
    elseif hue_degrees < 285
        color_name = 'Violet';
    elseif hue_degrees < 315
        color_name = 'Magenta';
    else
        color_name = 'Red-Magenta';
    end
end