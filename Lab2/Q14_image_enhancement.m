% Q14: Image Enhancement Techniques
% This function implements various image enhancement methods including histogram equalization and contrast stretching

function Q14_image_enhancement(image_path)
    if nargin < 1
        image_path = 'images/test_images/dark_image.jpg';
    end
    
    fprintf('=== Q14: Image Enhancement Techniques ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        fprintf('Processing image: %s\n', image_path);
        fprintf('Original dimensions: %dx%dx%d\n', size(original_img));
        
        % Analyze original image characteristics
        analyze_image_characteristics(original_img);
        
        % Apply various enhancement techniques
        fprintf('\n=== APPLYING ENHANCEMENT TECHNIQUES ===\n');
        
        % 1. Histogram Equalization
        fprintf('1. Histogram Equalization...\n');
        enhanced_histeq = apply_histogram_equalization(original_img);
        
        % 2. Contrast Stretching
        fprintf('2. Contrast Stretching...\n');
        enhanced_contrast = apply_contrast_stretching(original_img);
        
        % 3. Adaptive Histogram Equalization (CLAHE)
        fprintf('3. Adaptive Histogram Equalization (CLAHE)...\n');
        enhanced_clahe = apply_clahe(original_img);
        
        % 4. Gamma Correction
        fprintf('4. Gamma Correction...\n');
        enhanced_gamma = apply_gamma_correction(original_img);
        
        % 5. Logarithmic Enhancement
        fprintf('5. Logarithmic Enhancement...\n');
        enhanced_log = apply_logarithmic_enhancement(original_img);
        
        % 6. Unsharp Masking (Sharpening)
        fprintf('6. Unsharp Masking...\n');
        enhanced_sharpen = apply_unsharp_masking(original_img);
        
        % 7. Multi-scale Enhancement
        fprintf('7. Multi-scale Enhancement...\n');
        enhanced_multiscale = apply_multiscale_enhancement(original_img);
        
        % 8. Retinex Enhancement
        fprintf('8. Retinex Enhancement...\n');
        enhanced_retinex = apply_retinex_enhancement(original_img);
        
        % Collect all enhanced images
        enhanced_images = {
            enhanced_histeq, enhanced_contrast, enhanced_clahe, enhanced_gamma,
            enhanced_log, enhanced_sharpen, enhanced_multiscale, enhanced_retinex
        };
        
        enhancement_names = {
            'Histogram Equalization', 'Contrast Stretching', 'CLAHE', 'Gamma Correction',
            'Logarithmic', 'Unsharp Masking', 'Multi-scale', 'Retinex'
        };
        
        % Display all results
        display_enhancement_results(original_img, enhanced_images, enhancement_names);
        
        % Quantitative quality assessment
        quality_metrics = assess_enhancement_quality(original_img, enhanced_images, enhancement_names);
        
        % Interactive comparison
        create_interactive_comparison(original_img, enhanced_images, enhancement_names);
        
        % Provide enhancement recommendations
        provide_enhancement_recommendations(quality_metrics);
        
        % Save enhanced images
        save_enhanced_images(image_path, enhanced_images, enhancement_names);
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Analyze original image characteristics
function analyze_image_characteristics(img)
    fprintf('\n=== ORIGINAL IMAGE ANALYSIS ===\n');
    
    % Convert to grayscale for analysis
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    
    % Basic statistics
    img_mean = mean(gray_img(:));
    img_std = std(double(gray_img(:)));
    img_min = min(gray_img(:));
    img_max = max(gray_img(:));
    dynamic_range = img_max - img_min;
    
    fprintf('Mean intensity: %.1f\n', img_mean);
    fprintf('Standard deviation: %.1f\n', img_std);
    fprintf('Intensity range: [%d, %d]\n', img_min, img_max);
    fprintf('Dynamic range: %d\n', dynamic_range);
    
    % Histogram analysis
    [counts, ~] = imhist(gray_img);
    total_pixels = sum(counts);
    
    % Find peaks in histogram
    [peaks, peak_locs] = findpeaks(smooth(counts, 5), 'MinPeakHeight', total_pixels * 0.01);
    fprintf('Histogram peaks at intensities: %s\n', mat2str(peak_locs-1));
    
    % Identify image characteristics
    fprintf('\nImage characteristics:\n');
    
    if img_mean < 85
        fprintf('• Low brightness (dark image)\n');
    elseif img_mean > 170
        fprintf('• High brightness (bright image)\n');
    else
        fprintf('• Normal brightness\n');
    end
    
    if img_std < 30
        fprintf('• Low contrast\n');
    elseif img_std > 70
        fprintf('• High contrast\n');
    else
        fprintf('• Normal contrast\n');
    end
    
    if dynamic_range < 128
        fprintf('• Limited dynamic range\n');
    else
        fprintf('• Good dynamic range\n');
    end
    
    % Histogram distribution
    low_count = sum(counts(1:86));  % 0-85
    mid_count = sum(counts(86:171)); % 85-170
    high_count = sum(counts(171:256)); % 170-255
    
    fprintf('Intensity distribution: %.1f%% low, %.1f%% mid, %.1f%% high\n', ...
            low_count/total_pixels*100, mid_count/total_pixels*100, high_count/total_pixels*100);
end

% Apply histogram equalization
function enhanced_img = apply_histogram_equalization(img)
    if size(img, 3) == 3
        % Apply to each channel separately
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            enhanced_img(:, :, c) = histeq(img(:, :, c));
        end
    else
        enhanced_img = histeq(img);
    end
    fprintf('   Histogram equalization completed\n');
end

% Apply contrast stretching
function enhanced_img = apply_contrast_stretching(img)
    if size(img, 3) == 3
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            channel = img(:, :, c);
            % Find 1st and 99th percentiles
            low_thresh = prctile(channel(:), 1);
            high_thresh = prctile(channel(:), 99);
            
            % Apply contrast stretching
            enhanced_img(:, :, c) = imadjust(channel, ...
                double([low_thresh high_thresh])/255, [0 1]);
        end
    else
        low_thresh = prctile(img(:), 1);
        high_thresh = prctile(img(:), 99);
        enhanced_img = imadjust(img, double([low_thresh high_thresh])/255, [0 1]);
    end
    fprintf('   Contrast stretching completed\n');
end

% Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
function enhanced_img = apply_clahe(img)
    if size(img, 3) == 3
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            enhanced_img(:, :, c) = adapthisteq(img(:, :, c), ...
                'ClipLimit', 0.02, 'Distribution', 'uniform');
        end
    else
        enhanced_img = adapthisteq(img, 'ClipLimit', 0.02, 'Distribution', 'uniform');
    end
    fprintf('   CLAHE completed\n');
end

% Apply gamma correction
function enhanced_img = apply_gamma_correction(img)
    % Automatically determine gamma based on image brightness
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    
    mean_intensity = mean(gray_img(:));
    
    if mean_intensity < 85
        gamma = 0.5;  % Brighten dark images
    elseif mean_intensity > 170
        gamma = 1.5;  % Darken bright images
    else
        gamma = 1.0;  % No change for normal images
    end
    
    % Apply gamma correction
    img_normalized = double(img) / 255;
    enhanced_normalized = img_normalized .^ gamma;
    enhanced_img = uint8(enhanced_normalized * 255);
    
    fprintf('   Gamma correction (γ=%.1f) completed\n', gamma);
end

% Apply logarithmic enhancement
function enhanced_img = apply_logarithmic_enhancement(img)
    img_double = double(img);
    
    % Logarithmic transformation: s = c * log(1 + r)
    c = 255 / log(1 + max(img_double(:)));
    enhanced_double = c * log(1 + img_double);
    enhanced_img = uint8(enhanced_double);
    
    fprintf('   Logarithmic enhancement completed\n');
end

% Apply unsharp masking for sharpening
function enhanced_img = apply_unsharp_masking(img)
    % Unsharp masking parameters
    sigma = 1.0;  % Gaussian blur standard deviation
    alpha = 1.5;  % Sharpening strength
    
    if size(img, 3) == 3
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            channel = double(img(:, :, c));
            
            % Create Gaussian blur
            blurred = imgaussfilt(channel, sigma);
            
            % Create unsharp mask
            mask = channel - blurred;
            
            % Apply sharpening
            sharpened = channel + alpha * mask;
            
            % Clamp values
            enhanced_img(:, :, c) = uint8(max(0, min(255, sharpened)));
        end
    else
        channel = double(img);
        blurred = imgaussfilt(channel, sigma);
        mask = channel - blurred;
        sharpened = channel + alpha * mask;
        enhanced_img = uint8(max(0, min(255, sharpened)));
    end
    
    fprintf('   Unsharp masking completed\n');
end

% Apply multi-scale enhancement
function enhanced_img = apply_multiscale_enhancement(img)
    if size(img, 3) == 3
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            enhanced_img(:, :, c) = multiscale_channel_enhancement(img(:, :, c));
        end
    else
        enhanced_img = multiscale_channel_enhancement(img);
    end
    
    fprintf('   Multi-scale enhancement completed\n');
end

% Multi-scale enhancement for single channel
function enhanced_channel = multiscale_channel_enhancement(channel)
    img_double = double(channel);
    
    % Create multiple scales using Gaussian pyramid
    scales = {img_double};
    for i = 1:3
        scales{i+1} = impyramid(scales{i}, 'reduce');
    end
    
    % Enhance each scale
    enhanced_scales = cell(size(scales));
    for i = 1:length(scales)
        % Apply adaptive histogram equalization at each scale
        enhanced_scales{i} = adapthisteq(uint8(scales{i}), 'ClipLimit', 0.01);
        enhanced_scales{i} = double(enhanced_scales{i});
    end
    
    % Reconstruct enhanced image
    enhanced_img = enhanced_scales{1};
    for i = 2:length(enhanced_scales)
        % Expand and add contribution from smaller scales
        expanded = enhanced_scales{i};
        for j = 1:(i-1)
            expanded = impyramid(expanded, 'expand');
            % Ensure same size as original
            if size(expanded, 1) > size(enhanced_img, 1)
                expanded = expanded(1:size(enhanced_img, 1), :);
            end
            if size(expanded, 2) > size(enhanced_img, 2)
                expanded = expanded(:, 1:size(enhanced_img, 2));
            end
        end
        
        if isequal(size(expanded), size(enhanced_img))
            enhanced_img = enhanced_img + 0.3 * (expanded - enhanced_img);
        end
    end
    
    enhanced_channel = uint8(max(0, min(255, enhanced_img)));
end

% Apply Retinex enhancement
function enhanced_img = apply_retinex_enhancement(img)
    if size(img, 3) == 3
        enhanced_img = zeros(size(img), class(img));
        for c = 1:3
            enhanced_img(:, :, c) = single_scale_retinex(img(:, :, c));
        end
    else
        enhanced_img = single_scale_retinex(img);
    end
    
    fprintf('   Retinex enhancement completed\n');
end

% Single Scale Retinex implementation
function enhanced_channel = single_scale_retinex(channel)
    img_double = double(channel) + 1;  % Add 1 to avoid log(0)
    
    % Gaussian surround function
    sigma = 15;
    surround = imgaussfilt(img_double, sigma);
    
    % Retinex: log(image) - log(surround)
    retinex = log(img_double) - log(surround);
    
    % Normalize to 0-255 range
    retinex_norm = (retinex - min(retinex(:))) / (max(retinex(:)) - min(retinex(:)));
    enhanced_channel = uint8(retinex_norm * 255);
end

% Display enhancement results
function display_enhancement_results(original, enhanced_list, names)
    fprintf('\n=== DISPLAYING ENHANCEMENT RESULTS ===\n');
    
    % Main comparison figure
    figure('Name', 'Q14: Image Enhancement Techniques', 'Position', [50, 50, 1600, 1200]);
    
    total_images = 1 + length(enhanced_list);
    cols = 3;
    rows = ceil(total_images / cols);
    
    % Display original
    subplot(rows, cols, 1);
    imshow(original);
    title('Original Image', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Display enhanced images
    for i = 1:length(enhanced_list)
        subplot(rows, cols, i + 1);
        imshow(enhanced_list{i});
        title(names{i}, 'FontSize', 10);
    end
    
    % Histogram comparison figure
    figure('Name', 'Q14: Histogram Comparison', 'Position', [100, 100, 1400, 1000]);
    
    % Convert to grayscale for histogram analysis
    if size(original, 3) == 3
        orig_gray = rgb2gray(original);
    else
        orig_gray = original;
    end
    
    enhanced_gray = cell(length(enhanced_list), 1);
    for i = 1:length(enhanced_list)
        if size(enhanced_list{i}, 3) == 3
            enhanced_gray{i} = rgb2gray(enhanced_list{i});
        else
            enhanced_gray{i} = enhanced_list{i};
        end
    end
    
    % Plot histograms
    subplot(rows, cols, 1);
    imhist(orig_gray);
    title('Original Histogram');
    
    for i = 1:length(enhanced_list)
        subplot(rows, cols, i + 1);
        imhist(enhanced_gray{i});
        title([names{i}, ' Histogram']);
    end
end

% Assess enhancement quality
function quality_metrics = assess_enhancement_quality(original, enhanced_list, names)
    fprintf('\n=== QUALITY ASSESSMENT ===\n');
    
    % Convert original to grayscale if needed
    if size(original, 3) == 3
        orig_gray = rgb2gray(original);
    else
        orig_gray = original;
    end
    
    % Initialize metrics
    quality_metrics = struct();
    
    fprintf('Method\t\t\tContrast\tSharpness\tEntropy\tBrightness\n');
    fprintf('----------------------------------------------------------------\n');
    
    % Original metrics
    orig_metrics = calculate_quality_metrics(orig_gray);
    fprintf('Original\t\t%.2f\t\t%.2f\t\t%.2f\t\t%.1f\n', ...
            orig_metrics.contrast, orig_metrics.sharpness, ...
            orig_metrics.entropy, orig_metrics.brightness);
    
    % Enhanced images metrics
    for i = 1:length(enhanced_list)
        if size(enhanced_list{i}, 3) == 3
            enh_gray = rgb2gray(enhanced_list{i});
        else
            enh_gray = enhanced_list{i};
        end
        
        metrics = calculate_quality_metrics(enh_gray);
        quality_metrics.(sprintf('method_%d', i)) = metrics;
        quality_metrics.(sprintf('method_%d', i)).name = names{i};
        
        fprintf('%-15s\t%.2f\t\t%.2f\t\t%.2f\t\t%.1f\n', ...
                names{i}(1:min(15, length(names{i}))), ...
                metrics.contrast, metrics.sharpness, ...
                metrics.entropy, metrics.brightness);
    end
    
    % Store original for comparison
    quality_metrics.original = orig_metrics;
    
    % Find best methods for each metric
    fprintf('\n=== BEST METHODS FOR EACH METRIC ===\n');
    
    contrasts = zeros(length(enhanced_list), 1);
    sharpnesses = zeros(length(enhanced_list), 1);
    entropies = zeros(length(enhanced_list), 1);
    
    for i = 1:length(enhanced_list)
        contrasts(i) = quality_metrics.(sprintf('method_%d', i)).contrast;
        sharpnesses(i) = quality_metrics.(sprintf('method_%d', i)).sharpness;
        entropies(i) = quality_metrics.(sprintf('method_%d', i)).entropy;
    end
    
    [~, best_contrast_idx] = max(contrasts);
    [~, best_sharpness_idx] = max(sharpnesses);
    [~, best_entropy_idx] = max(entropies);
    
    fprintf('Best contrast: %s (%.2f)\n', names{best_contrast_idx}, contrasts(best_contrast_idx));
    fprintf('Best sharpness: %s (%.2f)\n', names{best_sharpness_idx}, sharpnesses(best_sharpness_idx));
    fprintf('Best entropy: %s (%.2f)\n', names{best_entropy_idx}, entropies(best_entropy_idx));
end

% Calculate quality metrics for an image
function metrics = calculate_quality_metrics(img)
    img_double = double(img);
    
    % Contrast (standard deviation)
    metrics.contrast = std(img_double(:));
    
    % Sharpness (gradient magnitude)
    [gx, gy] = gradient(img_double);
    gradient_mag = sqrt(gx.^2 + gy.^2);
    metrics.sharpness = mean(gradient_mag(:));
    
    % Entropy (information content)
    [counts, ~] = imhist(uint8(img_double));
    prob = counts / sum(counts);
    prob = prob(prob > 0);
    metrics.entropy = -sum(prob .* log2(prob));
    
    % Brightness
    metrics.brightness = mean(img_double(:));
    
    % Dynamic range
    metrics.dynamic_range = max(img_double(:)) - min(img_double(:));
end

% Create interactive comparison
function create_interactive_comparison(original, enhanced_list, names)
    fprintf('\n=== CREATING INTERACTIVE COMPARISON ===\n');
    
    % Create a figure with detail crops for better comparison
    figure('Name', 'Q14: Detail Comparison', 'Position', [150, 150, 1400, 800]);
    
    % Define crop region (center portion)
    [h, w, ~] = size(original);
    crop_size = min(150, min(h, w) / 3);
    start_y = round((h - crop_size) / 2);
    start_x = round((w - crop_size) / 2);
    
    % Crop original
    orig_crop = original(start_y:(start_y + crop_size), start_x:(start_x + crop_size), :);
    
    total_images = 1 + length(enhanced_list);
    cols = 3;
    rows = ceil(total_images / cols);
    
    % Display original crop
    subplot(rows, cols, 1);
    imshow(imresize(orig_crop, 3, 'nearest'));  % 3x magnification
    title('Original (3x)', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Display enhanced crops
    for i = 1:length(enhanced_list)
        enh_crop = enhanced_list{i}(start_y:(start_y + crop_size), start_x:(start_x + crop_size), :);
        
        subplot(rows, cols, i + 1);
        imshow(imresize(enh_crop, 3, 'nearest'));
        title([names{i}, ' (3x)'], 'FontSize', 10);
    end
    
    % Create side-by-side comparison of top 3 methods
    figure('Name', 'Q14: Top 3 Methods Comparison', 'Position', [200, 200, 1200, 400]);
    
    % For demonstration, show first 3 enhanced images
    subplot(1, 4, 1);
    imshow(original);
    title('Original');
    
    for i = 1:min(3, length(enhanced_list))
        subplot(1, 4, i + 1);
        imshow(enhanced_list{i});
        title(names{i});
    end
end

% Provide enhancement recommendations
function provide_enhancement_recommendations(quality_metrics)
    fprintf('\n=== ENHANCEMENT RECOMMENDATIONS ===\n\n');
    
    fprintf('1. HISTOGRAM EQUALIZATION:\n');
    fprintf('   • Best for: Images with poor contrast across all intensities\n');
    fprintf('   • Pros: Simple, effective for uniform histogram\n');
    fprintf('   • Cons: Can over-enhance, creates artifacts\n');
    fprintf('   • Use when: Image has narrow intensity range\n\n');
    
    fprintf('2. CONTRAST STRETCHING:\n');
    fprintf('   • Best for: Images with limited dynamic range\n');
    fprintf('   • Pros: Preserves overall appearance, simple\n');
    fprintf('   • Cons: May not enhance local contrast\n');
    fprintf('   • Use when: Image uses only part of intensity range\n\n');
    
    fprintf('3. CLAHE (Adaptive Histogram Equalization):\n');
    fprintf('   • Best for: Images with varying local contrast\n');
    fprintf('   • Pros: Preserves local details, prevents over-enhancement\n');
    fprintf('   • Cons: More complex, may create blocking artifacts\n');
    fprintf('   • Use when: Image has both dark and bright regions\n\n');
    
    fprintf('4. GAMMA CORRECTION:\n');
    fprintf('   • Best for: Correcting overall brightness\n');
    fprintf('   • Pros: Perceptually uniform, simple parameter\n');
    fprintf('   • Cons: Affects entire image uniformly\n');
    fprintf('   • Use when: Image is too dark or too bright\n\n');
    
    fprintf('5. LOGARITHMIC ENHANCEMENT:\n');
    fprintf('   • Best for: Images with wide dynamic range\n');
    fprintf('   • Pros: Compresses high intensities, expands low\n');
    fprintf('   • Cons: May reduce contrast in bright areas\n');
    fprintf('   • Use when: Image has very bright and very dark areas\n\n');
    
    fprintf('6. UNSHARP MASKING:\n');
    fprintf('   • Best for: Improving image sharpness\n');
    fprintf('   • Pros: Enhances edges and details\n');
    fprintf('   • Cons: Can amplify noise\n');
    fprintf('   • Use when: Image appears soft or blurry\n\n');
    
    fprintf('7. MULTI-SCALE ENHANCEMENT:\n');
    fprintf('   • Best for: Complex images with multiple features\n');
    fprintf('   • Pros: Adapts to different spatial frequencies\n');
    fprintf('   • Cons: Computationally expensive\n');
    fprintf('   • Use when: Image has features at different scales\n\n');
    
    fprintf('8. RETINEX ENHANCEMENT:\n');
    fprintf('   • Best for: Images with uneven illumination\n');
    fprintf('   • Pros: Removes illumination effects, enhances details\n');
    fprintf('   • Cons: May create halos, color distortion\n');
    fprintf('   • Use when: Image has shadows or uneven lighting\n\n');
    
    fprintf('=== SELECTION GUIDELINES ===\n');
    fprintf('• Dark images: Gamma correction (γ < 1) or logarithmic\n');
    fprintf('• Low contrast: Histogram equalization or contrast stretching\n');
    fprintf('• Uneven lighting: CLAHE or Retinex\n');
    fprintf('• Blurry images: Unsharp masking\n');
    fprintf('• Mixed problems: Multi-scale enhancement\n');
    fprintf('• Medical images: CLAHE (preserves local information)\n');
    fprintf('• Natural photos: Gamma correction + mild unsharp masking\n');
    fprintf('• Document images: Contrast stretching + binarization\n');
end

% Save enhanced images
function save_enhanced_images(original_path, enhanced_list, names)
    [~, name, ~] = fileparts(original_path);
    
    fprintf('\n=== SAVING ENHANCED IMAGES ===\n');
    
    for i = 1:length(enhanced_list)
        % Create filename
        method_name = lower(strrep(names{i}, ' ', '_'));
        filename = sprintf('Lab2/images/enhanced_%s_%s.jpg', method_name, name);
        
        try
            imwrite(enhanced_list{i}, filename);
            fprintf('Saved: %s\n', filename);
        catch
            fprintf('Failed to save: %s\n', filename);
        end
    end
    
    % Save comparison figure
    comparison_filename = sprintf('Lab2/images/enhancement_comparison_%s.jpg', name);
    
    % Create a simple comparison image
    if length(enhanced_list) >= 3
        comparison = [enhanced_list{1}, enhanced_list{2}; enhanced_list{3}, enhanced_list{4}];
        try
            imwrite(comparison, comparison_filename);
            fprintf('Saved comparison: %s\n', comparison_filename);
        catch
            fprintf('Failed to save comparison image\n');
        end
    end
    
    fprintf('Enhanced images saved to Lab2/images/ directory\n');
end

% Demonstrate parameter sensitivity
function demonstrate_parameter_sensitivity(img)
    fprintf('\n=== PARAMETER SENSITIVITY ANALYSIS ===\n');
    
    % Test gamma correction with different gamma values
    gamma_values = [0.3, 0.5, 0.7, 1.0, 1.3, 1.7, 2.0, 2.5];
    
    figure('Name', 'Q14: Gamma Correction Sensitivity', 'Position', [250, 250, 1400, 400]);
    
    for i = 1:length(gamma_values)
        gamma = gamma_values(i);
        
        img_normalized = double(img) / 255;
        enhanced = img_normalized .^ gamma;
        enhanced_img = uint8(enhanced * 255);
        
        subplot(2, 4, i);
        imshow(enhanced_img);
        title(sprintf('γ = %.1f', gamma));
    end
    
    fprintf('Gamma sensitivity analysis completed\n');
    
    % Test CLAHE with different clip limits
    clip_limits = [0.005, 0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64];
    
    figure('Name', 'Q14: CLAHE Clip Limit Sensitivity', 'Position', [300, 300, 1400, 400]);
    
    for i = 1:length(clip_limits)
        clip_limit = clip_limits(i);
        
        if size(img, 3) == 3
            enhanced_img = zeros(size(img), class(img));
            for c = 1:3
                enhanced_img(:, :, c) = adapthisteq(img(:, :, c), ...
                    'ClipLimit', clip_limit, 'Distribution', 'uniform');
            end
        else
            enhanced_img = adapthisteq(img, 'ClipLimit', clip_limit, 'Distribution', 'uniform');
        end
        
        subplot(2, 4, i);
        imshow(enhanced_img);
        title(sprintf('Clip = %.3f', clip_limit));
    end
    
    fprintf('CLAHE sensitivity analysis completed\n');
end