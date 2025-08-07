% Q1: Image Import with Different Formats and Colormaps
% This function imports multiple images in different formats and displays them with various colormaps

function Q1_image_import(image_dir)
    if nargin < 1
        image_dir = 'images/test_images/';
    end
    
    % Define supported formats and their extensions
    formats = {'png', 'jpg', 'jpeg', 'bmp', 'tiff', 'gif'};
    colormaps = {'gray', 'hot', 'jet', 'cool', 'spring', 'autumn'};
    
    fprintf('=== Q1: Image Import and Colormap Analysis ===\n\n');
    
    % Get list of image files
    image_files = {};
    file_formats = {};
    
    for i = 1:length(formats)
        pattern = sprintf('%s*.%s', image_dir, formats{i});
        files = dir(pattern);
        for j = 1:length(files)
            image_files{end+1} = fullfile(image_dir, files(j).name);
            file_formats{end+1} = upper(formats{i});
        end
    end
    
    if isempty(image_files)
        error('No images found in directory: %s', image_dir);
    end
    
    fprintf('Found %d images to process:\n', length(image_files));
    
    % Process each image
    for i = 1:length(image_files)
        try
            fprintf('\n--- Processing: %s (Format: %s) ---\n', ...
                    image_files{i}, file_formats{i});
            
            % Import image
            img = imread(image_files{i});
            [rows, cols, channels] = size(img);
            
            fprintf('Image dimensions: %dx%d, Channels: %d\n', rows, cols, channels);
            fprintf('Data type: %s\n', class(img));
            
            % Convert to grayscale for colormap demonstration
            if channels == 3
                gray_img = rgb2gray(img);
                fprintf('Converted to grayscale for colormap demonstration\n');
            else
                gray_img = img;
                fprintf('Already grayscale\n');
            end
            
            % Display with different colormaps
            figure('Name', sprintf('Image %d: %s', i, file_formats{i}), ...
                   'Position', [100 + (i-1)*50, 100 + (i-1)*50, 1200, 400]);
            
            for j = 1:min(4, length(colormaps))
                subplot(1, 4, j);
                imshow(gray_img);
                colormap(colormaps{j});
                title(sprintf('%s colormap', colormaps{j}));
                colorbar;
            end
            
            % Analyze colormap effects
            fprintf('Colormap Effects Analysis:\n');
            fprintf('- Gray: Standard grayscale representation\n');
            fprintf('- Hot: Emphasizes intensity variations (good for thermal imaging)\n');
            fprintf('- Jet: Rainbow colors highlight different intensity ranges\n');
            fprintf('- Cool: Blue-cyan range, good for depth visualization\n');
            
        catch ME
            fprintf('ERROR processing %s: %s\n', image_files{i}, ME.message);
        end
    end
    
    % Summary
    fprintf('\n=== Summary ===\n');
    fprintf('Successfully processed %d images\n', length(image_files));
    fprintf('Formats tested: %s\n', strjoin(unique(file_formats), ', '));
    fprintf('\nColormap Impact on Visual Perception:\n');
    fprintf('1. Gray: Natural perception, best for medical/scientific images\n');
    fprintf('2. Hot: Highlights hot spots, good for heat maps\n');
    fprintf('3. Jet: High contrast, good for data visualization\n');
    fprintf('4. Cool: Soothing colors, good for water/depth maps\n');
end