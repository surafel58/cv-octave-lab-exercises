% Q7: Download Images from URL and Save Locally
% This function downloads images from specified URLs and saves them locally

function Q7_image_download(urls, save_directory)
    if nargin < 2
        save_directory = 'Lab2/images/downloaded/';
    end
    if nargin < 1
        % Default test URLs (free image sources)
        urls = {
            'https://picsum.photos/400/300.jpg',
            'https://picsum.photos/500/400.png',
            'https://httpbin.org/image/jpeg',
            'https://httpbin.org/image/png'
        };
    end
    
    fprintf('=== Q7: Image Download from URLs ===\n\n');
    
    % Ensure save directory exists
    if ~exist(save_directory, 'dir')
        mkdir(save_directory);
        fprintf('Created directory: %s\n', save_directory);
    end
    
    % Initialize results tracking
    successful_downloads = 0;
    failed_downloads = 0;
    downloaded_files = {};
    
    fprintf('Attempting to download %d images...\n\n', length(urls));
    
    for i = 1:length(urls)
        fprintf('--- Download %d/%d ---\n', i, length(urls));
        fprintf('URL: %s\n', urls{i});
        
        try
            % Generate filename from URL
            [~, url_name, url_ext] = fileparts(urls{i});
            
            % If no extension found, try to determine from URL
            if isempty(url_ext)
                if contains(urls{i}, '.jpg') || contains(urls{i}, 'jpeg')
                    url_ext = '.jpg';
                elseif contains(urls{i}, '.png')
                    url_ext = '.png';
                elseif contains(urls{i}, '.bmp')
                    url_ext = '.bmp';
                else
                    url_ext = '.jpg'; % Default
                end
            end
            
            % Create unique filename
            timestamp = datestr(now, 'yyyymmdd_HHMMSS');
            filename = sprintf('downloaded_%d_%s%s', i, timestamp, url_ext);
            full_path = fullfile(save_directory, filename);
            
            fprintf('Saving to: %s\n', filename);
            
            % Download the image
            [success, error_msg] = download_image_safe(urls{i}, full_path);
            
            if success
                % Verify the downloaded file is a valid image
                try
                    test_img = imread(full_path);
                    [h, w, c] = size(test_img);
                    
                    fprintf('✓ Download successful!\n');
                    fprintf('  Image size: %dx%d, Channels: %d\n', w, h, c);
                    fprintf('  File size: %.1f KB\n', get_file_size_kb(full_path));
                    
                    successful_downloads = successful_downloads + 1;
                    downloaded_files{end+1} = full_path;
                    
                catch img_error
                    fprintf('✗ Downloaded file is not a valid image: %s\n', img_error.message);
                    if exist(full_path, 'file')
                        delete(full_path);
                    end
                    failed_downloads = failed_downloads + 1;
                end
            else
                fprintf('✗ Download failed: %s\n', error_msg);
                failed_downloads = failed_downloads + 1;
            end
            
        catch ME
            fprintf('✗ Error processing URL: %s\n', ME.message);
            failed_downloads = failed_downloads + 1;
        end
        
        fprintf('\n');
    end
    
    % Display results summary
    fprintf('=== Download Summary ===\n');
    fprintf('Total URLs processed: %d\n', length(urls));
    fprintf('Successful downloads: %d\n', successful_downloads);
    fprintf('Failed downloads: %d\n', failed_downloads);
    fprintf('Success rate: %.1f%%\n', (successful_downloads / length(urls)) * 100);
    
    % Display downloaded images if any were successful
    if successful_downloads > 0
        fprintf('\n=== Displaying Downloaded Images ===\n');
        
        % Create figure for displaying images
        num_images = length(downloaded_files);
        cols = ceil(sqrt(num_images));
        rows = ceil(num_images / cols);
        
        figure('Name', 'Q7: Downloaded Images', 'Position', [100, 100, 1200, 800]);
        
        for i = 1:num_images
            try
                img = imread(downloaded_files{i});
                [~, fname, fext] = fileparts(downloaded_files{i});
                
                subplot(rows, cols, i);
                imshow(img);
                title(sprintf('%s%s\n%dx%d', fname(1:min(15,length(fname))), fext, ...
                       size(img, 2), size(img, 1)), 'Interpreter', 'none');
                
                fprintf('Image %d: %s\n', i, downloaded_files{i});
                
            catch disp_error
                fprintf('Error displaying image %d: %s\n', i, disp_error.message);
            end
        end
        
        % Analyze downloaded images
        analyze_downloaded_images(downloaded_files);
    end
    
    % Provide recommendations for image sources
    fprintf('\n=== Recommended Image Sources ===\n');
    fprintf('1. Lorem Picsum (picsum.photos) - Random placeholder images\n');
    fprintf('2. Unsplash API (api.unsplash.com) - High-quality photos (requires API key)\n');
    fprintf('3. Pixabay API (pixabay.com/api) - Free images (requires API key)\n');
    fprintf('4. JSONPlaceholder (jsonplaceholder.typicode.com) - Test images\n');
    fprintf('5. httpbin.org - Various test image formats\n');
    
    fprintf('\n=== Error Handling Insights ===\n');
    if failed_downloads > 0
        fprintf('Common issues encountered:\n');
        fprintf('- Network connectivity problems\n');
        fprintf('- Invalid URLs or moved content\n');
        fprintf('- Server restrictions or rate limiting\n');
        fprintf('- Unsupported image formats\n');
        fprintf('- HTTPS/SSL certificate issues\n');
    else
        fprintf('All downloads completed successfully!\n');
    end
end

% Safe image download function with error handling
function [success, error_msg] = download_image_safe(url, output_path)
    success = false;
    error_msg = '';
    
    try
        % Method 1: Try using urlwrite (older Octave versions)
        try
            urlwrite(url, output_path);
            success = true;
            return;
        catch
            % Continue to next method
        end
        
        % Method 2: Try using websave (newer Octave versions)
        try
            websave(output_path, url);
            success = true;
            return;
        catch
            % Continue to next method
        end
        
        % Method 3: Try using system curl command
        try
            if ispc()
                % Windows
                cmd = sprintf('curl -L -o "%s" "%s"', output_path, url);
            else
                % Linux/Mac
                cmd = sprintf('curl -L -o ''%s'' ''%s''', output_path, url);
            end
            
            [status, ~] = system(cmd);
            if status == 0 && exist(output_path, 'file')
                success = true;
                return;
            end
        catch
            % Continue to next method
        end
        
        % Method 4: Try using system wget command
        try
            if ~ispc()  % Linux/Mac only
                cmd = sprintf('wget -O ''%s'' ''%s''', output_path, url);
                [status, ~] = system(cmd);
                if status == 0 && exist(output_path, 'file')
                    success = true;
                    return;
                end
            end
        catch
            % All methods failed
        end
        
        error_msg = 'All download methods failed. Check network connection and URL validity.';
        
    catch ME
        error_msg = ME.message;
    end
end

% Get file size in KB
function size_kb = get_file_size_kb(filepath)
    try
        file_info = dir(filepath);
        size_kb = file_info.bytes / 1024;
    catch
        size_kb = 0;
    end
end

% Analyze downloaded images
function analyze_downloaded_images(image_files)
    fprintf('\n=== Image Analysis ===\n');
    
    total_size = 0;
    formats = {};
    dimensions = [];
    
    for i = 1:length(image_files)
        try
            img = imread(image_files{i});
            [h, w, c] = size(img);
            
            % Get file info
            [~, ~, ext] = fileparts(image_files{i});
            file_size = get_file_size_kb(image_files{i});
            
            dimensions(end+1, :) = [w, h, c];
            formats{end+1} = upper(ext(2:end));
            total_size = total_size + file_size;
            
        catch
            fprintf('Could not analyze image %d\n', i);
        end
    end
    
    if ~isempty(dimensions)
        fprintf('Format distribution:\n');
        unique_formats = unique(formats);
        for i = 1:length(unique_formats)
            count = sum(strcmp(formats, unique_formats{i}));
            fprintf('  %s: %d images\n', unique_formats{i}, count);
        end
        
        fprintf('\nDimension statistics:\n');
        fprintf('  Average width: %.0f pixels\n', mean(dimensions(:, 1)));
        fprintf('  Average height: %.0f pixels\n', mean(dimensions(:, 2)));
        fprintf('  Total storage: %.1f KB\n', total_size);
        
        % Check for color vs grayscale
        color_images = sum(dimensions(:, 3) == 3);
        grayscale_images = sum(dimensions(:, 3) == 1);
        fprintf('  Color images: %d\n', color_images);
        fprintf('  Grayscale images: %d\n', grayscale_images);
    end
end

% Demo function with alternative image sources
function demo_alternative_sources()
    fprintf('=== Demo: Alternative Image Sources ===\n');
    
    % Alternative free image APIs and sources
    alt_urls = {
        'https://picsum.photos/300/200?random=1',  % Random image
        'https://picsum.photos/400/300?random=2',  % Another random
        'https://source.unsplash.com/300x200/?nature',  % Nature theme
        'https://source.unsplash.com/400x300/?city'     % City theme
    };
    
    fprintf('Testing alternative image sources...\n');
    Q7_image_download(alt_urls, 'Lab2/images/alternative/');
end