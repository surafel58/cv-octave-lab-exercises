% Chapter 5 Interactive: Real-time Filter Comparison

function ch5_interactive_filters()
    % Load required package
    pkg load image;
    
    % Load image
    img = imread('../images/cameraman.tif');
    img = im2double(img);
    
    % Create figure
    fig = figure('Position', [100, 100, 1200, 700], 'Name', 'Interactive Filter Comparison');
    
    % Original image
    subplot(2, 3, 1);
    imshow(img);
    title('Original Image', 'FontWeight', 'bold');
    
    % Initialize filtered images
    subplot(2, 3, 2);
    h_avg = imshow(img);
    title('Averaging Filter');
    
    subplot(2, 3, 3);
    h_gauss = imshow(img);
    title('Gaussian Filter');
    
    subplot(2, 3, 4);
    h_median = imshow(img);
    title('Median Filter');
    
    subplot(2, 3, 5);
    h_sharp = imshow(img);
    title('Sharpened Image');
    
    subplot(2, 3, 6);
    h_edges = imshow(img);
    title('Edge Detection');
    
    % Filter size slider
    uicontrol('Style', 'text', 'Position', [50, 100, 120, 20], 'String', 'Filter Size (odd):');
    size_slider = uicontrol('Style', 'slider', 'Position', [180, 100, 200, 20], ...
                           'Min', 3, 'Max', 15, 'Value', 3, ...
                           'Callback', @update_filters);
    
    % Gaussian sigma slider
    uicontrol('Style', 'text', 'Position', [50, 70, 120, 20], 'String', 'Gaussian Sigma:');
    sigma_slider = uicontrol('Style', 'slider', 'Position', [180, 70, 200, 20], ...
                            'Min', 0.5, 'Max', 5, 'Value', 1, ...
                            'Callback', @update_filters);
    
    % Sharpening strength slider
    uicontrol('Style', 'text', 'Position', [50, 40, 120, 20], 'String', 'Sharp Strength:');
    sharp_slider = uicontrol('Style', 'slider', 'Position', [180, 40, 200, 20], ...
                            'Min', 0.5, 'Max', 3, 'Value', 1, ...
                            'Callback', @update_filters);
    
    % Colored buttons
    uicontrol('Style', 'pushbutton', 'Position', [400, 70, 100, 30], ...
              'String', 'Add Noise', 'Callback', @add_noise, ...
              'BackgroundColor', [0.8 0.4 0.2], 'ForegroundColor', 'white', ...
              'FontWeight', 'bold');
    
    uicontrol('Style', 'pushbutton', 'Position', [510, 70, 100, 30], ...
              'String', 'Reset Image', 'Callback', @reset_image, ...
              'BackgroundColor', [0.2 0.6 0.8], 'ForegroundColor', 'white', ...
              'FontWeight', 'bold');
    
    % Store original image
    original_img = img;
    
    function update_filters(~, ~)
        filter_size = round(get(size_slider, 'Value'));
        if mod(filter_size, 2) == 0
            filter_size = filter_size + 1;  % Ensure odd size
        end
        sigma_val = get(sigma_slider, 'Value');
        sharp_strength = get(sharp_slider, 'Value');
        
        % Averaging filter
        avg_kernel = ones(filter_size, filter_size) / (filter_size^2);
        avg_filtered = imfilter(img, avg_kernel);
        set(h_avg, 'CData', avg_filtered);
        subplot(2, 3, 2); title(sprintf('Averaging Filter (%dx%d)', filter_size, filter_size));
        
        % Gaussian filter
        gauss_filtered = imgaussfilt(img, sigma_val);
        set(h_gauss, 'CData', gauss_filtered);
        subplot(2, 3, 3); title(sprintf('Gaussian (σ=%.1f)', sigma_val));
        
        % Median filter
        median_filtered = medfilt2(img, [filter_size filter_size]);
        set(h_median, 'CData', median_filtered);
        subplot(2, 3, 4); title(sprintf('Median Filter (%dx%d)', filter_size, filter_size));
        
        % Sharpening
        laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
        laplacian_response = imfilter(img, laplacian_kernel);
        sharpened = img + sharp_strength * laplacian_response;
        set(h_sharp, 'CData', sharpened);
        subplot(2, 3, 5); title(sprintf('Sharpened (×%.1f)', sharp_strength));
        
        % Edge detection
        sobel_x = [-1 0 1; -2 0 2; -1 0 1];
        sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
        gx = imfilter(img, sobel_x);
        gy = imfilter(img, sobel_y);
        edges = sqrt(gx.^2 + gy.^2);
        set(h_edges, 'CData', edges);
    end
    
    function add_noise(~, ~)
        img = imnoise(original_img, 'gaussian', 0, 0.01);
        subplot(2, 3, 1); imshow(img); title('Original (with noise)', 'FontWeight', 'bold');
        update_filters();
        fprintf('Gaussian noise added to image\n');
    end
    
    function reset_image(~, ~)
        img = original_img;
        subplot(2, 3, 1); imshow(img); title('Original Image', 'FontWeight', 'bold');
        update_filters();
        fprintf('Image reset to original\n');
    end
    
    % Initial update
    update_filters();
end
