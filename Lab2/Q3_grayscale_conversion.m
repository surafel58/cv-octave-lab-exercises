% Q3: Different Methods of Grayscale Conversion
% This function implements and compares different grayscale conversion methods

function Q3_grayscale_conversion(image_path)
    if nargin < 1
        image_path = 'images/test_images/colorful.jpg';
    end
    
    fprintf('=== Q3: Grayscale Conversion Methods Comparison ===\n\n');
    
    try
        % Load color image
        color_img = imread(image_path);
        
        if size(color_img, 3) ~= 3
            error('Input image must be a color (RGB) image');
        end
        
        fprintf('Processing image: %s\n', image_path);
        fprintf('Image dimensions: %dx%dx%d\n', size(color_img));
        
        % Convert to double for calculations
        img_double = double(color_img);
        
        % Method 1: Average Method
        gray_average = uint8(mean(img_double, 3));
        
        % Method 2: Luminosity Method (standard RGB to grayscale)
        % Using standard luminosity weights: R=0.299, G=0.587, B=0.114
        gray_luminosity = uint8(0.299 * img_double(:,:,1) + ...
                               0.587 * img_double(:,:,2) + ...
                               0.114 * img_double(:,:,3));
        
        % Method 3: Desaturation Method (average of min and max)
        img_min = min(img_double, [], 3);
        img_max = max(img_double, [], 3);
        gray_desaturation = uint8((img_min + img_max) / 2);
        
        % Method 4: Single Channel Methods
        gray_red = img_double(:,:,1);
        gray_green = img_double(:,:,2);
        gray_blue = img_double(:,:,3);
        
        % Method 5: Weighted Average (custom weights)
        gray_custom = uint8(0.25 * img_double(:,:,1) + ...
                           0.50 * img_double(:,:,2) + ...
                           0.25 * img_double(:,:,3));
        
        % Method 6: Octave built-in function
        gray_builtin = rgb2gray(color_img);
        
        % Display results
        figure('Name', 'Q3: Grayscale Conversion Methods', 'Position', [50, 50, 1400, 800]);
        
        % Original color image
        subplot(3, 3, 1);
        imshow(color_img);
        title('Original Color Image');
        
        % Different grayscale methods
        subplot(3, 3, 2);
        imshow(gray_average);
        title('Average Method');
        
        subplot(3, 3, 3);
        imshow(gray_luminosity);
        title('Luminosity Method');
        
        subplot(3, 3, 4);
        imshow(gray_desaturation);
        title('Desaturation Method');
        
        subplot(3, 3, 5);
        imshow(uint8(gray_red));
        title('Red Channel Only');
        
        subplot(3, 3, 6);
        imshow(uint8(gray_green));
        title('Green Channel Only');
        
        subplot(3, 3, 7);
        imshow(uint8(gray_blue));
        title('Blue Channel Only');
        
        subplot(3, 3, 8);
        imshow(gray_custom);
        title('Custom Weighted');
        
        subplot(3, 3, 9);
        imshow(gray_builtin);
        title('Octave Built-in');
        
        % Analysis and comparison
        fprintf('\n=== Method Analysis ===\n');
        
        % Calculate statistics for each method
        methods = {'Average', 'Luminosity', 'Desaturation', 'Red Channel', ...
                  'Green Channel', 'Blue Channel', 'Custom Weighted', 'Built-in'};
        images = {gray_average, gray_luminosity, gray_desaturation, uint8(gray_red), ...
                 uint8(gray_green), uint8(gray_blue), gray_custom, gray_builtin};
        
        fprintf('Method\t\t\tMean\tStd\tMin\tMax\n');
        fprintf('----------------------------------------\n');
        
        for i = 1:length(methods)
            img_stats = double(images{i});
            mean_val = mean(img_stats(:));
            std_val = std(img_stats(:));
            min_val = min(img_stats(:));
            max_val = max(img_stats(:));
            
            fprintf('%-15s\t%.1f\t%.1f\t%d\t%d\n', methods{i}, mean_val, std_val, min_val, max_val);
        end
        
        fprintf('\n=== Method Characteristics ===\n');
        fprintf('1. Average Method: Simple but may not preserve perceived brightness\n');
        fprintf('2. Luminosity Method: Best for human vision, preserves perceived brightness\n');
        fprintf('3. Desaturation Method: Maintains color intensity range\n');
        fprintf('4. Single Channels: Show specific color component information\n');
        fprintf('5. Custom Weighted: Allows fine-tuning for specific applications\n');
        fprintf('6. Built-in: Optimized implementation, usually uses luminosity method\n');
        
        % Save results
        [~, name, ~] = fileparts(image_path);
        imwrite(gray_luminosity, sprintf('images/gray_luminosity_%s.jpg', name));
        imwrite(gray_average, sprintf('images/gray_average_%s.jpg', name));
        imwrite(gray_desaturation, sprintf('images/gray_desaturation_%s.jpg', name));
        
        fprintf('\nGrayscale images saved to images/ directory\n');
        
    catch ME
        fprintf('ERROR: %s\n', ME.message);
    end
end