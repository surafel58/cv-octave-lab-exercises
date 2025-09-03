% Chapter 11 Practice 5: Error Metrics for Evaluation
% Calculate and visualize registration error

pkg load image;

% Load and create transformed images
fixed = im2double(imread('../images/cameraman.tif'));
moving = imrotate(fixed, 10, 'bilinear', 'crop');
moving = circshift(moving, [10, 15]);

% Simple registration using cross-correlation
registered = moving; % Placeholder - in practice would use actual registration

% Registration using manual translation correction
registered = circshift(moving, [-10, -15]); % Reverse the translation

% Calculate error metrics
error_map = abs(fixed - registered);
mse = mean(error_map(:).^2);
psnr_value = 10 * log10(1 / mse);
rmse = sqrt(mse);

% Display error visualization
figure;
subplot(2,2,1);
imshow(fixed);
title('Fixed Image');

subplot(2,2,2);
imshow(registered);
title('Registered Image');

subplot(2,2,3);
imshow(error_map, []);
title('Registration Error Map');
colorbar;

subplot(2,2,4);
imagesc(error_map);
title('Error Map (Enhanced)');
colorbar;

% Display metrics
disp(['MSE: ', num2str(mse)]);
disp(['RMSE: ', num2str(rmse)]);
disp(['PSNR: ', num2str(psnr_value), ' dB']);
