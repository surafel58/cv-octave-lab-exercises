% Q4: Image Cropping Function
% This function crops an image to a specific region of interest

function cropped_img = Q4_image_crop(image_path, top_left, bottom_right)
    if nargin < 3
        % Default test parameters
        image_path = 'images/test_images/landscape.jpg';
        top_left = [100, 100];      % [x, y] coordinates
        bottom_right = [400, 300];  % [x, y] coordinates
    end
    
    fprintf('=== Q4: Image Cropping Function ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        [img_height, img_width, channels] = size(original_img);
        
        fprintf('Original image: %s\n', image_path);
        fprintf('Original dimensions: %dx%d (WxH)\n', img_width, img_height);
        fprintf('Channels: %d\n', channels);
        
        % Validate coordinates
        x1 = top_left(1);
        y1 = top_left(2);
        x2 = bottom_right(1);
        y2 = bottom_right(2);
        
        fprintf('Crop coordinates:\n');
        fprintf('  Top-left: (%d, %d)\n', x1, y1);
        fprintf('  Bottom-right: (%d, %d)\n', x2, y2);
        
        % Validate input coordinates
        if x1 >= x2 || y1 >= y2
            error('Invalid coordinates: top-left must be above and left of bottom-right');
        end
        
        if x1 < 1 || y1 < 1 || x2 > img_width || y2 > img_height
            error('Coordinates out of image bounds. Image size: %dx%d', img_width, img_height);
        end
        
        % Perform cropping
        % Note: In image indexing, rows correspond to y and columns to x
        cropped_img = original_img(y1:y2, x1:x2, :);
        
        [crop_height, crop_width, ~] = size(cropped_img);
        
        fprintf('Cropped dimensions: %dx%d (WxH)\n', crop_width, crop_height);
        fprintf('Crop area: %d pixels\n', crop_width * crop_height);
        
        % Display comparison
        figure('Name', 'Q4: Image Cropping', 'Position', [100, 100, 1200, 600]);
        
        % Original image with crop region highlighted
        subplot(1, 2, 1);
        imshow(original_img);
        hold on;
        % Draw rectangle showing crop region
        rectangle('Position', [x1, y1, x2-x1, y2-y1], 'EdgeColor', 'red', 'LineWidth', 2);
        title('Original with Crop Region');
        hold off;
        
        % Cropped image
        subplot(1, 2, 2);
        imshow(cropped_img);
        title(sprintf('Cropped Image (%dx%d)', crop_width, crop_height));
        
        % Calculate cropping statistics
        original_area = img_width * img_height;
        cropped_area = crop_width * crop_height;
        area_percentage = (cropped_area / original_area) * 100;
        
        fprintf('\n=== Cropping Analysis ===\n');
        fprintf('Original area: %d pixels\n', original_area);
        fprintf('Cropped area: %d pixels\n', cropped_area);
        fprintf('Area retained: %.1f%%\n', area_percentage);
        fprintf('Area reduction: %.1f%%\n', 100 - area_percentage);
        
        % Save cropped image
        [~, name, ext] = fileparts(image_path);
        output_path = sprintf('images/cropped_%s_%dx%d%s', name, crop_width, crop_height, ext);
        imwrite(cropped_img, output_path);
        fprintf('Cropped image saved to: %s\n', output_path);
        
        % Additional functionality: Interactive cropping helper
        fprintf('\n=== Interactive Cropping Helper ===\n');
        fprintf('For interactive cropping, you can:\n');
        fprintf('1. Use: [x, y, w, h] = imcrop(img) to select region interactively\n');
        fprintf('2. Then call: cropped = Q4_image_crop(path, [x, y], [x+w, y+h])\n');
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
        cropped_img = [];
    end
end

% Helper function for interactive cropping
function interactive_crop_demo(image_path)
    if nargin < 1
        image_path = 'images/test_images/landscape.jpg';
    end
    
    fprintf('=== Interactive Cropping Demo ===\n');
    fprintf('1. An image will be displayed\n');
    fprintf('2. Click and drag to select the crop region\n');
    fprintf('3. Double-click inside the selection to confirm\n');
    
    img = imread(image_path);
    figure('Name', 'Interactive Cropping - Select Region');
    [cropped, rect] = imcrop(img);
    
    if ~isempty(rect)
        x1 = round(rect(1));
        y1 = round(rect(2));
        x2 = round(rect(1) + rect(3));
        y2 = round(rect(2) + rect(4));
        
        fprintf('Selected coordinates: [%d, %d] to [%d, %d]\n', x1, y1, x2, y2);
        
        % Now use the regular cropping function
        result = Q4_image_crop(image_path, [x1, y1], [x2, y2]);
    end
end