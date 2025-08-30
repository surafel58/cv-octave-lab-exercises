% Chapter 6 Practice 1: Discrete Fourier Transform (DFT)

% 2.1 Load Required Package and Image
pkg load image;
img = imread('../images/cameraman.tif');
img = im2double(img);

% 3.2 Applying 2D Fourier Transform
F = fft2(img);
F_shifted = fftshift(F);
F_magnitude = log(1 + abs(F_shifted));

% 3.3 Inverse Fourier Transform
reconstructed = real(ifft2(F));

% Display all results in one figure
figure('Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(1, 3, 2);
imshow(F_magnitude, []);
title('Magnitude Spectrum of DFT');

subplot(1, 3, 3);
imshow(reconstructed);
title('Reconstructed Image from DFT');

% Add overall title manually
annotation('textbox', [0.25, 0.95, 0.5, 0.05], 'String', 'Chapter 6 Practice 1: Discrete Fourier Transform', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
           'EdgeColor', 'none');
