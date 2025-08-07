% Q8: Camera Capture with Parameter Adjustment
% This function captures images from connected camera devices with adjustable parameters

function captured_img = Q8_camera_capture(camera_id, brightness, contrast)
    if nargin < 3
        contrast = 50;    % Default contrast (0-100)
    end
    if nargin < 2
        brightness = 50;  % Default brightness (0-100)
    end
    if nargin < 1
        camera_id = 1;    % Default camera ID
    end
    
    fprintf('=== Q8: Camera Capture with Parameter Adjustment ===\n\n');
    
    captured_img = [];
    
    try
        % Check if image acquisition packages are available
        available_packages = pkg('list');
        has_image_pkg = false;
        has_video_pkg = false;
        
        for i = 1:length(available_packages)
            if strcmp(available_packages{i}.name, 'image')
                has_image_pkg = available_packages{i}.loaded;
            elseif strcmp(available_packages{i}.name, 'video')
                has_video_pkg = available_packages{i}.loaded;
            end
        end
        
        fprintf('System capability check:\n');
        fprintf('Image package available: %s\n', char(has_image_pkg + '0'));
        fprintf('Video package available: %s\n', char(has_video_pkg + '0'));
        
        % Method 1: Try Octave video package (if available)
        if has_video_pkg
            fprintf('\nAttempting camera capture using video package...\n');
            try
                captured_img = capture_with_video_package(camera_id, brightness, contrast);
                if ~isempty(captured_img)
                    fprintf('✓ Camera capture successful using video package\n');
                    display_captured_image(captured_img, 'Video Package Capture');
                    return;
                end
            catch ME
                fprintf('Video package method failed: %s\n', ME.message);
            end
        end
        
        % Method 2: Try system camera commands
        fprintf('\nAttempting camera capture using system commands...\n');
        try
            captured_img = capture_with_system_commands(brightness, contrast);
            if ~isempty(captured_img)
                fprintf('✓ Camera capture successful using system commands\n');
                display_captured_image(captured_img, 'System Command Capture');
                return;
            end
        catch ME
            fprintf('System command method failed: %s\n', ME.message);
        end
        
        % Method 3: Generate simulated camera capture for demonstration
        fprintf('\nNo camera available. Generating simulated capture...\n');
        captured_img = generate_simulated_capture(brightness, contrast);
        display_captured_image(captured_img, 'Simulated Camera Capture');
        
        % Demonstrate parameter adjustment effects
        demonstrate_parameter_effects(captured_img, brightness, contrast);
        
    catch ME
        fprintf('Error in camera capture: %s\n', ME.message);
        
        % Fallback: Create a test pattern
        captured_img = create_test_pattern();
        fprintf('Created test pattern as fallback\n');
    end
    
    % Save the captured/simulated image
    if ~isempty(captured_img)
        timestamp = datestr(now, 'yyyymmdd_HHMMSS');
        filename = sprintf('images/captured_image_%s.jpg', timestamp);
        imwrite(captured_img, filename);
        fprintf('Image saved to: %s\n', filename);
    end
end

% Attempt capture using video package
function img = capture_with_video_package(camera_id, brightness, contrast)
    img = [];
    try
        % This would work if video package is properly installed
        % obj = videoinput('winvideo', camera_id);
        % set(obj, 'Brightness', brightness);
        % set(obj, 'Contrast', contrast);
        % start(obj);
        % img = getsnapshot(obj);
        % stop(obj);
        % delete(obj);
        
        fprintf('Video package capture not implemented (requires specific hardware setup)\n');
    catch
        % Package not available or hardware not connected
    end
end

% Attempt capture using system commands
function img = capture_with_system_commands(brightness, contrast)
    img = [];
    
    try
        % Try different system commands based on OS
        if ispc()
            % Windows: Try using ffmpeg if available
            temp_file = 'temp_capture.jpg';
            cmd = sprintf('ffmpeg -f dshow -i video="USB Camera" -frames:v 1 -y %s', temp_file);
            [status, ~] = system(cmd);
            
            if status == 0 && exist(temp_file, 'file')
                img = imread(temp_file);
                delete(temp_file);
                
                % Apply brightness and contrast adjustments
                img = adjust_image_parameters(img, brightness, contrast);
            end
            
        elseif ismac()
            % macOS: Try using imagesnap if available
            temp_file = 'temp_capture.jpg';
            cmd = sprintf('imagesnap %s', temp_file);
            [status, ~] = system(cmd);
            
            if status == 0 && exist(temp_file, 'file')
                img = imread(temp_file);
                delete(temp_file);
                
                % Apply brightness and contrast adjustments
                img = adjust_image_parameters(img, brightness, contrast);
            end
            
        else
            % Linux: Try using fswebcam if available
            temp_file = 'temp_capture.jpg';
            cmd = sprintf('fswebcam -r 640x480 --jpeg 95 %s', temp_file);
            [status, ~] = system(cmd);
            
            if status == 0 && exist(temp_file, 'file')
                img = imread(temp_file);
                delete(temp_file);
                
                % Apply brightness and contrast adjustments
                img = adjust_image_parameters(img, brightness, contrast);
            end
        end
        
    catch
        % System commands failed
    end
end

% Generate simulated camera capture for demonstration
function img = generate_simulated_capture(brightness, contrast)
    % Create a realistic simulated camera capture
    fprintf('Generating simulated camera capture...\n');
    
    % Load a sample image if available, otherwise create synthetic scene
    try
        % Try to load an existing test image
        if exist('images/test_images/portrait.png', 'file')
            img = imread('images/test_images/portrait.png');
        elseif exist('images/test_images/landscape.jpg', 'file')
            img = imread('images/test_images/landscape.jpg');
        else
            % Create synthetic scene
            img = create_synthetic_scene();
        end
    catch
        img = create_synthetic_scene();
    end
    
    % Resize to typical camera resolution
    img = imresize(img, [480, 640]);
    
    % Add camera-like effects
    img = add_camera_effects(img);
    
    % Apply brightness and contrast adjustments
    img = adjust_image_parameters(img, brightness, contrast);
    
    fprintf('Simulated capture parameters:\n');
    fprintf('  Resolution: 640x480\n');
    fprintf('  Brightness: %d%%\n', brightness);
    fprintf('  Contrast: %d%%\n', contrast);
end

% Create synthetic scene for testing
function img = create_synthetic_scene()
    % Create a colorful test scene
    [X, Y] = meshgrid(1:640, 1:480);
    
    % Create RGB channels with different patterns
    R = uint8(128 + 64 * sin(X/50) .* cos(Y/40));
    G = uint8(128 + 64 * cos(X/30) .* sin(Y/60));
    B = uint8(128 + 64 * sin(X/40) .* cos(Y/50));
    
    img = cat(3, R, G, B);
    
    % Add some geometric shapes
    center_x = 320;
    center_y = 240;
    
    % Add a circle
    [X, Y] = meshgrid(1:640, 1:480);
    circle_mask = (X - center_x).^2 + (Y - center_y).^2 < 50^2;
    img(repmat(circle_mask, [1, 1, 3])) = 255;
    
    % Add some rectangles
    img(100:150, 100:200, :) = 0;      % Black rectangle
    img(300:350, 400:500, 1) = 255;   % Red rectangle
    img(300:350, 400:500, 2:3) = 0;
end

% Add realistic camera effects
function img = add_camera_effects(img)
    % Convert to double for processing
    img_double = double(img) / 255;
    
    % Add slight vignetting effect
    [h, w, ~] = size(img_double);
    [X, Y] = meshgrid(1:w, 1:h);
    center_x = w / 2;
    center_y = h / 2;
    
    % Create vignetting mask
    max_dist = sqrt((w/2)^2 + (h/2)^2);
    dist = sqrt((X - center_x).^2 + (Y - center_y).^2);
    vignette = 1 - 0.3 * (dist / max_dist).^2;
    
    % Apply vignetting
    for c = 1:size(img_double, 3)
        img_double(:, :, c) = img_double(:, :, c) .* vignette;
    end
    
    % Add slight noise
    noise = 0.02 * randn(size(img_double));
    img_double = img_double + noise;
    
    % Clamp values and convert back
    img_double = max(0, min(1, img_double));
    img = uint8(img_double * 255);
end

% Adjust brightness and contrast
function img = adjust_image_parameters(img, brightness, contrast)
    % Convert to double for processing
    img_double = double(img) / 255;
    
    % Adjust brightness (0-100 scale to -0.5 to +0.5)
    brightness_factor = (brightness - 50) / 100;
    img_double = img_double + brightness_factor;
    
    % Adjust contrast (0-100 scale to 0.5 to 2.0)
    contrast_factor = contrast / 50;
    img_double = (img_double - 0.5) * contrast_factor + 0.5;
    
    % Clamp values and convert back
    img_double = max(0, min(1, img_double));
    img = uint8(img_double * 255);
end

% Display captured image with information
function display_captured_image(img, title_str)
    figure('Name', sprintf('Q8: %s', title_str), 'Position', [100, 100, 800, 600]);
    
    imshow(img);
    title(title_str);
    
    % Add image information
    [h, w, c] = size(img);
    info_str = sprintf('Resolution: %dx%d, Channels: %d', w, h, c);
    xlabel(info_str);
end

% Demonstrate parameter adjustment effects
function demonstrate_parameter_effects(base_img, current_brightness, current_contrast)
    fprintf('\n=== Parameter Adjustment Demonstration ===\n');
    
    % Create variations of the image with different parameters
    brightness_values = [25, 50, 75];  % Low, normal, high
    contrast_values = [25, 50, 75];    % Low, normal, high
    
    figure('Name', 'Q8: Parameter Adjustment Effects', 'Position', [50, 50, 1200, 800]);
    
    subplot_idx = 1;
    
    for i = 1:length(brightness_values)
        for j = 1:length(contrast_values)
            adjusted_img = adjust_image_parameters(base_img, brightness_values(i), contrast_values(j));
            
            subplot(3, 3, subplot_idx);
            imshow(adjusted_img);
            title(sprintf('B:%d%%, C:%d%%', brightness_values(i), contrast_values(j)));
            
            % Highlight current settings
            if brightness_values(i) == current_brightness && contrast_values(j) == current_contrast
                set(gca, 'XColor', 'red', 'YColor', 'red', 'LineWidth', 3);
            end
            
            subplot_idx = subplot_idx + 1;
        end
    end
    
    % Analysis of parameter effects
    fprintf('Brightness adjustment effects:\n');
    fprintf('  Low (25%%):  Darker image, may lose detail in shadows\n');
    fprintf('  Normal (50%%): Balanced exposure\n');
    fprintf('  High (75%%):  Brighter image, may lose detail in highlights\n\n');
    
    fprintf('Contrast adjustment effects:\n');
    fprintf('  Low (25%%):  Flat, washed-out appearance\n');
    fprintf('  Normal (50%%): Balanced contrast\n');
    fprintf('  High (75%%):  Enhanced contrast, more dramatic shadows/highlights\n\n');
    
    fprintf('Current settings: Brightness=%d%%, Contrast=%d%%\n', current_brightness, current_contrast);
end

% Create test pattern for fallback
function img = create_test_pattern()
    % Create a standard test pattern
    img = zeros(480, 640, 3, 'uint8');
    
    % Color bars
    bar_width = 640 / 7;
    colors = [
        255, 255, 255;  % White
        255, 255, 0;    % Yellow
        0, 255, 255;    % Cyan
        0, 255, 0;      % Green
        255, 0, 255;    % Magenta
        255, 0, 0;      % Red
        0, 0, 255       % Blue
    ];
    
    for i = 1:7
        start_col = round((i-1) * bar_width) + 1;
        end_col = round(i * bar_width);
        img(:, start_col:end_col, :) = repmat(reshape(colors(i, :), [1, 1, 3]), [480, end_col-start_col+1, 1]);
    end
    
    % Add test patterns in lower portion
    img(400:480, :, :) = 128;  % Gray background
    
    % Add some text-like patterns
    img(420:440, 50:150, :) = 0;    % Black rectangle
    img(420:440, 200:300, :) = 255; % White rectangle
end

% Camera setup instructions
function display_camera_setup_instructions()
    fprintf('\n=== Camera Setup Instructions ===\n');
    fprintf('For actual camera capture, ensure:\n\n');
    
    fprintf('1. Hardware Requirements:\n');
    fprintf('   - USB camera or built-in webcam\n');
    fprintf('   - Proper drivers installed\n');
    fprintf('   - Camera permissions granted\n\n');
    
    fprintf('2. Software Requirements:\n');
    fprintf('   - Octave video package: pkg install -forge video\n');
    fprintf('   - Image package: pkg install -forge image\n');
    fprintf('   - Alternative: ffmpeg, imagesnap, or fswebcam\n\n');
    
    fprintf('3. Testing Camera Access:\n');
    fprintf('   - Windows: Camera app or Device Manager\n');
    fprintf('   - macOS: Photo Booth or System Preferences\n');
    fprintf('   - Linux: cheese, guvcview, or v4l2-ctl\n\n');
    
    fprintf('4. Troubleshooting:\n');
    fprintf('   - Check camera permissions in system settings\n');
    fprintf('   - Ensure camera is not being used by another application\n');
    fprintf('   - Try different camera IDs (0, 1, 2, etc.)\n');
    fprintf('   - Verify USB connection for external cameras\n');
end