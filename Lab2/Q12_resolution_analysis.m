% Q12: Resolution Comparison and Analysis
% This function compares images of different resolutions and analyzes processing effects

function Q12_resolution_analysis(high_res_path, low_res_path)
    if nargin < 2
        high_res_path = 'images/test_images/high_resolution.jpg';
        low_res_path = 'images/test_images/low_res.jpg';
    end
    
    fprintf('=== Q12: Resolution Comparison and Analysis ===\n\n');
    
    try
        % Load images
        high_res_img = imread(high_res_path);
        
        % If low res image doesn't exist, create it from high res
        if ~exist(low_res_path, 'file')
            fprintf('Low resolution image not found. Creating from high resolution image...\n');
            low_res_img = create_low_resolution_version(high_res_img);
            [path, name, ~] = fileparts(high_res_path);
            low_res_path = fullfile(path, [name, '_low_res.jpg']);
            imwrite(low_res_img, low_res_path);
            fprintf('Created: %s\n', low_res_path);
        else
            low_res_img = imread(low_res_path);
        end
        
        % Get image dimensions
        [h_high, w_high, c_high] = size(high_res_img);
        [h_low, w_low, c_low] = size(low_res_img);
        
        fprintf('High resolution image: %dx%d, channels: %d\n', w_high, h_high, c_high);
        fprintf('Low resolution image: %dx%d, channels: %d\n', w_low, h_low, c_low);
        
        % Calculate resolution metrics
        analyze_resolution_metrics(high_res_img, low_res_img);
        
        % Create intermediate resolutions for comprehensive analysis
        intermediate_resolutions = create_resolution_pyramid(high_res_img);
        
        % Display resolution comparison
        display_resolution_comparison(high_res_img, low_res_img, intermediate_resolutions);
        
        % Test image processing operations at different resolutions
        test_processing_at_resolutions(high_res_img, low_res_img, intermediate_resolutions);
        
        % Analyze processing speed vs quality trade-offs
        analyze_speed_quality_tradeoffs(high_res_img, intermediate_resolutions);
        
        % Memory usage analysis
        analyze_memory_usage(high_res_img, intermediate_resolutions);
        
        % Practical recommendations
        provide_resolution_recommendations();
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Create low resolution version from high resolution image
function low_res_img = create_low_resolution_version(high_res_img)
    [h, w, ~] = size(high_res_img);
    
    % Reduce to approximately 25% of original size
    scale_factor = 0.25;
    new_h = round(h * scale_factor);
    new_w = round(w * scale_factor);
    
    low_res_img = imresize(high_res_img, [new_h, new_w], 'bicubic');
end

% Analyze resolution metrics
function analyze_resolution_metrics(high_res_img, low_res_img)
    fprintf('\n=== RESOLUTION METRICS ANALYSIS ===\n');
    
    % Basic metrics
    [h_high, w_high, c_high] = size(high_res_img);
    [h_low, w_low, c_low] = size(low_res_img);
    
    pixels_high = h_high * w_high;
    pixels_low = h_low * w_low;
    
    fprintf('High Resolution Metrics:\n');
    fprintf('  Dimensions: %d x %d pixels\n', w_high, h_high);
    fprintf('  Total pixels: %,d\n', pixels_high);
    fprintf('  Megapixels: %.2f MP\n', pixels_high / 1e6);
    
    fprintf('\nLow Resolution Metrics:\n');
    fprintf('  Dimensions: %d x %d pixels\n', w_low, h_low);
    fprintf('  Total pixels: %,d\n', pixels_low);
    fprintf('  Megapixels: %.2f MP\n', pixels_low / 1e6);
    
    % Comparison metrics
    pixel_ratio = pixels_high / pixels_low;
    linear_ratio = sqrt(pixel_ratio);
    
    fprintf('\nComparison Metrics:\n');
    fprintf('  Pixel count ratio: %.1f:1\n', pixel_ratio);
    fprintf('  Linear dimension ratio: %.1f:1\n', linear_ratio);
    fprintf('  Storage reduction: %.1f%%\n', (1 - 1/pixel_ratio) * 100);
    
    % Calculate pixel density (if we had physical dimensions)
    fprintf('\n  Note: Pixel density depends on display/print size\n');
    fprintf('  At 6" width: High=%.0f PPI, Low=%.0f PPI\n', w_high/6, w_low/6);
    fprintf('  At 10" width: High=%.0f PPI, Low=%.0f PPI\n', w_high/10, w_low/10);
end

% Create resolution pyramid
function pyramid = create_resolution_pyramid(original_img)
    fprintf('\n=== CREATING RESOLUTION PYRAMID ===\n');
    
    [h_orig, w_orig, ~] = size(original_img);
    
    % Define scale factors
    scale_factors = [1.0, 0.75, 0.5, 0.25, 0.125];
    pyramid = cell(length(scale_factors), 1);
    
    for i = 1:length(scale_factors)
        scale = scale_factors(i);
        new_h = round(h_orig * scale);
        new_w = round(w_orig * scale);
        
        pyramid{i} = imresize(original_img, [new_h, new_w], 'bicubic');
        
        pixels = new_h * new_w;
        fprintf('Level %d: %.0f%% scale, %dx%d, %.1fK pixels\n', ...
                i, scale*100, new_w, new_h, pixels/1000);
    end
end

% Display resolution comparison
function display_resolution_comparison(high_res, low_res, pyramid)
    fprintf('\n=== DISPLAYING RESOLUTION COMPARISON ===\n');
    
    figure('Name', 'Q12: Resolution Comparison', 'Position', [50, 50, 1600, 1000]);
    
    % Show original high and low resolution
    subplot(2, 3, 1);
    imshow(high_res);
    title(sprintf('High Resolution\n%dx%d', size(high_res, 2), size(high_res, 1)));
    
    subplot(2, 3, 2);
    imshow(low_res);
    title(sprintf('Low Resolution\n%dx%d', size(low_res, 2), size(low_res, 1)));
    
    % Show pyramid levels
    for i = 2:min(4, length(pyramid))
        subplot(2, 3, i + 1);
        imshow(pyramid{i + 1});
        [h, w, ~] = size(pyramid{i + 1});
        title(sprintf('Level %d\n%dx%d', i + 1, w, h));
    end
    
    % Detail comparison - crop a small region and enlarge
    figure('Name', 'Q12: Detail Comparison', 'Position', [100, 100, 1200, 400]);
    
    % Define crop region (center portion)
    [h_high, w_high, ~] = size(high_res);
    crop_size = min(200, min(h_high, w_high) / 4);
    start_y = round((h_high - crop_size) / 2);
    start_x = round((w_high - crop_size) / 2);
    
    high_res_crop = high_res(start_y:(start_y + crop_size), start_x:(start_x + crop_size), :);
    
    subplot(1, 3, 1);
    imshow(imresize(high_res_crop, 2, 'nearest'));
    title('High Res Detail (2x)');
    
    % Corresponding crop from low resolution (scaled up)
    scale_ratio = size(low_res, 1) / size(high_res, 1);
    low_start_y = round(start_y * scale_ratio);
    low_start_x = round(start_x * scale_ratio);
    low_crop_size = round(crop_size * scale_ratio);
    
    if low_start_y + low_crop_size <= size(low_res, 1) && low_start_x + low_crop_size <= size(low_res, 2)
        low_res_crop = low_res(low_start_y:(low_start_y + low_crop_size), ...
                              low_start_x:(low_start_x + low_crop_size), :);
        
        subplot(1, 3, 2);
        imshow(imresize(low_res_crop, [crop_size * 2, crop_size * 2], 'nearest'));
        title('Low Res Detail (Upscaled)');
        
        % Side by side comparison
        subplot(1, 3, 3);
        comparison = [imresize(high_res_crop, 2, 'nearest'), ...
                     imresize(low_res_crop, [crop_size * 2, crop_size * 2], 'nearest')];
        imshow(comparison);
        title('Side by Side');
    end
end

% Test processing operations at different resolutions
function test_processing_at_resolutions(high_res, low_res, pyramid)
    fprintf('\n=== TESTING PROCESSING AT DIFFERENT RESOLUTIONS ===\n');
    
    % Test operations: edge detection, blur, histogram equalization
    operations = {'Edge Detection', 'Gaussian Blur', 'Histogram Equalization'};
    
    fprintf('Testing %d operations on %d resolution levels...\n', ...
            length(operations), length(pyramid));
    
    % Test each operation
    for op_idx = 1:length(operations)
        fprintf('\n--- %s ---\n', operations{op_idx});
        
        figure('Name', sprintf('Q12: %s at Different Resolutions', operations{op_idx}), ...
               'Position', [50 + op_idx*50, 50 + op_idx*50, 1400, 300]);
        
        for res_idx = 1:min(5, length(pyramid))
            img = pyramid{res_idx};
            [h, w, ~] = size(img);
            
            tic;
            switch op_idx
                case 1 % Edge Detection
                    if size(img, 3) == 3
                        img_gray = rgb2gray(img);
                    else
                        img_gray = img;
                    end
                    processed = edge(img_gray, 'canny');
                    
                case 2 % Gaussian Blur
                    sigma = 2;
                    processed = imgaussfilt(img, sigma);
                    
                case 3 % Histogram Equalization
                    if size(img, 3) == 3
                        processed = zeros(size(img));
                        for c = 1:3
                            processed(:, :, c) = histeq(img(:, :, c));
                        end
                        processed = uint8(processed);
                    else
                        processed = histeq(img);
                    end
            end
            processing_time = toc;
            
            subplot(1, 5, res_idx);
            imshow(processed);
            title(sprintf('%dx%d\n%.3fs', w, h, processing_time));
            
            fprintf('  Resolution %dx%d: %.3f seconds\n', w, h, processing_time);
        end
    end
end

% Analyze speed vs quality trade-offs
function analyze_speed_quality_tradeoffs(original_img, pyramid)
    fprintf('\n=== SPEED VS QUALITY ANALYSIS ===\n');
    
    % Test convolution operation (Gaussian filter) at different resolutions
    sigma = 3;
    filter_size = 2 * ceil(2 * sigma) + 1;
    
    fprintf('Testing Gaussian filter (σ=%.1f, size=%dx%d) performance:\n', ...
            sigma, filter_size, filter_size);
    fprintf('\nResolution\t\tPixels\t\tTime(s)\t\tMPixels/s\n');
    fprintf('--------------------------------------------------------\n');
    
    times = zeros(length(pyramid), 1);
    pixel_counts = zeros(length(pyramid), 1);
    
    for i = 1:length(pyramid)
        img = pyramid{i};
        [h, w, ~] = size(img);
        pixel_counts(i) = h * w;
        
        % Time the filtering operation
        tic;
        for repeat = 1:5  % Average over multiple runs
            filtered = imgaussfilt(img, sigma);
        end
        times(i) = toc / 5;  % Average time
        
        throughput = (pixel_counts(i) / 1e6) / times(i);
        
        fprintf('%dx%d\t\t%dK\t\t%.4f\t\t%.1f\n', ...
                w, h, round(pixel_counts(i)/1000), times(i), throughput);
    end
    
    % Plot performance curve
    figure('Name', 'Q12: Performance Analysis', 'Position', [200, 200, 1200, 400]);
    
    subplot(1, 3, 1);
    loglog(pixel_counts, times, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('Pixel Count');
    ylabel('Processing Time (s)');
    title('Processing Time vs Resolution');
    grid on;
    
    subplot(1, 3, 2);
    throughput = pixel_counts ./ times;
    semilogx(pixel_counts, throughput / 1e6, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('Pixel Count');
    ylabel('Throughput (MPixels/s)');
    title('Processing Throughput');
    grid on;
    
    subplot(1, 3, 3);
    efficiency = throughput / max(throughput) * 100;
    semilogx(pixel_counts, efficiency, 'go-', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('Pixel Count');
    ylabel('Relative Efficiency (%)');
    title('Processing Efficiency');
    grid on;
    
    % Analysis
    fprintf('\n=== PERFORMANCE INSIGHTS ===\n');
    
    % Find optimal resolution for different use cases
    [max_throughput, max_idx] = max(throughput);
    optimal_pixels = pixel_counts(max_idx);
    
    fprintf('Maximum throughput: %.1f MPixels/s at %dK pixels\n', ...
            max_throughput/1e6, round(optimal_pixels/1000));
    
    % Scaling analysis
    large_idx = find(pixel_counts > 1e6, 1);
    small_idx = find(pixel_counts < 1e5, 1, 'last');
    
    if ~isempty(large_idx) && ~isempty(small_idx)
        time_ratio = times(large_idx) / times(small_idx);
        pixel_ratio = pixel_counts(large_idx) / pixel_counts(small_idx);
        
        fprintf('Scaling factor: %.1fx pixels → %.1fx processing time\n', ...
                pixel_ratio, time_ratio);
        
        if time_ratio < pixel_ratio
            fprintf('Sub-linear scaling: Algorithm benefits from larger images\n');
        elseif time_ratio > pixel_ratio
            fprintf('Super-linear scaling: Algorithm penalty for larger images\n');
        else
            fprintf('Linear scaling: Processing time proportional to pixel count\n');
        end
    end
end

% Analyze memory usage
function analyze_memory_usage(original_img, pyramid)
    fprintf('\n=== MEMORY USAGE ANALYSIS ===\n');
    
    fprintf('Memory requirements for different resolutions:\n');
    fprintf('\nResolution\t\tUncompressed\tTypical JPEG\tRAM Usage\n');
    fprintf('--------------------------------------------------------\n');
    
    for i = 1:length(pyramid)
        img = pyramid{i};
        [h, w, c] = size(img);
        
        % Uncompressed size (bytes)
        uncompressed_bytes = h * w * c;
        
        % Estimate JPEG size (typically 10-20% of uncompressed for photos)
        jpeg_bytes = uncompressed_bytes * 0.15;
        
        % RAM usage for processing (often need multiple copies)
        ram_usage = uncompressed_bytes * 3;  % Original + working + result
        
        fprintf('%dx%d\t\t%.1fKB\t\t%.1fKB\t\t%.1fKB\n', ...
                w, h, uncompressed_bytes/1024, jpeg_bytes/1024, ram_usage/1024);
    end
    
    % Memory scaling insights
    fprintf('\n=== MEMORY SCALING INSIGHTS ===\n');
    
    [h_max, w_max, c_max] = size(pyramid{1});
    [h_min, w_min, c_min] = size(pyramid{end});
    
    max_memory = h_max * w_max * c_max * 3;
    min_memory = h_min * w_min * c_min * 3;
    memory_ratio = max_memory / min_memory;
    
    fprintf('Memory usage ratio (max:min): %.1f:1\n', memory_ratio);
    
    if max_memory > 100e6  % 100MB
        fprintf('High resolution requires >100MB RAM - may cause swapping\n');
    end
    
    if max_memory > 1e9  % 1GB
        fprintf('Very high resolution requires >1GB RAM - consider processing in tiles\n');
    end
end

% Provide practical recommendations
function provide_resolution_recommendations()
    fprintf('\n=== PRACTICAL RESOLUTION RECOMMENDATIONS ===\n');
    
    fprintf('1. WEB DISPLAY:\n');
    fprintf('   - Thumbnail: 150x150 pixels\n');
    fprintf('   - Gallery preview: 400x300 pixels\n');
    fprintf('   - Full screen: 1920x1080 pixels (1080p)\n\n');
    
    fprintf('2. PRINT APPLICATIONS:\n');
    fprintf('   - 4x6 inch photo: 1200x1800 pixels (300 DPI)\n');
    fprintf('   - 8x10 inch photo: 2400x3000 pixels (300 DPI)\n');
    fprintf('   - A4 document: 2480x3508 pixels (300 DPI)\n\n');
    
    fprintf('3. PROCESSING OPTIMIZATION:\n');
    fprintf('   - Algorithm development: Use low res (512x384) for speed\n');
    fprintf('   - Quality testing: Use medium res (1024x768)\n');
    fprintf('   - Final processing: Use full resolution\n\n');
    
    fprintf('4. MOBILE APPLICATIONS:\n');
    fprintf('   - Phone screen: 1080x1920 pixels (portrait)\n');
    fprintf('   - Tablet screen: 1536x2048 pixels\n');
    fprintf('   - Memory constrained: Limit to 2MP (1600x1200)\n\n');
    
    fprintf('5. COMPUTER VISION:\n');
    fprintf('   - Object detection: 416x416 or 608x608 pixels\n');
    fprintf('   - Face recognition: 224x224 pixels\n');
    fprintf('   - OCR: 300 DPI minimum for text\n\n');
    
    fprintf('6. VIDEO PROCESSING:\n');
    fprintf('   - SD video: 640x480 pixels\n');
    fprintf('   - HD video: 1280x720 pixels\n');
    fprintf('   - Full HD: 1920x1080 pixels\n');
    fprintf('   - 4K video: 3840x2160 pixels\n\n');
    
    fprintf('=== RESOLUTION SELECTION GUIDELINES ===\n');
    fprintf('• Start processing with low resolution for algorithm development\n');
    fprintf('• Use medium resolution for parameter tuning\n');
    fprintf('• Apply final processing at target resolution\n');
    fprintf('• Consider memory limitations of target deployment environment\n');
    fprintf('• Balance processing speed with quality requirements\n');
    fprintf('• For real-time applications, prioritize speed over maximum quality\n');
    fprintf('• For archival/print applications, prioritize quality over speed\n');
end

% Test resolution-dependent algorithms
function test_resolution_dependent_algorithms(pyramid)
    fprintf('\n=== TESTING RESOLUTION-DEPENDENT ALGORITHMS ===\n');
    
    % Algorithms that behave differently at different resolutions
    algorithms = {'Corner Detection', 'Texture Analysis', 'Object Detection'};
    
    for alg_idx = 1:length(algorithms)
        fprintf('\n--- %s ---\n', algorithms{alg_idx});
        
        for res_idx = 1:length(pyramid)
            img = pyramid{res_idx};
            [h, w, ~] = size(img);
            
            switch alg_idx
                case 1 % Corner Detection
                    if size(img, 3) == 3
                        img_gray = rgb2gray(img);
                    else
                        img_gray = img;
                    end
                    corners = detectHarrisFeatures(img_gray);
                    num_features = corners.Count;
                    
                case 2 % Texture Analysis (using gradient statistics)
                    if size(img, 3) == 3
                        img_gray = rgb2gray(img);
                    else
                        img_gray = img;
                    end
                    [gx, gy] = gradient(double(img_gray));
                    texture_measure = std(sqrt(gx.^2 + gy.^2), 0, 'all');
                    num_features = texture_measure;
                    
                case 3 % Object Detection (simplified blob detection)
                    if size(img, 3) == 3
                        img_gray = rgb2gray(img);
                    else
                        img_gray = img;
                    end
                    % Simple blob detection using thresholding
                    binary = img_gray > graythresh(img_gray) * 255;
                    props = regionprops(binary, 'Area');
                    areas = [props.Area];
                    num_features = sum(areas > 50);  % Count significant blobs
            end
            
            fprintf('  %dx%d: %.1f features/measures\n', w, h, num_features);
        end
    end
end