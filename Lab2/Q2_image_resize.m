% Q2: Image Resizing with Aspect Ratio Maintenance
% This function resizes an image to specified dimensions while maintaining aspect ratio

function Q2_image_resize(image_path, target_width, target_height)
    if nargin < 3
        % Default test parameters
        image_path = 'images/test_images/high_resolution.jpg';
        target_width = 400;
        target_height = 300;
    end
    
    fprintf('=== Q2: Image Resizing with Aspect Ratio Maintenance ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        [orig_height, orig_width, channels] = size(original_img);
        
        fprintf('Original image: %s\n', image_path);
        fprintf('Original dimensions: %dx%d (WxH)\n', orig_width, orig_height);
        fprintf('Target dimensions: %dx%d (WxH)\n', target_width, target_height);
        
        % Calculate aspect ratios
        orig_aspect = orig_width / orig_height;
        target_aspect = target_width / target_height;
        
        fprintf('Original aspect ratio: %.3f\n', orig_aspect);
        fprintf('Target aspect ratio: %.3f\n', target_aspect);
        
        % Calculate new dimensions maintaining aspect ratio
        if orig_aspect > target_aspect
            % Image is wider, fit to width
            new_width = target_width;
            new_height = round(target_width / orig_aspect);
        else
            % Image is taller, fit to height
            new_height = target_height;
            new_width = round(target_height * orig_aspect);
        end
        
        fprintf('Calculated new dimensions: %dx%d (WxH)\n', new_width, new_height);
        
        % Resize image
        resized_img = imresize(original_img, [new_height, new_width]);
        
        % Display comparison
        figure('Name', 'Q2: Image Resizing Comparison', 'Position', [100, 100, 1200, 600]);
        
        % Original image
        subplot(1, 2, 1);
        imshow(original_img);
        title(sprintf('Original: %dx%d', orig_width, orig_height));
        
        % Resized image
        subplot(1, 2, 2);
        imshow(resized_img);
        title(sprintf('Resized: %dx%d', new_width, new_height));
        
        % Quality analysis
        fprintf('\n=== Quality Analysis ===\n');
        
        % Calculate compression ratio
        compression_ratio = (orig_width * orig_height) / (new_width * new_height);
        fprintf('Compression ratio: %.2fx\n', compression_ratio);
        
        % Resolution comparison
        orig_pixels = orig_width * orig_height;
        new_pixels = new_width * new_height;
        fprintf('Original pixels: %d\n', orig_pixels);
        fprintf('Resized pixels: %d\n', new_pixels);
        fprintf('Pixel reduction: %.1f%%\n', (1 - new_pixels/orig_pixels) * 100);
        
        % Quality assessment (basic)
        if compression_ratio > 4
            quality = 'Significant quality loss expected';
        elseif compression_ratio > 2
            quality = 'Moderate quality loss';
        else
            quality = 'Minimal quality loss';
        end
        fprintf('Quality assessment: %s\n', quality);
        
        % Save resized image
        [~, name, ~] = fileparts(image_path);
        
        % Save to existing images folder
        output_path = sprintf('images/resized_%s_%dx%d.jpg', name, new_width, new_height);
        try
            imwrite(resized_img, output_path);
            fprintf('Resized image saved to: %s\n', output_path);
        catch ME
            fprintf('Warning: Could not save resized image: %s\n', ME.message);
            fprintf('Image processing completed successfully, but file save failed.\n');
        end
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end