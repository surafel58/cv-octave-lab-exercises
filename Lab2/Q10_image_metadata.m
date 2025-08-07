% Q10: Image Metadata Extraction and Analysis
% This function extracts and displays metadata from images

function metadata = Q10_image_metadata(image_path)
    if nargin < 1
        image_path = 'images/test_images/with_metadata.jpg';
    end
    
    fprintf('=== Q10: Image Metadata Extraction and Analysis ===\n\n');
    
    metadata = struct();
    
    try
        fprintf('Analyzing image: %s\n\n', image_path);
        
        % Basic file information
        file_info = dir(image_path);
        if isempty(file_info)
            error('Image file not found: %s', image_path);
        end
        
        fprintf('=== Basic File Information ===\n');
        fprintf('Filename: %s\n', file_info.name);
        fprintf('File size: %.2f KB (%.2f MB)\n', file_info.bytes/1024, file_info.bytes/(1024*1024));
        fprintf('Date modified: %s\n', file_info.date);
        
        % Store basic metadata
        metadata.filename = file_info.name;
        metadata.file_size_bytes = file_info.bytes;
        metadata.date_modified = file_info.date;
        
        % Load image to get basic properties
        img = imread(image_path);
        [height, width, channels] = size(img);
        
        fprintf('\n=== Image Properties ===\n');
        fprintf('Dimensions: %d x %d pixels\n', width, height);
        fprintf('Channels: %d\n', channels);
        fprintf('Data type: %s\n', class(img));
        fprintf('Color space: %s\n', determine_color_space(img));
        
        total_pixels = height * width;
        fprintf('Total pixels: %d\n', total_pixels);
        fprintf('Bits per pixel: %d\n', channels * 8);
        fprintf('Uncompressed size: %.2f KB\n', total_pixels * channels / 1024);
        
        % Calculate compression ratio
        compression_ratio = file_info.bytes / (total_pixels * channels);
        fprintf('Compression ratio: %.2f:1\n', 1/compression_ratio);
        
        % Store image properties
        metadata.width = width;
        metadata.height = height;
        metadata.channels = channels;
        metadata.data_type = class(img);
        metadata.total_pixels = total_pixels;
        metadata.compression_ratio = compression_ratio;
        
        % Try to extract EXIF data using different methods
        fprintf('\n=== EXIF Metadata Extraction ===\n');
        
        % Method 1: Try Octave's imfinfo function
        try
            img_info = imfinfo(image_path);
            metadata.exif_available = true;
            extract_exif_from_imfinfo(img_info, metadata);
        catch
            fprintf('imfinfo method failed, trying alternative methods...\n');
            metadata.exif_available = false;
        end
        
        % Method 2: Try system exiftool command
        if ~metadata.exif_available
            try
                exif_data = extract_with_exiftool(image_path);
                if ~isempty(exif_data)
                    metadata.exif_available = true;
                    metadata.exif_raw = exif_data;
                    parse_exiftool_output(exif_data, metadata);
                end
            catch
                fprintf('exiftool method failed\n');
            end
        end
        
        % Method 3: Manual JPEG header analysis
        if ~metadata.exif_available && (strcmpi(file_info.name(end-3:end), '.jpg') || strcmpi(file_info.name(end-4:end), '.jpeg'))
            try
                manual_exif = extract_jpeg_header_info(image_path);
                if ~isempty(manual_exif)
                    metadata.exif_available = true;
                    metadata = merge_structs(metadata, manual_exif);
                    fprintf('Manual JPEG header analysis completed\n');
                end
            catch
                fprintf('Manual JPEG analysis failed\n');
            end
        end
        
        % If no EXIF data found, note it
        if ~metadata.exif_available
            fprintf('No EXIF metadata found or extractable\n');
            fprintf('This may be because:\n');
            fprintf('- Image was processed/edited and metadata removed\n');
            fprintf('- Image format doesn''t support EXIF (e.g., PNG, BMP)\n');
            fprintf('- Image was downloaded from web (metadata often stripped)\n');
        end
        
        % Extract color information
        fprintf('\n=== Color Analysis ===\n');
        color_stats = analyze_image_colors(img);
        metadata.color_analysis = color_stats;
        display_color_analysis(color_stats);
        
        % Calculate image quality metrics
        fprintf('\n=== Quality Metrics ===\n');
        quality_metrics = calculate_quality_metrics(img);
        metadata.quality_metrics = quality_metrics;
        display_quality_metrics(quality_metrics);
        
        % Generate histogram data
        fprintf('\n=== Histogram Analysis ===\n');
        histogram_data = generate_histogram_analysis(img);
        metadata.histogram_data = histogram_data;
        
        % Display comprehensive metadata summary
        display_metadata_summary(metadata);
        
        % Save metadata to file
        save_metadata_to_file(metadata, image_path);
        
    catch ME
        fprintf('ERROR extracting metadata: %s\n', ME.message);
        metadata = struct('error', ME.message);
    end
end

% Extract EXIF data from imfinfo structure
function extract_exif_from_imfinfo(img_info, metadata)
    fprintf('Using imfinfo for metadata extraction:\n');
    
    % Common EXIF fields
    exif_fields = {'Make', 'Model', 'DateTime', 'DateTimeOriginal', 'ExposureTime', ...
                  'FNumber', 'ISO', 'FocalLength', 'Flash', 'WhiteBalance', ...
                  'ExposureProgram', 'MeteringMode', 'Orientation', 'XResolution', 'YResolution'};
    
    for i = 1:length(exif_fields)
        field = exif_fields{i};
        if isfield(img_info, field)
            value = img_info.(field);
            if ischar(value) || isstring(value)
                fprintf('  %s: %s\n', field, value);
            elseif isnumeric(value)
                if length(value) == 1
                    fprintf('  %s: %.3f\n', field, value);
                else
                    fprintf('  %s: [%s]\n', field, mat2str(value));
                end
            end
            metadata.(field) = value;
        end
    end
    
    % Special handling for some fields
    if isfield(img_info, 'BitDepth')
        fprintf('  Bit Depth: %d\n', img_info.BitDepth);
        metadata.BitDepth = img_info.BitDepth;
    end
    
    if isfield(img_info, 'ColorType')
        fprintf('  Color Type: %s\n', img_info.ColorType);
        metadata.ColorType = img_info.ColorType;
    end
end

% Extract metadata using exiftool system command
function exif_data = extract_with_exiftool(image_path)
    exif_data = '';
    
    try
        % Try exiftool command
        if ispc()
            cmd = sprintf('exiftool "%s"', image_path);
        else
            cmd = sprintf('exiftool ''%s''', image_path);
        end
        
        [status, output] = system(cmd);
        
        if status == 0 && ~isempty(output)
            exif_data = output;
            fprintf('exiftool extraction successful\n');
        else
            fprintf('exiftool not available or failed\n');
        end
        
    catch
        % exiftool not available
    end
end

% Parse exiftool output
function parse_exiftool_output(exif_data, metadata)
    lines = strsplit(exif_data, '\n');
    
    for i = 1:length(lines)
        line = strtrim(lines{i});
        if contains(line, ':')
            parts = strsplit(line, ':', 2);
            if length(parts) == 2
                field_name = strtrim(parts{1});
                field_value = strtrim(parts{2});
                
                % Clean field name for struct
                field_name = regexprep(field_name, '[^a-zA-Z0-9]', '_');
                
                fprintf('  %s: %s\n', field_name, field_value);
                metadata.(field_name) = field_value;
            end
        end
    end
end

% Manual JPEG header analysis
function manual_exif = extract_jpeg_header_info(image_path)
    manual_exif = struct();
    
    try
        % Read file as binary
        fid = fopen(image_path, 'rb');
        if fid == -1
            return;
        end
        
        % Read first few KB to find markers
        header_data = fread(fid, 8192, 'uint8');
        fclose(fid);
        
        % Look for JPEG markers
        if length(header_data) >= 2 && header_data(1) == 255 && header_data(2) == 216
            fprintf('Valid JPEG file detected\n');
            manual_exif.format = 'JPEG';
            
            % Look for JFIF marker (FF E0)
            jfif_pos = find_pattern(header_data, [255, 224]);
            if ~isempty(jfif_pos)
                fprintf('JFIF marker found at position %d\n', jfif_pos(1));
                manual_exif.has_jfif = true;
            end
            
            % Look for EXIF marker (FF E1)
            exif_pos = find_pattern(header_data, [255, 225]);
            if ~isempty(exif_pos)
                fprintf('EXIF marker found at position %d\n', exif_pos(1));
                manual_exif.has_exif = true;
            end
            
        else
            fprintf('Not a valid JPEG file\n');
        end
        
    catch
        % Manual analysis failed
    end
end

% Find pattern in binary data
function positions = find_pattern(data, pattern)
    positions = [];
    pattern_len = length(pattern);
    
    for i = 1:(length(data) - pattern_len + 1)
        if all(data(i:i+pattern_len-1) == pattern)
            positions(end+1) = i;
        end
    end
end

% Determine color space
function color_space = determine_color_space(img)
    channels = size(img, 3);
    
    if channels == 1
        color_space = 'Grayscale';
    elseif channels == 3
        color_space = 'RGB';
    elseif channels == 4
        color_space = 'RGBA or CMYK';
    else
        color_space = sprintf('%d-channel', channels);
    end
end

% Analyze image colors
function color_stats = analyze_image_colors(img)
    color_stats = struct();
    
    if size(img, 3) == 3
        % RGB analysis
        r_mean = mean(img(:, :, 1), 'all');
        g_mean = mean(img(:, :, 2), 'all');
        b_mean = mean(img(:, :, 3), 'all');
        
        color_stats.rgb_mean = [r_mean, g_mean, b_mean];
        color_stats.brightness = (r_mean + g_mean + b_mean) / 3;
        
        % Color dominance
        [~, dominant_channel] = max([r_mean, g_mean, b_mean]);
        channels = {'Red', 'Green', 'Blue'};
        color_stats.dominant_color = channels{dominant_channel};
        
        % Color diversity (unique colors)
        img_reshaped = reshape(img, [], 3);
        unique_colors = unique(img_reshaped, 'rows');
        color_stats.unique_colors = size(unique_colors, 1);
        color_stats.color_diversity = size(unique_colors, 1) / size(img_reshaped, 1);
        
    else
        % Grayscale analysis
        gray_mean = mean(img, 'all');
        color_stats.brightness = gray_mean;
        color_stats.rgb_mean = [gray_mean, gray_mean, gray_mean];
        color_stats.dominant_color = 'Grayscale';
        
        unique_grays = unique(img(:));
        color_stats.unique_colors = length(unique_grays);
        color_stats.color_diversity = length(unique_grays) / numel(img);
    end
end

% Display color analysis
function display_color_analysis(color_stats)
    fprintf('Average RGB: [%.1f, %.1f, %.1f]\n', color_stats.rgb_mean);
    fprintf('Overall brightness: %.1f\n', color_stats.brightness);
    fprintf('Dominant color: %s\n', color_stats.dominant_color);
    fprintf('Unique colors: %d\n', color_stats.unique_colors);
    fprintf('Color diversity: %.3f\n', color_stats.color_diversity);
end

% Calculate quality metrics
function quality_metrics = calculate_quality_metrics(img)
    quality_metrics = struct();
    
    % Convert to grayscale for analysis
    if size(img, 3) == 3
        gray_img = rgb2gray(img);
    else
        gray_img = img;
    end
    
    gray_double = double(gray_img);
    
    % Sharpness (gradient magnitude)
    [gx, gy] = gradient(gray_double);
    gradient_mag = sqrt(gx.^2 + gy.^2);
    quality_metrics.sharpness = mean(gradient_mag(:));
    
    % Contrast (standard deviation)
    quality_metrics.contrast = std(gray_double(:));
    
    % Noise estimation (high frequency content)
    laplacian = conv2(gray_double, [0 -1 0; -1 4 -1; 0 -1 0], 'same');
    quality_metrics.noise_estimate = std(laplacian(:));
    
    % Dynamic range
    quality_metrics.dynamic_range = max(gray_double(:)) - min(gray_double(:));
    
    % Entropy (information content)
    [counts, ~] = imhist(uint8(gray_double));
    prob = counts / sum(counts);
    prob = prob(prob > 0);  % Remove zeros
    quality_metrics.entropy = -sum(prob .* log2(prob));
end

% Display quality metrics
function display_quality_metrics(quality_metrics)
    fprintf('Sharpness: %.2f\n', quality_metrics.sharpness);
    fprintf('Contrast: %.2f\n', quality_metrics.contrast);
    fprintf('Noise estimate: %.2f\n', quality_metrics.noise_estimate);
    fprintf('Dynamic range: %.1f\n', quality_metrics.dynamic_range);
    fprintf('Entropy: %.2f bits\n', quality_metrics.entropy);
end

% Generate histogram analysis
function histogram_data = generate_histogram_analysis(img)
    histogram_data = struct();
    
    if size(img, 3) == 3
        % RGB histograms
        [r_hist, ~] = imhist(img(:, :, 1));
        [g_hist, ~] = imhist(img(:, :, 2));
        [b_hist, ~] = imhist(img(:, :, 3));
        
        histogram_data.red = r_hist;
        histogram_data.green = g_hist;
        histogram_data.blue = b_hist;
        
        % Combined histogram
        gray_img = rgb2gray(img);
        [combined_hist, ~] = imhist(gray_img);
        histogram_data.luminance = combined_hist;
        
    else
        % Grayscale histogram
        [gray_hist, ~] = imhist(img);
        histogram_data.gray = gray_hist;
    end
    
    % Display histogram
    figure('Name', 'Q10: Image Histograms', 'Position', [100, 100, 800, 600]);
    
    if size(img, 3) == 3
        subplot(2, 2, 1);
        plot(histogram_data.red, 'r');
        title('Red Channel Histogram');
        
        subplot(2, 2, 2);
        plot(histogram_data.green, 'g');
        title('Green Channel Histogram');
        
        subplot(2, 2, 3);
        plot(histogram_data.blue, 'b');
        title('Blue Channel Histogram');
        
        subplot(2, 2, 4);
        plot(histogram_data.luminance, 'k');
        title('Luminance Histogram');
    else
        plot(histogram_data.gray, 'k');
        title('Grayscale Histogram');
    end
    
    fprintf('Histogram data generated and displayed\n');
end

% Display comprehensive metadata summary
function display_metadata_summary(metadata)
    fprintf('\n=== COMPREHENSIVE METADATA SUMMARY ===\n');
    fprintf('╔══════════════════════════════════════╗\n');
    fprintf('║            IMAGE METADATA            ║\n');
    fprintf('╠══════════════════════════════════════╣\n');
    
    if isfield(metadata, 'filename')
        fprintf('║ File: %-30s ║\n', metadata.filename(1:min(30, length(metadata.filename))));
    end
    
    if isfield(metadata, 'width') && isfield(metadata, 'height')
        fprintf('║ Size: %d x %d pixels             ║\n', metadata.width, metadata.height);
    end
    
    if isfield(metadata, 'file_size_bytes')
        fprintf('║ File Size: %.1f KB                  ║\n', metadata.file_size_bytes/1024);
    end
    
    if isfield(metadata, 'compression_ratio')
        fprintf('║ Compression: %.1f:1                 ║\n', 1/metadata.compression_ratio);
    end
    
    fprintf('╚══════════════════════════════════════╝\n');
    
    % Importance of metadata
    fprintf('\n=== IMPORTANCE OF METADATA IN IMAGE PROCESSING ===\n');
    fprintf('1. Quality Assessment:\n');
    fprintf('   - Resolution determines processing capabilities\n');
    fprintf('   - Compression ratio affects quality expectations\n\n');
    
    fprintf('2. Processing Optimization:\n');
    fprintf('   - Color space information guides algorithm selection\n');
    fprintf('   - Bit depth affects precision requirements\n\n');
    
    fprintf('3. Workflow Management:\n');
    fprintf('   - Creation date helps with version control\n');
    fprintf('   - Camera settings inform about capture conditions\n\n');
    
    fprintf('4. Legal and Attribution:\n');
    fprintf('   - Creator information for copyright\n');
    fprintf('   - GPS data for location-based applications\n\n');
    
    fprintf('5. Technical Specifications:\n');
    fprintf('   - Format compatibility requirements\n');
    fprintf('   - Color profile for accurate reproduction\n');
end

% Save metadata to file
function save_metadata_to_file(metadata, image_path)
    [~, name, ~] = fileparts(image_path);
    metadata_file = sprintf('Lab2/images/metadata_%s.txt', name);
    
    try
        fid = fopen(metadata_file, 'w');
        
        fprintf(fid, 'IMAGE METADATA REPORT\n');
        fprintf(fid, '====================\n\n');
        fprintf(fid, 'Generated: %s\n\n', datestr(now));
        
        % Write all metadata fields
        fields = fieldnames(metadata);
        for i = 1:length(fields)
            field = fields{i};
            value = metadata.(field);
            
            if isstruct(value)
                fprintf(fid, '%s:\n', field);
                subfields = fieldnames(value);
                for j = 1:length(subfields)
                    fprintf(fid, '  %s: %s\n', subfields{j}, mat2str(value.(subfields{j})));
                end
                fprintf(fid, '\n');
            elseif ischar(value) || isstring(value)
                fprintf(fid, '%s: %s\n', field, value);
            elseif isnumeric(value)
                if length(value) == 1
                    fprintf(fid, '%s: %.6g\n', field, value);
                else
                    fprintf(fid, '%s: %s\n', field, mat2str(value));
                end
            else
                fprintf(fid, '%s: %s\n', field, class(value));
            end
        end
        
        fclose(fid);
        fprintf('Metadata saved to: %s\n', metadata_file);
        
    catch
        fprintf('Could not save metadata to file\n');
    end
end

% Merge two structures
function merged = merge_structs(struct1, struct2)
    merged = struct1;
    fields = fieldnames(struct2);
    
    for i = 1:length(fields)
        merged.(fields{i}) = struct2.(fields{i});
    end
end