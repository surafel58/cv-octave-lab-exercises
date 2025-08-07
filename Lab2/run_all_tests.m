% Lab 2 - Computer Vision with Octave - Run All Tests
% This script tests all the functions implemented in Lab 2

fprintf('=======================================================\n');
fprintf('        LAB 2 - COMPUTER VISION COMPREHENSIVE TESTING\n');
fprintf('=======================================================\n\n');

% Check if images directory exists
if ~exist('images', 'dir')
    fprintf('WARNING: images/ directory not found. Creating sample images...\n');
    create_sample_images();
    fprintf('Sample images created in images/test_images/\n\n');
end

% Record start time
start_time = tic;
total_tests = 14;
passed_tests = 0;

fprintf('Starting Lab 2 comprehensive testing...\n');
fprintf('Total functions to test: %d\n\n', total_tests);

%% Test Q1: Image Import and Colormaps
fprintf('=== Q1: Image Import and Colormaps ===\n');
try
    Q1_image_import('images/test_images/');
    fprintf('✓ Q1 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q1 failed: %s\n\n', ME.message);
end

%% Test Q2: Image Resizing
fprintf('=== Q2: Image Resizing with Aspect Ratio ===\n');
try
    if exist('images/test_images/high_resolution.jpg', 'file')
        Q2_image_resize('images/test_images/high_resolution.jpg', 400, 300);
    else
        Q2_image_resize('images/test_images/landscape.jpg', 300, 200);
    end
    fprintf('✓ Q2 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q2 failed: %s\n\n', ME.message);
end

%% Test Q3: Grayscale Conversion Methods
fprintf('=== Q3: Grayscale Conversion Methods ===\n');
try
    if exist('images/test_images/colorful.jpg', 'file')
        Q3_grayscale_conversion('images/test_images/colorful.jpg');
    else
        Q3_grayscale_conversion('images/test_images/portrait.png');
    end
    fprintf('✓ Q3 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q3 failed: %s\n\n', ME.message);
end

%% Test Q4: Image Cropping
fprintf('=== Q4: Image Cropping ===\n');
try
    result = Q4_image_crop('images/test_images/landscape.jpg', [50, 50], [200, 150]);
    if ~isempty(result)
        fprintf('Crop result size: %dx%d\n', size(result, 2), size(result, 1));
    end
    fprintf('✓ Q4 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q4 failed: %s\n\n', ME.message);
end

%% Test Q5: Interpolation Techniques
fprintf('=== Q5: Interpolation Techniques ===\n');
try
    if exist('images/test_images/geometric.png', 'file')
        Q5_interpolation_techniques('images/test_images/geometric.png', 2.0);
    else
        Q5_interpolation_techniques('images/test_images/portrait.png', 1.5);
    end
    fprintf('✓ Q5 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q5 failed: %s\n\n', ME.message);
end

%% Test Q6: Image Rotation
fprintf('=== Q6: Image Rotation ===\n');
try
    result = Q6_image_rotation('images/test_images/geometric.png', 30);
    if ~isempty(result)
        fprintf('Rotation result size: %dx%d\n', size(result, 2), size(result, 1));
    end
    fprintf('✓ Q6 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q6 failed: %s\n\n', ME.message);
end

%% Test Q7: Image Download
fprintf('=== Q7: Image Download ===\n');
try
    % Test with a smaller set of URLs for faster testing
    test_urls = {'https://picsum.photos/200/150.jpg'};
    Q7_image_download(test_urls, 'Lab2/images/downloaded/');
    fprintf('✓ Q7 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q7 failed: %s\n\n', ME.message);
end

%% Test Q8: Camera Capture
fprintf('=== Q8: Camera Capture ===\n');
try
    result = Q8_camera_capture(1, 60, 55);  % Test with default camera
    if ~isempty(result)
        fprintf('Camera capture result size: %dx%d\n', size(result, 2), size(result, 1));
    end
    fprintf('✓ Q8 completed successfully (simulated capture)\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q8 failed: %s\n\n', ME.message);
end

%% Test Q9: Color Spaces
fprintf('=== Q9: Color Spaces Analysis ===\n');
try
    Q9_color_spaces('images/test_images/colorful.jpg');
    fprintf('✓ Q9 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q9 failed: %s\n\n', ME.message);
end

%% Test Q10: Image Metadata
fprintf('=== Q10: Image Metadata Extraction ===\n');
try
    metadata = Q10_image_metadata('images/test_images/with_metadata.jpg');
    if isstruct(metadata)
        fprintf('Metadata fields extracted: %d\n', length(fieldnames(metadata)));
    end
    fprintf('✓ Q10 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q10 failed: %s\n\n', ME.message);
end

%% Test Q11: Pixel Operations
fprintf('=== Q11: Pixel Mathematical Operations ===\n');
try
    Q11_pixel_operations('images/test_images/portrait.png');
    fprintf('✓ Q11 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q11 failed: %s\n\n', ME.message);
end

%% Test Q12: Resolution Analysis
fprintf('=== Q12: Resolution Comparison and Analysis ===\n');
try
    Q12_resolution_analysis('images/test_images/high_resolution.jpg', 'images/test_images/low_res.jpg');
    fprintf('✓ Q12 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q12 failed: %s\n\n', ME.message);
end

%% Test Q13: Color Space Processing
fprintf('=== Q13: Color Space Processing ===\n');
try
    Q13_colorspace_processing('images/test_images/colorful.jpg');
    fprintf('✓ Q13 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q13 failed: %s\n\n', ME.message);
end

%% Test Q14: Image Enhancement
fprintf('=== Q14: Image Enhancement Techniques ===\n');
try
    if exist('images/test_images/dark_image.jpg', 'file')
        Q14_image_enhancement('images/test_images/dark_image.jpg');
    else
        Q14_image_enhancement('images/test_images/portrait.png');
    end
    fprintf('✓ Q14 completed successfully\n\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('✗ Q14 failed: %s\n\n', ME.message);
end

%% Final Results
total_time = toc(start_time);

fprintf('=======================================================\n');
fprintf('                    FINAL RESULTS\n');
fprintf('=======================================================\n');
fprintf('Tests completed: %d/%d\n', passed_tests, total_tests);
fprintf('Success rate: %.1f%%\n', (passed_tests/total_tests)*100);
fprintf('Total execution time: %.1f seconds\n', total_time);

if passed_tests == total_tests
    fprintf('\n🎉 ALL TESTS PASSED! Excellent work!\n');
elseif passed_tests >= total_tests * 0.8
    fprintf('\n✅ Most tests passed! Good progress.\n');
else
    fprintf('\n⚠️  Several tests failed. Check error messages above.\n');
end

fprintf('\n=== Generated Files Summary ===\n');
list_generated_files();

fprintf('\n=== Lab 2 Computer Vision Features Summary ===\n');
display_features_summary();

fprintf('\n=======================================================\n');
fprintf('           LAB 2 TESTING COMPLETED\n');
fprintf('=======================================================\n');

%% Helper Functions

function create_sample_images()
    % Create sample images if they don't exist
    
    % Create directories
    if ~exist('images', 'dir')
        mkdir('images');
    end
    if ~exist('images/test_images', 'dir')
        mkdir('images/test_images');
    end
    
    fprintf('Creating sample images...\n');
    
    % Create a colorful test image
    [X, Y] = meshgrid(1:400, 1:300);
    R = uint8(128 + 64 * sin(X/30) .* cos(Y/20));
    G = uint8(128 + 64 * cos(X/25) .* sin(Y/35));
    B = uint8(128 + 64 * sin(X/20) .* cos(Y/30));
    colorful_img = cat(3, R, G, B);
    imwrite(colorful_img, 'images/test_images/colorful.jpg');
    
    % Create a portrait-like image
    portrait_img = create_synthetic_portrait(300, 400);
    imwrite(portrait_img, 'images/test_images/portrait.png');
    
    % Create a landscape image
    landscape_img = create_synthetic_landscape(500, 300);
    imwrite(landscape_img, 'images/test_images/landscape.jpg');
    
    % Create a geometric pattern
    geometric_img = create_geometric_pattern(256, 256);
    imwrite(geometric_img, 'images/test_images/geometric.png');
    
    % Create high resolution version
    high_res_img = imresize(landscape_img, 2);
    imwrite(high_res_img, 'images/test_images/high_resolution.jpg');
    
    % Create low resolution version
    low_res_img = imresize(landscape_img, 0.5);
    imwrite(low_res_img, 'images/test_images/low_res.jpg');
    
    % Create a dark image for enhancement testing
    dark_img = uint8(double(colorful_img) * 0.3);
    imwrite(dark_img, 'images/test_images/dark_image.jpg');
    
    % Create image with metadata (same as colorful but with different name)
    imwrite(colorful_img, 'images/test_images/with_metadata.jpg');
    
    % Create object image (simple shapes)
    object_img = create_simple_objects(300, 300);
    imwrite(object_img, 'images/test_images/object.bmp');
end

function img = create_synthetic_portrait(height, width)
    % Create a synthetic portrait-like image
    img = zeros(height, width, 3, 'uint8');
    
    % Background gradient
    [X, Y] = meshgrid(1:width, 1:height);
    background = 180 - 50 * sqrt((X - width/2).^2 + (Y - height/2).^2) / (width/2);
    background = max(100, min(200, background));
    
    % Face oval
    face_center_x = width / 2;
    face_center_y = height * 0.4;
    face_width = width * 0.3;
    face_height = height * 0.4;
    
    face_mask = ((X - face_center_x) / face_width).^2 + ((Y - face_center_y) / face_height).^2 < 1;
    
    % Fill image
    for c = 1:3
        channel = background;
        channel(face_mask) = 220 - c * 20;  % Skin tone
        img(:, :, c) = uint8(channel);
    end
end

function img = create_synthetic_landscape(width, height)
    % Create a synthetic landscape image
    [X, Y] = meshgrid(1:width, 1:height);
    
    % Sky (blue gradient)
    sky = Y / height;
    R_sky = 135 * (1 - sky) + 200 * sky;
    G_sky = 206 * (1 - sky) + 220 * sky;
    B_sky = 250 * ones(size(sky));
    
    % Ground (green with brown)
    ground_mask = Y > height * 0.6;
    R_ground = 34 * ones(size(X));
    G_ground = 139 * ones(size(X));
    B_ground = 34 * ones(size(X));
    
    % Mountains
    mountain_height = height * 0.4 + 50 * sin(X / width * 4 * pi);
    mountain_mask = Y < mountain_height;
    
    % Combine
    R = R_sky;
    G = G_sky;
    B = B_sky;
    
    R(mountain_mask) = 101;
    G(mountain_mask) = 67;
    B(mountain_mask) = 33;
    
    R(ground_mask) = R_ground(ground_mask);
    G(ground_mask) = G_ground(ground_mask);
    B(ground_mask) = B_ground(ground_mask);
    
    img = cat(3, uint8(R), uint8(G), uint8(B));
end

function img = create_geometric_pattern(width, height)
    % Create geometric pattern for rotation testing
    img = zeros(height, width, 3, 'uint8');
    
    % Create checkerboard pattern
    square_size = 32;
    [X, Y] = meshgrid(1:width, 1:height);
    checker = mod(floor(X/square_size) + floor(Y/square_size), 2);
    
    % Add some circles
    center1 = [width*0.3, height*0.3];
    center2 = [width*0.7, height*0.7];
    
    circle1 = (X - center1(1)).^2 + (Y - center1(2)).^2 < (width*0.1)^2;
    circle2 = (X - center2(1)).^2 + (Y - center2(2)).^2 < (width*0.08)^2;
    
    % Fill image
    R = checker * 255;
    G = checker * 255;
    B = checker * 255;
    
    R(circle1) = 255;
    G(circle1) = 0;
    B(circle1) = 0;
    
    R(circle2) = 0;
    G(circle2) = 255;
    B(circle2) = 0;
    
    img = cat(3, uint8(R), uint8(G), uint8(B));
end

function img = create_simple_objects(width, height)
    % Create simple objects for testing
    img = 200 * ones(height, width, 3, 'uint8');  % Light gray background
    
    [X, Y] = meshgrid(1:width, 1:height);
    
    % Rectangle
    rect_mask = (X > width*0.2) & (X < width*0.4) & (Y > height*0.3) & (Y < height*0.7);
    
    % Circle
    circle_center = [width*0.7, height*0.5];
    circle_mask = (X - circle_center(1)).^2 + (Y - circle_center(2)).^2 < (width*0.1)^2;
    
    % Fill objects
    img(repmat(rect_mask, [1, 1, 3])) = 50;   % Dark rectangle
    img(repmat(circle_mask, [1, 1, 3])) = 100; % Gray circle
end

function list_generated_files()
    % List files generated during testing
    
    directories = {'Lab2/images/', 'images/test_images/'};
    total_files = 0;
    
    for i = 1:length(directories)
        dir_path = directories{i};
        if exist(dir_path, 'dir')
            files = dir([dir_path, '*']);
            files = files(~[files.isdir]);  % Remove directories
            
            if ~isempty(files)
                fprintf('\n%s (%d files):\n', dir_path, length(files));
                for j = 1:min(10, length(files))  % Show first 10 files
                    fprintf('  %s\n', files(j).name);
                end
                if length(files) > 10
                    fprintf('  ... and %d more files\n', length(files) - 10);
                end
                total_files = total_files + length(files);
            end
        end
    end
    
    fprintf('\nTotal generated files: %d\n', total_files);
end

function display_features_summary()
    % Display summary of implemented features
    
    features = {
        'Q1: Multi-format image import with colormap visualization',
        'Q2: Aspect-ratio preserving image resizing',
        'Q3: Multiple grayscale conversion algorithms',
        'Q4: Region-of-interest image cropping',
        'Q5: Interpolation techniques comparison (nearest, bilinear, bicubic)',
        'Q6: Image rotation with automatic canvas adjustment',
        'Q7: URL-based image downloading with error handling',
        'Q8: Camera capture simulation with parameter adjustment',
        'Q9: Color space analysis (RGB, HSV, YCbCr, LAB)',
        'Q10: Comprehensive image metadata extraction',
        'Q11: Mathematical pixel operations and transformations',
        'Q12: Resolution impact analysis on processing performance',
        'Q13: Color space effects on edge detection and segmentation',
        'Q14: Advanced enhancement techniques (histogram, contrast, CLAHE, etc.)'
    };
    
    fprintf('\nImplemented Computer Vision Features:\n');
    for i = 1:length(features)
        fprintf('✓ %s\n', features{i});
    end
    
    fprintf('\nAdditional Features:\n');
    fprintf('• Comprehensive error handling and user feedback\n');
    fprintf('• Performance benchmarking and quality metrics\n');
    fprintf('• Interactive visualizations and comparisons\n');
    fprintf('• Automatic fallbacks for missing dependencies\n');
    fprintf('• Detailed documentation and recommendations\n');
    fprintf('• Modular design for easy extension\n');
end