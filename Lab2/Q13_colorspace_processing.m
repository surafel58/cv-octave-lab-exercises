% Q13: Color Space Conversion for Image Processing Tasks
% This function demonstrates how color representation affects edge detection and segmentation

function Q13_colorspace_processing(image_path)
    if nargin < 1
        image_path = 'images/test_images/colorful.jpg';
    end
    
    fprintf('=== Q13: Color Space Conversion for Image Processing ===\n\n');
    
    try
        % Load original RGB image
        rgb_img = imread(image_path);
        
        if size(rgb_img, 3) ~= 3
            error('Input image must be a color (RGB) image');
        end
        
        fprintf('Processing image: %s\n', image_path);
        fprintf('Original dimensions: %dx%dx%d\n', size(rgb_img));
        
        % Convert to different color spaces
        fprintf('\n=== Converting to Different Color Spaces ===\n');
        
        % 1. HSV Color Space
        hsv_img = rgb2hsv(rgb_img);
        fprintf('✓ HSV conversion completed\n');
        
        % 2. YCbCr Color Space
        try
            ycbcr_img = rgb2ycbcr(rgb_img);
            has_ycbcr = true;
        catch
            ycbcr_img = rgb_to_ycbcr_manual(rgb_img);
            has_ycbcr = false;
        end
        fprintf('✓ YCbCr conversion completed\n');
        
        % 3. LAB Color Space
        try
            lab_img = rgb2lab(rgb_img);
            has_lab = true;
        catch
            lab_img = rgb_to_lab_manual(rgb_img);
            has_lab = false;
        end
        fprintf('✓ LAB conversion completed\n');
        
        % 4. Grayscale
        gray_img = rgb2gray(rgb_img);
        fprintf('✓ Grayscale conversion completed\n');
        
        % Test edge detection in different color spaces
        fprintf('\n=== EDGE DETECTION IN DIFFERENT COLOR SPACES ===\n');
        edge_results = test_edge_detection(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img);
        
        % Test segmentation in different color spaces
        fprintf('\n=== SEGMENTATION IN DIFFERENT COLOR SPACES ===\n');
        segmentation_results = test_segmentation(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img);
        
        % Test color-based operations
        fprintf('\n=== COLOR-BASED OPERATIONS ===\n');
        color_ops_results = test_color_operations(rgb_img, hsv_img, ycbcr_img, lab_img);
        
        % Display comprehensive comparison
        display_colorspace_comparison(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img);
        display_processing_results(edge_results, segmentation_results);
        
        % Analyze performance and quality
        analyze_colorspace_performance(edge_results, segmentation_results);
        
        % Provide recommendations
        provide_colorspace_recommendations();
        
        % Save processed results
        save_colorspace_results(image_path, edge_results, segmentation_results, color_ops_results);
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Test edge detection in different color spaces
function edge_results = test_edge_detection(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img)
    fprintf('Testing edge detection algorithms...\n');
    
    edge_results = struct();
    
    % Edge detection methods to test
    methods = {'canny', 'sobel', 'prewitt', 'roberts'};
    
    for method_idx = 1:length(methods)
        method = methods{method_idx};
        fprintf('  Testing %s edge detection...\n', method);
        
        % RGB - process each channel separately then combine
        tic;
        rgb_edges = zeros(size(rgb_img, 1), size(rgb_img, 2));
        for c = 1:3
            edges_c = edge(rgb_img(:, :, c), method);
            rgb_edges = rgb_edges | edges_c;
        end
        time_rgb = toc;
        
        % HSV - use Value channel for edge detection
        tic;
        hsv_v = hsv_img(:, :, 3);
        hsv_edges = edge(uint8(hsv_v * 255), method);
        time_hsv = toc;
        
        % YCbCr - use luminance (Y) channel
        tic;
        y_channel = ycbcr_img(:, :, 1);
        ycbcr_edges = edge(y_channel, method);
        time_ycbcr = toc;
        
        % LAB - use lightness (L) channel
        tic;
        if size(lab_img, 3) == 3
            l_channel = lab_img(:, :, 1);
            if max(l_channel(:)) > 1  % LAB range might be 0-100
                l_channel = uint8(l_channel * 255 / 100);
            else
                l_channel = uint8(l_channel * 255);
            end
        else
            l_channel = uint8(lab_img * 255);
        end
        lab_edges = edge(l_channel, method);
        time_lab = toc;
        
        % Grayscale
        tic;
        gray_edges = edge(gray_img, method);
        time_gray = toc;
        
        % Store results
        edge_results.(method).rgb = rgb_edges;
        edge_results.(method).hsv = hsv_edges;
        edge_results.(method).ycbcr = ycbcr_edges;
        edge_results.(method).lab = lab_edges;
        edge_results.(method).gray = gray_edges;
        
        edge_results.(method).times = [time_rgb, time_hsv, time_ycbcr, time_lab, time_gray];
        
        % Calculate edge statistics
        edge_results.(method).stats.rgb = calculate_edge_stats(rgb_edges);
        edge_results.(method).stats.hsv = calculate_edge_stats(hsv_edges);
        edge_results.(method).stats.ycbcr = calculate_edge_stats(ycbcr_edges);
        edge_results.(method).stats.lab = calculate_edge_stats(lab_edges);
        edge_results.(method).stats.gray = calculate_edge_stats(gray_edges);
        
        fprintf('    Processing times: RGB=%.3fs, HSV=%.3fs, YCbCr=%.3fs, LAB=%.3fs, Gray=%.3fs\n', ...
                time_rgb, time_hsv, time_ycbcr, time_lab, time_gray);
    end
end

% Test segmentation in different color spaces
function seg_results = test_segmentation(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img)
    fprintf('Testing segmentation algorithms...\n');
    
    seg_results = struct();
    
    % K-means clustering segmentation
    fprintf('  Testing K-means clustering...\n');
    k = 4;  % Number of clusters
    
    % RGB segmentation
    tic;
    rgb_reshaped = reshape(double(rgb_img), [], 3);
    [rgb_idx, ~] = kmeans(rgb_reshaped, k);
    rgb_segmented = reshape(rgb_idx, size(rgb_img, 1), size(rgb_img, 2));
    time_rgb_kmeans = toc;
    
    % HSV segmentation
    tic;
    hsv_reshaped = reshape(hsv_img, [], 3);
    [hsv_idx, ~] = kmeans(hsv_reshaped, k);
    hsv_segmented = reshape(hsv_idx, size(hsv_img, 1), size(hsv_img, 2));
    time_hsv_kmeans = toc;
    
    % LAB segmentation
    tic;
    lab_reshaped = reshape(double(lab_img), [], size(lab_img, 3));
    [lab_idx, ~] = kmeans(lab_reshaped, k);
    lab_segmented = reshape(lab_idx, size(lab_img, 1), size(lab_img, 2));
    time_lab_kmeans = toc;
    
    % Grayscale segmentation (1D)
    tic;
    gray_reshaped = double(gray_img(:));
    [gray_idx, ~] = kmeans(gray_reshaped, k);
    gray_segmented = reshape(gray_idx, size(gray_img));
    time_gray_kmeans = toc;
    
    % Store K-means results
    seg_results.kmeans.rgb = rgb_segmented;
    seg_results.kmeans.hsv = hsv_segmented;
    seg_results.kmeans.lab = lab_segmented;
    seg_results.kmeans.gray = gray_segmented;
    seg_results.kmeans.times = [time_rgb_kmeans, time_hsv_kmeans, time_lab_kmeans, time_gray_kmeans];
    
    fprintf('    K-means times: RGB=%.3fs, HSV=%.3fs, LAB=%.3fs, Gray=%.3fs\n', ...
            time_rgb_kmeans, time_hsv_kmeans, time_lab_kmeans, time_gray_kmeans);
    
    % Otsu thresholding
    fprintf('  Testing Otsu thresholding...\n');
    
    % Convert all to grayscale versions for thresholding
    rgb_gray = rgb2gray(rgb_img);
    hsv_gray = uint8(hsv_img(:, :, 3) * 255);  % Value channel
    ycbcr_gray = ycbcr_img(:, :, 1);  % Y channel
    lab_gray = uint8(mat2gray(lab_img(:, :, 1)) * 255);  % L channel
    
    % Apply Otsu thresholding
    thresh_rgb = graythresh(rgb_gray);
    thresh_hsv = graythresh(hsv_gray);
    thresh_ycbcr = graythresh(ycbcr_gray);
    thresh_lab = graythresh(lab_gray);
    thresh_gray = graythresh(gray_img);
    
    seg_results.otsu.rgb = imbinarize(rgb_gray, thresh_rgb);
    seg_results.otsu.hsv = imbinarize(hsv_gray, thresh_hsv);
    seg_results.otsu.ycbcr = imbinarize(ycbcr_gray, thresh_ycbcr);
    seg_results.otsu.lab = imbinarize(lab_gray, thresh_lab);
    seg_results.otsu.gray = imbinarize(gray_img, thresh_gray);
    
    seg_results.otsu.thresholds = [thresh_rgb, thresh_hsv, thresh_ycbcr, thresh_lab, thresh_gray];
    
    fprintf('    Otsu thresholds: RGB=%.3f, HSV=%.3f, YCbCr=%.3f, LAB=%.3f, Gray=%.3f\n', ...
            thresh_rgb, thresh_hsv, thresh_ycbcr, thresh_lab, thresh_gray);
end

% Test color-specific operations
function color_results = test_color_operations(rgb_img, hsv_img, ycbcr_img, lab_img)
    fprintf('Testing color-specific operations...\n');
    
    color_results = struct();
    
    % 1. Color-based masking (e.g., isolate red objects)
    fprintf('  Color-based masking...\n');
    
    % HSV is best for color masking
    h_channel = hsv_img(:, :, 1);
    s_channel = hsv_img(:, :, 2);
    v_channel = hsv_img(:, :, 3);
    
    % Red color mask (hue around 0 or 1, high saturation)
    red_mask1 = (h_channel < 0.1 | h_channel > 0.9) & (s_channel > 0.5) & (v_channel > 0.3);
    
    % Green color mask
    green_mask = (h_channel > 0.25 & h_channel < 0.4) & (s_channel > 0.5) & (v_channel > 0.3);
    
    % Blue color mask
    blue_mask = (h_channel > 0.55 & h_channel < 0.7) & (s_channel > 0.5) & (v_channel > 0.3);
    
    color_results.masks.red = red_mask1;
    color_results.masks.green = green_mask;
    color_results.masks.blue = blue_mask;
    
    % 2. Skin detection (works best in YCbCr)
    fprintf('  Skin detection...\n');
    
    Y = double(ycbcr_img(:, :, 1));
    Cb = double(ycbcr_img(:, :, 2));
    Cr = double(ycbcr_img(:, :, 3));
    
    % Skin detection rules in YCbCr
    skin_mask = (Y > 80) & (Cb >= 77 & Cb <= 127) & (Cr >= 133 & Cr <= 173);
    color_results.skin_mask = skin_mask;
    
    % 3. Shadow detection (works well in LAB)
    fprintf('  Shadow detection...\n');
    
    if size(lab_img, 3) == 3
        L = lab_img(:, :, 1);
        shadow_mask = L < (mean(L(:)) - std(L(:)));
    else
        shadow_mask = lab_img < (mean(lab_img(:)) - std(lab_img(:)));
    end
    color_results.shadow_mask = shadow_mask;
    
    % 4. Contrast enhancement in perceptually uniform space
    fprintf('  Perceptual contrast enhancement...\n');
    
    % LAB space allows perceptually uniform adjustments
    if size(lab_img, 3) == 3
        lab_enhanced = lab_img;
        lab_enhanced(:, :, 1) = imadjust(mat2gray(lab_img(:, :, 1))); % Enhance lightness
        try
            color_results.enhanced = lab2rgb(lab_enhanced);
        catch
            color_results.enhanced = lab_to_rgb_manual(lab_enhanced);
        end
    else
        color_results.enhanced = rgb_img; % Fallback
    end
end

% Calculate edge statistics
function stats = calculate_edge_stats(edge_img)
    stats.total_edges = sum(edge_img(:));
    stats.edge_density = stats.total_edges / numel(edge_img);
    stats.edge_percentage = stats.edge_density * 100;
    
    % Connected components analysis
    cc = bwconncomp(edge_img);
    stats.num_components = cc.NumObjects;
    
    if stats.num_components > 0
        component_sizes = cellfun(@length, cc.PixelIdxList);
        stats.avg_component_size = mean(component_sizes);
        stats.max_component_size = max(component_sizes);
    else
        stats.avg_component_size = 0;
        stats.max_component_size = 0;
    end
end

% Display color space comparison
function display_colorspace_comparison(rgb_img, hsv_img, ycbcr_img, lab_img, gray_img)
    figure('Name', 'Q13: Color Space Comparison', 'Position', [50, 50, 1600, 800]);
    
    % Original RGB
    subplot(2, 5, 1);
    imshow(rgb_img);
    title('RGB Original');
    
    % HSV channels
    subplot(2, 5, 2);
    imshow(hsv_img);
    title('HSV Composite');
    
    subplot(2, 5, 7);
    imshow(hsv_img(:, :, 1), []);
    colormap(gca, 'hsv');
    title('HSV - Hue');
    
    % YCbCr channels
    subplot(2, 5, 3);
    if size(ycbcr_img, 3) == 3
        try
            imshow(ycbcr_img);
        catch
            imshow(ycbcr_img / 255);
        end
    else
        imshow(ycbcr_img, []);
    end
    title('YCbCr Composite');
    
    subplot(2, 5, 8);
    imshow(ycbcr_img(:, :, 1), []);
    colormap(gca, 'gray');
    title('YCbCr - Y (Luminance)');
    
    % LAB channels
    subplot(2, 5, 4);
    if size(lab_img, 3) == 3
        try
            imshow(lab_img);
        catch
            lab_display = lab_img;
            lab_display(:, :, 1) = mat2gray(lab_img(:, :, 1));
            lab_display(:, :, 2) = mat2gray(lab_img(:, :, 2));
            lab_display(:, :, 3) = mat2gray(lab_img(:, :, 3));
            imshow(lab_display);
        end
    else
        imshow(lab_img, []);
    end
    title('LAB Composite');
    
    subplot(2, 5, 9);
    imshow(mat2gray(lab_img(:, :, 1)));
    title('LAB - L (Lightness)');
    
    % Grayscale
    subplot(2, 5, 5);
    imshow(gray_img);
    title('Grayscale');
    
    % Individual RGB channels for comparison
    subplot(2, 5, 6);
    rgb_channels = cat(2, rgb_img(:, :, 1), rgb_img(:, :, 2), rgb_img(:, :, 3));
    imshow(rgb_channels);
    title('RGB Channels (R|G|B)');
    
    subplot(2, 5, 10);
    hsv_channels = cat(2, uint8(hsv_img(:, :, 2)*255), uint8(hsv_img(:, :, 3)*255));
    imshow(hsv_channels);
    title('HSV S|V Channels');
end

% Display processing results
function display_processing_results(edge_results, seg_results)
    % Edge detection comparison
    methods = fieldnames(edge_results);
    
    for method_idx = 1:length(methods)
        method = methods{method_idx};
        
        figure('Name', sprintf('Q13: %s Edge Detection Comparison', upper(method)), ...
               'Position', [100 + method_idx*50, 100 + method_idx*50, 1400, 600]);
        
        subplot(2, 5, 1);
        imshow(edge_results.(method).rgb);
        title('RGB Edges');
        
        subplot(2, 5, 2);
        imshow(edge_results.(method).hsv);
        title('HSV Edges');
        
        subplot(2, 5, 3);
        imshow(edge_results.(method).ycbcr);
        title('YCbCr Edges');
        
        subplot(2, 5, 4);
        imshow(edge_results.(method).lab);
        title('LAB Edges');
        
        subplot(2, 5, 5);
        imshow(edge_results.(method).gray);
        title('Grayscale Edges');
        
        % Statistics comparison
        subplot(2, 5, 6:10);
        colorspaces = {'RGB', 'HSV', 'YCbCr', 'LAB', 'Gray'};
        edge_densities = [edge_results.(method).stats.rgb.edge_percentage, ...
                         edge_results.(method).stats.hsv.edge_percentage, ...
                         edge_results.(method).stats.ycbcr.edge_percentage, ...
                         edge_results.(method).stats.lab.edge_percentage, ...
                         edge_results.(method).stats.gray.edge_percentage];
        
        bar(edge_densities);
        set(gca, 'XTickLabel', colorspaces);
        ylabel('Edge Density (%)');
        title(sprintf('%s Edge Detection - Density Comparison', upper(method)));
        grid on;
    end
    
    % Segmentation comparison
    figure('Name', 'Q13: Segmentation Comparison', 'Position', [200, 200, 1200, 800]);
    
    % K-means results
    subplot(2, 4, 1);
    imshow(label2rgb(seg_results.kmeans.rgb));
    title('K-means RGB');
    
    subplot(2, 4, 2);
    imshow(label2rgb(seg_results.kmeans.hsv));
    title('K-means HSV');
    
    subplot(2, 4, 3);
    imshow(label2rgb(seg_results.kmeans.lab));
    title('K-means LAB');
    
    subplot(2, 4, 4);
    imshow(label2rgb(seg_results.kmeans.gray));
    title('K-means Gray');
    
    % Otsu results
    subplot(2, 4, 5);
    imshow(seg_results.otsu.rgb);
    title('Otsu RGB');
    
    subplot(2, 4, 6);
    imshow(seg_results.otsu.hsv);
    title('Otsu HSV');
    
    subplot(2, 4, 7);
    imshow(seg_results.otsu.lab);
    title('Otsu LAB');
    
    subplot(2, 4, 8);
    imshow(seg_results.otsu.gray);
    title('Otsu Gray');
end

% Analyze color space performance
function analyze_colorspace_performance(edge_results, seg_results)
    fprintf('\n=== COLOR SPACE PERFORMANCE ANALYSIS ===\n');
    
    methods = fieldnames(edge_results);
    colorspaces = {'RGB', 'HSV', 'YCbCr', 'LAB', 'Gray'};
    
    % Edge detection analysis
    fprintf('\nEdge Detection Performance:\n');
    fprintf('Method\t\t');
    for i = 1:length(colorspaces)
        fprintf('%-8s', colorspaces{i});
    end
    fprintf('\n');
    fprintf(repmat('-', 1, 50));
    fprintf('\n');
    
    for method_idx = 1:length(methods)
        method = methods{method_idx};
        fprintf('%-10s\t', upper(method));
        
        times = edge_results.(method).times;
        for i = 1:length(times)
            fprintf('%.3fs\t', times(i));
        end
        fprintf('\n');
    end
    
    % Segmentation analysis
    fprintf('\nSegmentation Performance:\n');
    fprintf('K-means clustering times:\n');
    times = seg_results.kmeans.times;
    for i = 1:length(colorspaces)-1  % K-means not done on YCbCr
        fprintf('  %s: %.3f seconds\n', colorspaces{i}, times(i));
    end
    
    % Quality analysis
    fprintf('\n=== QUALITY ANALYSIS ===\n');
    
    fprintf('\nEdge Detection Quality (Edge Density %%):\n');
    for method_idx = 1:length(methods)
        method = methods{method_idx};
        fprintf('%s: ', upper(method));
        
        densities = [edge_results.(method).stats.rgb.edge_percentage, ...
                    edge_results.(method).stats.hsv.edge_percentage, ...
                    edge_results.(method).stats.ycbcr.edge_percentage, ...
                    edge_results.(method).stats.lab.edge_percentage, ...
                    edge_results.(method).stats.gray.edge_percentage];
        
        for i = 1:length(densities)
            fprintf('%.1f%% ', densities(i));
        end
        fprintf('\n');
    end
    
    % Segmentation quality (number of clusters found)
    fprintf('\nSegmentation Quality (Otsu Thresholds):\n');
    thresholds = seg_results.otsu.thresholds;
    for i = 1:length(colorspaces)
        fprintf('  %s: %.3f\n', colorspaces{i}, thresholds(i));
    end
end

% Provide color space recommendations
function provide_colorspace_recommendations()
    fprintf('\n=== COLOR SPACE RECOMMENDATIONS ===\n');
    
    fprintf('\n1. EDGE DETECTION:\n');
    fprintf('   • RGB: Good for color edges, but computationally expensive\n');
    fprintf('   • Grayscale: Fastest, good for luminance edges\n');
    fprintf('   • YCbCr (Y channel): Best balance of speed and quality\n');
    fprintf('   • HSV (V channel): Good for preserving color information\n');
    fprintf('   • LAB (L channel): Perceptually uniform, good for human vision\n\n');
    
    fprintf('2. SEGMENTATION:\n');
    fprintf('   • RGB: Natural but sensitive to lighting\n');
    fprintf('   • HSV: Excellent for color-based segmentation\n');
    fprintf('   • LAB: Best for perceptually uniform clustering\n');
    fprintf('   • YCbCr: Good separation of luminance and chrominance\n\n');
    
    fprintf('3. COLOR-BASED OPERATIONS:\n');
    fprintf('   • Color Detection: HSV (hue-based)\n');
    fprintf('   • Skin Detection: YCbCr (established thresholds)\n');
    fprintf('   • Shadow Detection: LAB (lightness-based)\n');
    fprintf('   • Illumination Correction: YCbCr or LAB\n\n');
    
    fprintf('4. SPECIFIC APPLICATIONS:\n');
    fprintf('   • Medical Imaging: Grayscale or LAB\n');
    fprintf('   • Object Recognition: HSV or LAB\n');
    fprintf('   • Face Detection: YCbCr\n');
    fprintf('   • Quality Assessment: LAB\n');
    fprintf('   • Compression: YCbCr (JPEG standard)\n\n');
    
    fprintf('5. COMPUTATIONAL CONSIDERATIONS:\n');
    fprintf('   • Speed Priority: Grayscale > YCbCr-Y > HSV-V > LAB-L > RGB\n');
    fprintf('   • Quality Priority: LAB > YCbCr > HSV > RGB > Grayscale\n');
    fprintf('   • Memory Usage: Grayscale < RGB = HSV = YCbCr = LAB\n\n');
    
    fprintf('6. LIGHTING CONDITIONS:\n');
    fprintf('   • Uniform Lighting: RGB or Grayscale\n');
    fprintf('   • Variable Lighting: HSV or LAB\n');
    fprintf('   • Low Light: YCbCr (Y channel) or enhanced LAB\n');
    fprintf('   • High Dynamic Range: LAB with tone mapping\n');
end

% Save color space processing results
function save_colorspace_results(original_path, edge_results, seg_results, color_results)
    [~, name, ~] = fileparts(original_path);
    
    fprintf('\n=== SAVING RESULTS ===\n');
    
    % Save edge detection results
    methods = fieldnames(edge_results);
    colorspaces = {'rgb', 'hsv', 'ycbcr', 'lab', 'gray'};
    
    for method_idx = 1:length(methods)
        method = methods{method_idx};
        for cs_idx = 1:length(colorspaces)
            cs = colorspaces{cs_idx};
            filename = sprintf('Lab2/images/edges_%s_%s_%s.jpg', method, cs, name);
            try
                imwrite(edge_results.(method).(cs), filename);
            catch
                fprintf('Failed to save %s\n', filename);
            end
        end
    end
    
    % Save segmentation results
    seg_methods = fieldnames(seg_results);
    for seg_idx = 1:length(seg_methods)
        seg_method = seg_methods{seg_idx};
        seg_colorspaces = fieldnames(seg_results.(seg_method));
        seg_colorspaces = seg_colorspaces(~strcmp(seg_colorspaces, 'times') & ~strcmp(seg_colorspaces, 'thresholds'));
        
        for cs_idx = 1:length(seg_colorspaces)
            cs = seg_colorspaces{cs_idx};
            filename = sprintf('Lab2/images/seg_%s_%s_%s.jpg', seg_method, cs, name);
            try
                if strcmp(seg_method, 'kmeans')
                    imwrite(label2rgb(seg_results.(seg_method).(cs)), filename);
                else
                    imwrite(seg_results.(seg_method).(cs), filename);
                end
            catch
                fprintf('Failed to save %s\n', filename);
            end
        end
    end
    
    % Save color operation results
    if isfield(color_results, 'enhanced')
        filename = sprintf('Lab2/images/color_enhanced_%s.jpg', name);
        try
            imwrite(color_results.enhanced, filename);
        catch
            fprintf('Failed to save %s\n', filename);
        end
    end
    
    fprintf('Color space processing results saved to Lab2/images/\n');
end

% Manual RGB to YCbCr conversion
function ycbcr_img = rgb_to_ycbcr_manual(rgb_img)
    rgb_double = double(rgb_img) / 255;
    
    % YCbCr transformation matrix (ITU-R BT.601)
    T = [0.299,  0.587,  0.114;
        -0.169, -0.331,  0.500;
         0.500, -0.419, -0.081];
    
    [h, w, ~] = size(rgb_double);
    ycbcr_img = zeros(h, w, 3);
    
    for i = 1:h
        for j = 1:w
            rgb_pixel = squeeze(rgb_double(i, j, :))';
            ycbcr_pixel = T * rgb_pixel';
            ycbcr_img(i, j, :) = ycbcr_pixel;
        end
    end
    
    % Adjust ranges: Y[0,1], Cb,Cr[-0.5,0.5] -> [0,255]
    ycbcr_img(:, :, 1) = ycbcr_img(:, :, 1) * 255;  % Y
    ycbcr_img(:, :, 2) = (ycbcr_img(:, :, 2) + 0.5) * 255;  % Cb
    ycbcr_img(:, :, 3) = (ycbcr_img(:, :, 3) + 0.5) * 255;  % Cr
    
    ycbcr_img = uint8(max(0, min(255, ycbcr_img)));
end

% Manual RGB to LAB conversion (simplified)
function lab_img = rgb_to_lab_manual(rgb_img)
    % Simplified LAB conversion for demonstration
    rgb_double = double(rgb_img) / 255;
    
    % Convert to XYZ first (simplified)
    % This is a very basic approximation
    xyz_img = zeros(size(rgb_double));
    xyz_img(:, :, 1) = 0.412453 * rgb_double(:, :, 1) + 0.357580 * rgb_double(:, :, 2) + 0.180423 * rgb_double(:, :, 3);
    xyz_img(:, :, 2) = 0.212671 * rgb_double(:, :, 1) + 0.715160 * rgb_double(:, :, 2) + 0.072169 * rgb_double(:, :, 3);
    xyz_img(:, :, 3) = 0.019334 * rgb_double(:, :, 1) + 0.119193 * rgb_double(:, :, 2) + 0.950227 * rgb_double(:, :, 3);
    
    % Convert XYZ to LAB (simplified)
    lab_img = zeros(size(xyz_img));
    lab_img(:, :, 1) = 116 * (xyz_img(:, :, 2).^(1/3)) - 16;  % L
    lab_img(:, :, 2) = 500 * (xyz_img(:, :, 1).^(1/3) - xyz_img(:, :, 2).^(1/3));  % a
    lab_img(:, :, 3) = 200 * (xyz_img(:, :, 2).^(1/3) - xyz_img(:, :, 3).^(1/3));  % b
    
    % Normalize for display
    lab_img(:, :, 1) = lab_img(:, :, 1) / 100;  % L: 0-1
    lab_img(:, :, 2) = (lab_img(:, :, 2) + 128) / 255;  % a: 0-1
    lab_img(:, :, 3) = (lab_img(:, :, 3) + 128) / 255;  % b: 0-1
end

% Manual LAB to RGB conversion
function rgb_img = lab_to_rgb_manual(lab_img)
    % Reverse of the manual LAB conversion
    % This is a simplified approximation
    
    % Denormalize LAB
    lab_denorm = lab_img;
    lab_denorm(:, :, 1) = lab_img(:, :, 1) * 100;  % L
    lab_denorm(:, :, 2) = (lab_img(:, :, 2) * 255) - 128;  % a
    lab_denorm(:, :, 3) = (lab_img(:, :, 3) * 255) - 128;  % b
    
    % Convert LAB to XYZ (simplified)
    fy = (lab_denorm(:, :, 1) + 16) / 116;
    fx = lab_denorm(:, :, 2) / 500 + fy;
    fz = fy - lab_denorm(:, :, 3) / 200;
    
    xyz_img = zeros(size(lab_img));
    xyz_img(:, :, 1) = fx.^3;  % X
    xyz_img(:, :, 2) = fy.^3;  % Y
    xyz_img(:, :, 3) = fz.^3;  % Z
    
    % Convert XYZ to RGB (simplified)
    rgb_img = zeros(size(xyz_img));
    rgb_img(:, :, 1) = 3.240479 * xyz_img(:, :, 1) - 1.537150 * xyz_img(:, :, 2) - 0.498535 * xyz_img(:, :, 3);
    rgb_img(:, :, 2) = -0.969256 * xyz_img(:, :, 1) + 1.875991 * xyz_img(:, :, 2) + 0.041556 * xyz_img(:, :, 3);
    rgb_img(:, :, 3) = 0.055648 * xyz_img(:, :, 1) - 0.204043 * xyz_img(:, :, 2) + 1.057311 * xyz_img(:, :, 3);
    
    % Clamp to valid range
    rgb_img = max(0, min(1, rgb_img));
    rgb_img = uint8(rgb_img * 255);
end