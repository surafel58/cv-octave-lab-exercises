% Chapter 3 Interactive: Simple Region Growing with User-Defined Seeds

function ch3_interactive_threshold()
    % Load required package
    pkg load image;
    
    % Load and prepare image (based on practice implementation)
    img = imread('../images/coins.png');
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    binary_img = im2bw(img, 0.4);  % Use same approach as practice
    
    % Initialize
    seed_points = [];
    result_img = binary_img;
    
    % Create figure
    fig = figure('Position', [100, 100, 800, 400], 'Name', 'Interactive Region Growing');
    
    % Original image
    subplot(1, 2, 1);
    h_binary = imshow(binary_img);
    title('Binary Image (Click to add seeds)');
    hold on;
    
    % Result image
    subplot(1, 2, 2);
    h_result = imshow(result_img);
    title('Region Labels');
    
    % Colored buttons for better visibility
    uicontrol('Style', 'pushbutton', 'Position', [50, 50, 120, 40], ...
              'String', 'Grow Regions', 'Callback', @grow_regions, ...
              'BackgroundColor', [0.2 0.8 0.2], 'ForegroundColor', 'white', ...
              'FontWeight', 'bold', 'FontSize', 12);
    
    uicontrol('Style', 'pushbutton', 'Position', [180, 50, 100, 40], ...
              'String', 'Clear Seeds', 'Callback', @clear_seeds, ...
              'BackgroundColor', [0.8 0.2 0.2], 'ForegroundColor', 'white', ...
              'FontWeight', 'bold', 'FontSize', 12);
    
    uicontrol('Style', 'pushbutton', 'Position', [290, 50, 100, 40], ...
              'String', 'Reset', 'Callback', @reset_all, ...
              'BackgroundColor', [0.2 0.2 0.8], 'ForegroundColor', 'white', ...
              'FontWeight', 'bold', 'FontSize', 12);
    
    % Instructions
    uicontrol('Style', 'text', 'Position', [50, 100, 300, 30], ...
              'String', 'Click on binary image to add seed points', ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [1 1 0.8]);
    
    % Set mouse click callback on the image object
    set(h_binary, 'ButtonDownFcn', @add_seed);
    
    function add_seed(~, ~)
        % Get click coordinates
        coords = get(gca, 'CurrentPoint');
        x = round(coords(1, 1));
        y = round(coords(1, 2));
        
        % Check bounds
        [rows, cols] = size(binary_img);
        if x >= 1 && x <= cols && y >= 1 && y <= rows
            seed_points = [seed_points; y, x];
            
            % Show seed point
            subplot(1, 2, 1);
            plot(x, y, 'ro', 'MarkerSize', 8, 'LineWidth', 3, 'MarkerFaceColor', 'red');
            fprintf('Seed %d added at (%d, %d)\n', size(seed_points, 1), x, y);
        end
    end
    
    function grow_regions(~, ~)
        if isempty(seed_points)
            fprintf('Please add seed points first\n');
            return;
        end
        
        % Simple region growing based on practice approach
        labeled_img = bwlabel(binary_img);
        
        % Create result with different labels for each seed region
        result_img = zeros(size(binary_img));
        
        for i = 1:size(seed_points, 1)
            y = seed_points(i, 1);
            x = seed_points(i, 2);
            
            % Get the label at seed point
            seed_label = labeled_img(y, x);
            
            % Assign region number to all pixels with same label
            if seed_label > 0
                result_img(labeled_img == seed_label) = i;
            end
        end
        
        % Update display
        subplot(1, 2, 2);
        set(h_result, 'CData', result_img);
        title(sprintf('Region Labels (%d regions)', max(result_img(:))));
        colormap(jet);
        
        fprintf('Region growing completed. %d regions found.\n', max(result_img(:)));
    end
    
    function clear_seeds(~, ~)
        seed_points = [];
        
        % Clear seed points from display
        subplot(1, 2, 1);
        h_binary = imshow(binary_img);
        title('Binary Image (Click to add seeds)');
        hold on;
        
        % Reset click callback
        set(h_binary, 'ButtonDownFcn', @add_seed);
        
        fprintf('All seeds cleared\n');
    end
    
    function reset_all(~, ~)
        seed_points = [];
        result_img = binary_img;
        
        % Reset both displays
        subplot(1, 2, 1);
        h_binary = imshow(binary_img);
        title('Binary Image (Click to add seeds)');
        hold on;
        
        % Reset click callback
        set(h_binary, 'ButtonDownFcn', @add_seed);
        
        subplot(1, 2, 2);
        set(h_result, 'CData', result_img);
        title('Region Labels');
        
        fprintf('Everything reset\n');
    end
end
