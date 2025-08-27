% Chapter 2 Exercise 2: Dynamic Brightness Adjustment with Slider

function ch2_interactive_brightness()
    % Load image
    color_img = imread('../images/peppers.png');
    
    % Create figure
    fig = figure('Position', [100, 100, 800, 600], 'Name', 'Interactive Brightness Adjustment');
    
    % Create axes for original image
    axes1 = subplot(1, 2, 1);
    imshow(color_img);
    title('Original Image');
    
    % Create axes for adjusted image
    axes2 = subplot(1, 2, 2);
    adjusted_img = color_img;
    h_img = imshow(adjusted_img);
    title('Brightness Adjusted');
    
    % Brightness slider
    uicontrol('Style', 'text', 'Position', [50, 50, 100, 20], 'String', 'Brightness:');
    brightness_slider = uicontrol('Style', 'slider', 'Position', [150, 50, 200, 20], ...
                                 'Min', -100, 'Max', 100, 'Value', 0, ...
                                 'Callback', @update_brightness);
    
    % Update function
    function update_brightness(~, ~)
        brightness_value = round(get(brightness_slider, 'Value'));
        
        % Apply brightness adjustment
        if brightness_value >= 0
            adjusted = color_img + brightness_value;
        else
            adjusted = color_img + brightness_value;
        end
        
        % Clamp values to valid range
        adjusted = uint8(max(0, min(255, double(adjusted))));
        
        % Update display
        set(h_img, 'CData', adjusted);
        title(axes2, sprintf('Brightness: %+d', brightness_value));
    end
    
    % Initial update
    update_brightness();
end
