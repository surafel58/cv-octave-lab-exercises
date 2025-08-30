% Chapter 6 Practice 2: Discrete Cosine Transform (DCT)

% Load image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% Fast DCT2 implementation using FFT (since dct2 not available in Octave)
function dct_result = fast_dct2(img)
    [M, N] = size(img);
    
    % DCT can be computed using FFT for efficiency
    % Prepare the signal for DCT computation
    img_extended = zeros(2*M, 2*N);
    img_extended(1:M, 1:N) = img;
    img_extended(M+1:2*M, 1:N) = img(M:-1:1, :);
    img_extended(1:M, N+1:2*N) = img(:, N:-1:1);
    img_extended(M+1:2*M, N+1:2*N) = img(M:-1:1, N:-1:1);
    
    % Apply 2D FFT
    fft_result = fft2(img_extended);
    
    % Extract DCT coefficients
    dct_result = real(fft_result(1:M, 1:N));
    
    % Apply proper DCT scaling
    for u = 1:M
        for v = 1:N
            if u == 1
                alpha_u = 1/sqrt(2);
            else
                alpha_u = 1;
            end
            
            if v == 1
                alpha_v = 1/sqrt(2);
            else
                alpha_v = 1;
            end
            
            dct_result(u, v) = dct_result(u, v) * alpha_u * alpha_v * sqrt(2/M) * sqrt(2/N);
        end
    end
end

% Fast IDCT2 implementation
function idct_result = fast_idct2(dct_img)
    [M, N] = size(dct_img);
    
    % Apply proper IDCT scaling
    scaled_dct = dct_img;
    for u = 1:M
        for v = 1:N
            if u == 1
                alpha_u = 1/sqrt(2);
            else
                alpha_u = 1;
            end
            
            if v == 1
                alpha_v = 1/sqrt(2);
            else
                alpha_v = 1;
            end
            
            scaled_dct(u, v) = scaled_dct(u, v) / (alpha_u * alpha_v * sqrt(2/M) * sqrt(2/N));
        end
    end
    
    % Extend for IFFT
    extended_dct = zeros(2*M, 2*N);
    extended_dct(1:M, 1:N) = scaled_dct;
    extended_dct(M+1:2*M, 1:N) = scaled_dct(M:-1:1, :);
    extended_dct(1:M, N+1:2*N) = scaled_dct(:, N:-1:1);
    extended_dct(M+1:2*M, N+1:2*N) = scaled_dct(M:-1:1, N:-1:1);
    
    % Apply 2D IFFT and extract result
    ifft_result = real(ifft2(extended_dct));
    idct_result = ifft_result(1:M, 1:N);
end

% 4.2 Applying DCT
fprintf('Computing DCT...\n');
dct_img = fast_dct2(img);

% 4.3 Inverse DCT
fprintf('Computing inverse DCT...\n');
reconstructed_dct = fast_idct2(dct_img);

% Display all results in one figure
figure('Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(log(abs(dct_img)), []);
title('DCT Coefficients');

subplot(1, 3, 3);
imshow(reconstructed_dct);
title('Reconstructed Image from DCT');

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Chapter 6 Practice 2: Discrete Cosine Transform', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
