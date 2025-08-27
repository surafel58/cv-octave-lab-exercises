% Chapter 1 Exercise 3: Interactive UI for Sampling/Quantization

function ch1_interactive_ui()
    % Load image
    img = imread('../images/cameraman.tif');
    
    % Create figure
    fig = figure('Position', [100, 100, 800, 600], 'Name', 'Interactive Sampling & Quantization');
    
    % Create axes for original image
    axes1 = subplot(2, 2, 1);
    imshow(img);
    title('Original Image');
    
    % Create axes for processed image
    axes2 = subplot(2, 2, 2);
    processed_img = img;
    h_img = imshow(processed_img);
    title('Processed Image');
    
    % Sampling slider
    uicontrol('Style', 'text', 'Position', [50, 50, 100, 20], 'String', 'Sampling Factor:');
    sampling_slider = uicontrol('Style', 'slider', 'Position', [150, 50, 200, 20], ...
                               'Min', 1, 'Max', 8, 'Value', 1, ...
                               'Callback', @update_image);
    
    % Quantization slider
    uicontrol('Style', 'text', 'Position', [50, 20, 100, 20], 'String', 'Quantization Levels:');
    quant_slider = uicontrol('Style', 'slider', 'Position', [150, 20, 200, 20], ...
                            'Min', 2, 'Max', 256, 'Value', 256, ...
                            'Callback', @update_image);
    
    % Update function
    function update_image(~, ~)
        sampling_factor = round(get(sampling_slider, 'Value'));
        quant_levels = round(get(quant_slider, 'Value'));
        
        % Apply sampling
        if sampling_factor > 1
            sampled = img(1:sampling_factor:end, 1:sampling_factor:end);
        else
            sampled = img;
        end
        
        % Apply quantization
        if quant_levels < 256
            step = 256 / quant_levels;
            quantized = uint8(floor(double(sampled) / step) * step);
        else
            quantized = sampled;
        end
        
        % Update display
        set(h_img, 'CData', quantized);
        title(axes2, sprintf('Sampled (x%d) & Quantized (%d levels)', sampling_factor, quant_levels));
    end
    
    % Initial update
    update_image();
end