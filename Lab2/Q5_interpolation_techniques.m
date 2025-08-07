% Q5: Different Interpolation Techniques for Image Resizing
% This function implements and compares different interpolation methods

function Q5_interpolation_techniques(image_path, scale_factor)
    if nargin < 2
        image_path = 'images/test_images/geometric.png';
        scale_factor = 2.0;  % 2x enlargement
    end
    
    fprintf('=== Q5: Interpolation Techniques Comparison ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        [orig_height, orig_width, channels] = size(original_img);
        
        fprintf('Original image: %s\n', image_path);
        fprintf('Original dimensions: %dx%d\n', orig_width, orig_height);
        fprintf('Scale factor: %.2f\n', scale_factor);
        
        % Calculate new dimensions
        new_width = round(orig_width * scale_factor);
        new_height = round(orig_height * scale_factor);
        
        fprintf('Target dimensions: %dx%d\n', new_width, new_height);
        
        % Method 1: Nearest Neighbor Interpolation
        tic;
        img_nearest = nearest_neighbor_resize(original_img, new_height, new_width);
        time_nearest = toc;
        
        % Method 2: Bilinear Interpolation (using imresize with 'bilinear')
        tic;
        img_bilinear = imresize(original_img, [new_height, new_width], 'bilinear');
        time_bilinear = toc;
        
        % Method 3: Bicubic Interpolation (using imresize with 'bicubic')
        tic;
        img_bicubic = imresize(original_img, [new_height, new_width], 'bicubic');
        time_bicubic = toc;
        
        % Method 4: Lanczos Interpolation (if available)
        try
            tic;
            img_lanczos = imresize(original_img, [new_height, new_width], 'lanczos3');
            time_lanczos = toc;
            has_lanczos = true;
        catch
            img_lanczos = img_bicubic; % Fallback
            time_lanczos = time_bicubic;
            has_lanczos = false;
            fprintf('Note: Lanczos interpolation not available, using bicubic as fallback\n');
        end
        
        % Display results
        figure('Name', 'Q5: Interpolation Techniques Comparison', 'Position', [50, 50, 1400, 800]);
        
        % Original image
        subplot(2, 3, 1);
        imshow(original_img);
        title('Original Image');
        
        % Nearest neighbor
        subplot(2, 3, 2);
        imshow(img_nearest);
        title(sprintf('Nearest Neighbor\n(%.4f sec)', time_nearest));
        
        % Bilinear
        subplot(2, 3, 3);
        imshow(img_bilinear);
        title(sprintf('Bilinear\n(%.4f sec)', time_bilinear));
        
        % Bicubic
        subplot(2, 3, 4);
        imshow(img_bicubic);
        title(sprintf('Bicubic\n(%.4f sec)', time_bicubic));
        
        % Lanczos
        subplot(2, 3, 5);
        imshow(img_lanczos);
        if has_lanczos
            title(sprintf('Lanczos\n(%.4f sec)', time_lanczos));
        else
            title('Lanczos (N/A)');
        end
        
        % Quality comparison (crop a small region for detail)
        crop_size = min(100, min(new_height, new_width) / 4);
        start_y = round(new_height / 3);
        start_x = round(new_width / 3);
        end_y = min(start_y + crop_size, new_height);
        end_x = min(start_x + crop_size, new_width);
        
        % Create comparison of cropped regions
        crop_nearest = img_nearest(start_y:end_y, start_x:end_x, :);
        crop_bilinear = img_bilinear(start_y:end_y, start_x:end_x, :);
        crop_bicubic = img_bicubic(start_y:end_y, start_x:end_x, :);
        
        subplot(2, 3, 6);
        combined_crop = [crop_nearest, crop_bilinear, crop_bicubic];
        imshow(combined_crop);
        title('Detail Comparison: NN | Bilinear | Bicubic');
        
        % Performance and quality analysis
        fprintf('\n=== Performance Analysis ===\n');
        fprintf('Method\t\t\tTime (sec)\tSpeed Rank\n');
        fprintf('----------------------------------------\n');
        
        times = [time_nearest, time_bilinear, time_bicubic];
        methods = {'Nearest Neighbor', 'Bilinear', 'Bicubic'};
        
        if has_lanczos
            times(end+1) = time_lanczos;
            methods{end+1} = 'Lanczos';
        end
        
        [sorted_times, idx] = sort(times);
        for i = 1:length(times)
            fprintf('%-15s\t%.6f\t\t%d\n', methods{i}, times(i), find(idx == i));
        end
        
        fprintf('\n=== Quality Analysis ===\n');
        fprintf('1. Nearest Neighbor:\n');
        fprintf('   - Fastest method\n');
        fprintf('   - Preserves sharp edges but creates blocky artifacts\n');
        fprintf('   - Best for: pixel art, binary images\n\n');
        
        fprintf('2. Bilinear Interpolation:\n');
        fprintf('   - Good speed-quality balance\n');
        fprintf('   - Smooth results but can blur sharp edges\n');
        fprintf('   - Best for: general purpose resizing\n\n');
        
        fprintf('3. Bicubic Interpolation:\n');
        fprintf('   - Slower but higher quality\n');
        fprintf('   - Better edge preservation than bilinear\n');
        fprintf('   - Best for: photographic images, detailed graphics\n\n');
        
        if has_lanczos
            fprintf('4. Lanczos Interpolation:\n');
            fprintf('   - Highest quality but slowest\n');
            fprintf('   - Excellent edge preservation\n');
            fprintf('   - Best for: professional image processing\n\n');
        end
        
        % Calculate image quality metrics (simple)
        if scale_factor > 1  % Only for upscaling
            fprintf('=== Image Quality Metrics (Upscaling) ===\n');
            
            % Convert to grayscale for analysis
            if size(original_img, 3) == 3
                orig_gray = rgb2gray(original_img);
                nearest_gray = rgb2gray(img_nearest);
                bilinear_gray = rgb2gray(img_bilinear);
                bicubic_gray = rgb2gray(img_bicubic);
            else
                orig_gray = original_img;
                nearest_gray = img_nearest;
                bilinear_gray = img_bilinear;
                bicubic_gray = img_bicubic;
            end
            
            % Resize original to same size for comparison
            orig_resized = imresize(orig_gray, [new_height, new_width], 'bicubic');
            
            % Calculate edge preservation (gradient magnitude)
            [gx_orig, gy_orig] = gradient(double(orig_resized));
            grad_orig = sqrt(gx_orig.^2 + gy_orig.^2);
            
            methods_gray = {nearest_gray, bilinear_gray, bicubic_gray};
            method_names = {'Nearest', 'Bilinear', 'Bicubic'};
            
            fprintf('Method\t\tEdge Strength\tSharpness\n');
            fprintf('--------------------------------------\n');
            
            for i = 1:length(methods_gray)
                [gx, gy] = gradient(double(methods_gray{i}));
                grad_mag = sqrt(gx.^2 + gy.^2);
                edge_strength = mean(grad_mag(:));
                sharpness = std(double(methods_gray{i}(:)));
                
                fprintf('%-10s\t%.2f\t\t%.2f\n', method_names{i}, edge_strength, sharpness);
            end
        end
        
        % Save results
        [~, name, ~] = fileparts(image_path);
        imwrite(img_nearest, sprintf('Lab2/images/interp_nearest_%s_%.1fx.jpg', name, scale_factor));
        imwrite(img_bilinear, sprintf('Lab2/images/interp_bilinear_%s_%.1fx.jpg', name, scale_factor));
        imwrite(img_bicubic, sprintf('Lab2/images/interp_bicubic_%s_%.1fx.jpg', name, scale_factor));
        
        fprintf('\nInterpolated images saved to Lab2/images/ directory\n');
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end

% Custom nearest neighbor interpolation implementation
function resized_img = nearest_neighbor_resize(img, new_height, new_width)
    [orig_height, orig_width, channels] = size(img);
    
    % Calculate scaling factors
    scale_y = orig_height / new_height;
    scale_x = orig_width / new_width;
    
    % Create output image
    resized_img = zeros(new_height, new_width, channels, class(img));
    
    % Perform nearest neighbor interpolation
    for y = 1:new_height
        for x = 1:new_width
            % Find nearest pixel in original image
            orig_y = round(y * scale_y);
            orig_x = round(x * scale_x);
            
            % Ensure coordinates are within bounds
            orig_y = max(1, min(orig_y, orig_height));
            orig_x = max(1, min(orig_x, orig_width));
            
            % Copy pixel value
            resized_img(y, x, :) = img(orig_y, orig_x, :);
        end
    end
end