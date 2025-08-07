% Q6: Image Rotation Function
% This function rotates an image by any specified angle and handles size changes

function rotated_img = Q6_image_rotation(image_path, angle_degrees, method)
    if nargin < 3
        method = 'bilinear';  % Default interpolation method
    end
    if nargin < 2
        angle_degrees = 45;   % Default rotation angle
    end
    if nargin < 1
        image_path = 'images/test_images/geometric.png';
    end
    
    fprintf('=== Q6: Image Rotation Function ===\n\n');
    
    try
        % Load original image
        original_img = imread(image_path);
        [orig_height, orig_width, channels] = size(original_img);
        
        fprintf('Original image: %s\n', image_path);
        fprintf('Original dimensions: %dx%d (WxH)\n', orig_width, orig_height);
        fprintf('Rotation angle: %.1f degrees\n', angle_degrees);
        fprintf('Interpolation method: %s\n', method);
        
        % Method 1: Built-in rotation (crops to original size)
        rotated_cropped = imrotate(original_img, angle_degrees, method, 'crop');
        
        % Method 2: Built-in rotation (loose - expands canvas)
        rotated_loose = imrotate(original_img, angle_degrees, method, 'loose');
        
        % Method 3: Custom rotation with manual size calculation
        [rotated_custom, new_corners] = custom_rotate_image(original_img, angle_degrees);
        
        % Get dimensions of rotated images
        [crop_h, crop_w, ~] = size(rotated_cropped);
        [loose_h, loose_w, ~] = size(rotated_loose);
        [custom_h, custom_w, ~] = size(rotated_custom);
        
        fprintf('\n=== Size Analysis ===\n');
        fprintf('Original size: %dx%d\n', orig_width, orig_height);
        fprintf('Cropped rotation: %dx%d (maintains original size)\n', crop_w, crop_h);
        fprintf('Loose rotation: %dx%d (expanded canvas)\n', loose_w, loose_h);
        fprintf('Custom rotation: %dx%d (calculated canvas)\n', custom_w, custom_h);
        
        % Calculate aspect ratio changes
        orig_aspect = orig_width / orig_height;
        loose_aspect = loose_w / loose_h;
        
        fprintf('\nAspect ratio analysis:\n');
        fprintf('Original aspect ratio: %.3f\n', orig_aspect);
        fprintf('Loose rotation aspect ratio: %.3f\n', loose_aspect);
        fprintf('Aspect ratio change: %.3f\n', abs(orig_aspect - loose_aspect));
        
        % Display results
        figure('Name', 'Q6: Image Rotation Comparison', 'Position', [50, 50, 1600, 800]);
        
        % Original image
        subplot(2, 3, 1);
        imshow(original_img);
        title('Original Image');
        rectangle('Position', [1, 1, orig_width-1, orig_height-1], 'EdgeColor', 'red', 'LineWidth', 2);
        
        % Cropped rotation
        subplot(2, 3, 2);
        imshow(rotated_cropped);
        title(sprintf('Cropped Rotation\n%dx%d', crop_w, crop_h));
        
        % Loose rotation
        subplot(2, 3, 3);
        imshow(rotated_loose);
        title(sprintf('Loose Rotation\n%dx%d', loose_w, loose_h));
        
        % Custom rotation
        subplot(2, 3, 4);
        imshow(rotated_custom);
        title(sprintf('Custom Rotation\n%dx%d', custom_w, custom_h));
        
        % Corner analysis visualization
        subplot(2, 3, 5);
        visualize_rotation_geometry(orig_width, orig_height, angle_degrees);
        title('Rotation Geometry');
        
        % Quality comparison (if angle is not too extreme)
        subplot(2, 3, 6);
        if abs(angle_degrees) <= 45
            % Show detail comparison
            detail_region = get_detail_region(rotated_loose, 0.3);
            imshow(detail_region);
            title('Detail Region');
        else
            % Show overlay comparison
            overlay = create_rotation_overlay(original_img, rotated_loose);
            imshow(overlay);
            title('Rotation Overlay');
        end
        
        % Mathematical analysis
        fprintf('\n=== Mathematical Analysis ===\n');
        angle_rad = deg2rad(angle_degrees);
        
        % Calculate new bounding box corners
        corners = [0, 0; orig_width, 0; orig_width, orig_height; 0, orig_height];
        center_x = orig_width / 2;
        center_y = orig_height / 2;
        
        % Translate to origin, rotate, translate back
        rotated_corners = zeros(4, 2);
        for i = 1:4
            x = corners(i, 1) - center_x;
            y = corners(i, 2) - center_y;
            
            rotated_corners(i, 1) = x * cos(angle_rad) - y * sin(angle_rad) + center_x;
            rotated_corners(i, 2) = x * sin(angle_rad) + y * cos(angle_rad) + center_y;
        end
        
        new_min_x = min(rotated_corners(:, 1));
        new_max_x = max(rotated_corners(:, 1));
        new_min_y = min(rotated_corners(:, 2));
        new_max_y = max(rotated_corners(:, 2));
        
        calculated_width = ceil(new_max_x - new_min_x);
        calculated_height = ceil(new_max_y - new_min_y);
        
        fprintf('Calculated new dimensions: %dx%d\n', calculated_width, calculated_height);
        fprintf('Actual loose dimensions: %dx%d\n', loose_w, loose_h);
        
        % Area analysis
        orig_area = orig_width * orig_height;
        loose_area = loose_w * loose_h;
        area_increase = (loose_area - orig_area) / orig_area * 100;
        
        fprintf('Original area: %d pixels\n', orig_area);
        fprintf('Rotated area: %d pixels\n', loose_area);
        fprintf('Area increase: %.1f%%\n', area_increase);
        
        % Save rotated images
        [~, name, ~] = fileparts(image_path);
        imwrite(rotated_cropped, sprintf('Lab2/images/rotated_crop_%s_%.0fdeg.jpg', name, angle_degrees));
        imwrite(rotated_loose, sprintf('Lab2/images/rotated_loose_%s_%.0fdeg.jpg', name, angle_degrees));
        
        fprintf('\nRotated images saved to Lab2/images/ directory\n');
        
        % Return the loose rotation as default
        rotated_img = rotated_loose;
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
        rotated_img = [];
    end
end

% Custom rotation implementation with size calculation
function [rotated_img, corners] = custom_rotate_image(img, angle_degrees)
    [height, width, channels] = size(img);
    angle_rad = deg2rad(angle_degrees);
    
    % Calculate new image size
    cos_a = abs(cos(angle_rad));
    sin_a = abs(sin(angle_rad));
    
    new_width = ceil(width * cos_a + height * sin_a);
    new_height = ceil(width * sin_a + height * cos_a);
    
    % Create transformation matrix
    center_x = width / 2;
    center_y = height / 2;
    new_center_x = new_width / 2;
    new_center_y = new_height / 2;
    
    % Initialize output image
    rotated_img = zeros(new_height, new_width, channels, class(img));
    
    % Perform rotation using inverse mapping
    for y = 1:new_height
        for x = 1:new_width
            % Translate to origin of new image
            x_new = x - new_center_x;
            y_new = y - new_center_y;
            
            % Inverse rotation
            x_orig = x_new * cos(-angle_rad) - y_new * sin(-angle_rad) + center_x;
            y_orig = x_new * sin(-angle_rad) + y_new * cos(-angle_rad) + center_y;
            
            % Check bounds and interpolate
            if x_orig >= 1 && x_orig <= width && y_orig >= 1 && y_orig <= height
                % Simple nearest neighbor interpolation
                x_idx = round(x_orig);
                y_idx = round(y_orig);
                
                x_idx = max(1, min(x_idx, width));
                y_idx = max(1, min(y_idx, height));
                
                rotated_img(y, x, :) = img(y_idx, x_idx, :);
            end
        end
    end
    
    corners = [new_width, new_height];
end

% Visualize rotation geometry
function visualize_rotation_geometry(width, height, angle_degrees)
    angle_rad = deg2rad(angle_degrees);
    
    % Original rectangle corners
    corners = [0, 0; width, 0; width, height; 0, height; 0, 0];
    
    % Rotation center
    center_x = width / 2;
    center_y = height / 2;
    
    % Rotated corners
    rotated_corners = zeros(size(corners));
    for i = 1:size(corners, 1)
        x = corners(i, 1) - center_x;
        y = corners(i, 2) - center_y;
        
        rotated_corners(i, 1) = x * cos(angle_rad) - y * sin(angle_rad) + center_x;
        rotated_corners(i, 2) = x * sin(angle_rad) + y * cos(angle_rad) + center_y;
    end
    
    % Plot
    plot(corners(:, 1), corners(:, 2), 'b-', 'LineWidth', 2);
    hold on;
    plot(rotated_corners(:, 1), rotated_corners(:, 2), 'r-', 'LineWidth', 2);
    plot(center_x, center_y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
    
    % Calculate and show bounding box
    min_x = min(rotated_corners(:, 1));
    max_x = max(rotated_corners(:, 1));
    min_y = min(rotated_corners(:, 2));
    max_y = max(rotated_corners(:, 2));
    
    bbox = [min_x, min_y; max_x, min_y; max_x, max_y; min_x, max_y; min_x, min_y];
    plot(bbox(:, 1), bbox(:, 2), 'g--', 'LineWidth', 1);
    
    axis equal;
    grid on;
    legend('Original', 'Rotated', 'Center', 'Bounding Box');
    xlabel('X (pixels)');
    ylabel('Y (pixels)');
    hold off;
end

% Get detail region for quality comparison
function detail = get_detail_region(img, scale)
    [h, w, ~] = size(img);
    crop_h = round(h * scale);
    crop_w = round(w * scale);
    
    start_y = round((h - crop_h) / 2);
    start_x = round((w - crop_w) / 2);
    
    detail = img(start_y:(start_y + crop_h - 1), start_x:(start_x + crop_w - 1), :);
end

% Create rotation overlay for comparison
function overlay = create_rotation_overlay(original, rotated)
    % Resize images to same size for comparison
    [h1, w1, ~] = size(original);
    [h2, w2, ~] = size(rotated);
    
    target_h = min(h1, h2);
    target_w = min(w1, w2);
    
    orig_resized = imresize(original, [target_h, target_w]);
    rot_resized = imresize(rotated, [target_h, target_w]);
    
    % Create overlay (50% transparency)
    overlay = uint8(0.5 * double(orig_resized) + 0.5 * double(rot_resized));
end