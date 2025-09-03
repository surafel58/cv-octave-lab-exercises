% Chapter 11: Complete Image Registration Overview
% Comprehensive demonstration of all registration techniques

pkg load image;

% Load base image
fixed = im2double(imread('../images/cameraman.tif'));
[h, w] = size(fixed);

%% Section 1: Basic Transformation Simulation
fprintf('=== Section 1: Image Transformation Simulation ===\n');

% Create various transformed images
moving_rot = imrotate(fixed, 10, 'bilinear', 'crop');
moving_trans = circshift(fixed, [15, 20]);
moving_scale = imresize(fixed, 1.3, 'bilinear');
moving_scale = moving_scale(1:h, 1:w); % Crop to original size

figure('Name', 'Transformation Types');
subplot(2,2,1); imshow(fixed); title('Original (Fixed)');
subplot(2,2,2); imshow(moving_rot); title('Rotated (10°)');
subplot(2,2,3); imshow(moving_trans); title('Translated [15,20]');
subplot(2,2,4); imshow(moving_scale); title('Scaled (1.3x)');

%% Section 2: Manual Registration Pipeline
fprintf('=== Section 2: Manual Control Point Registration ===\n');

% Test image with rotation + translation
test_moving = imrotate(fixed, 15, 'bilinear', 'crop');
test_moving = circshift(test_moving, [20, 25]);

% Define corresponding control points
mp = [80, 100; 180, 120; 120, 180; 200, 200];  % Moving points
fp = [100, 125; 205, 145; 145, 205; 225, 225]; % Fixed points

% Estimate affine transformation
A = [mp ones(size(mp,1),1)];
tform_x = A \ fp(:,1);
tform_y = A \ fp(:,2);

% Create transformation matrix
T = [tform_x(1:2)'; tform_y(1:2)'; 0 0 1];
T(1,3) = tform_x(3);
T(2,3) = tform_y(3);

% Apply transformation
[X, Y] = meshgrid(1:w, 1:h);
coords = [X(:), Y(:), ones(numel(X),1)];
new_coords = coords * T';
X_new = reshape(new_coords(:,1), h, w);
Y_new = reshape(new_coords(:,2), h, w);
registered = interp2(test_moving, X_new, Y_new, 'linear', 0);

figure('Name', 'Manual Registration Results');
subplot(2,2,1); imshow(fixed); title('Fixed Image');
subplot(2,2,2); imshow(test_moving); title('Moving Image');
subplot(2,2,3); imshow(registered); title('Registered Result');
subplot(2,2,4); imshow(abs(fixed - registered), []); title('Error Map'); colorbar;

%% Section 3: Automated Feature Detection
fprintf('=== Section 3: Automated Feature Matching ===\n');

% Harris corner detection function
function corners = detect_corners(img, threshold)
    [Ix, Iy] = gradient(imgaussfilt(img, 1));
    Ix2 = imgaussfilt(Ix.^2, 1);
    Iy2 = imgaussfilt(Iy.^2, 1);
    Ixy = imgaussfilt(Ix.*Iy, 1);
    k = 0.04;
    R = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
    [y, x] = find(R > threshold);
    corners = [x, y];
end

% Detect corners in both images
corners_fixed = detect_corners(fixed, 0.01);
corners_moving = detect_corners(test_moving, 0.01);

figure('Name', 'Feature Detection');
subplot(1,2,1);
imshow(fixed); hold on;
plot(corners_fixed(:,1), corners_fixed(:,2), 'r+', 'MarkerSize', 8);
title(['Fixed: ', num2str(size(corners_fixed,1)), ' corners']);

subplot(1,2,2);
imshow(test_moving); hold on;
plot(corners_moving(:,1), corners_moving(:,2), 'r+', 'MarkerSize', 8);
title(['Moving: ', num2str(size(corners_moving,1)), ' corners']);

%% Section 4: Registration Quality Assessment
fprintf('=== Section 4: Quality Assessment Metrics ===\n');

% Test multiple transformation scenarios
test_scenarios = {
    fixed,                                          % Identity
    circshift(fixed, [10, 15]),                    % Translation
    imrotate(fixed, 5, 'bilinear', 'crop'),        % Rotation
    registered                                      % Manual registration
};

scenario_names = {'Identity', 'Translation', 'Rotation', 'Manual Reg'};
metrics = zeros(length(test_scenarios), 3); % [MSE, RMSE, PSNR]

for i = 1:length(test_scenarios)
    error_img = abs(fixed - test_scenarios{i});
    mse = mean(error_img(:).^2);
    rmse = sqrt(mse);
    psnr = 10 * log10(1 / mse);
    
    metrics(i, :) = [mse, rmse, psnr];
    fprintf('%s: MSE=%.6f, RMSE=%.4f, PSNR=%.2f dB\n', ...
            scenario_names{i}, mse, rmse, psnr);
end

% Visualize quality metrics
figure('Name', 'Registration Quality Metrics');
subplot(1,3,1); 
bar(metrics(:,1)); 
title('Mean Squared Error'); 
set(gca, 'XTickLabel', scenario_names);
ylabel('MSE');

subplot(1,3,2); 
bar(metrics(:,2)); 
title('Root Mean Squared Error'); 
set(gca, 'XTickLabel', scenario_names);
ylabel('RMSE');

subplot(1,3,3); 
bar(metrics(:,3)); 
title('Peak Signal-to-Noise Ratio'); 
set(gca, 'XTickLabel', scenario_names);
ylabel('PSNR (dB)');

%% Section 5: Multi-modal Registration Simulation
fprintf('=== Section 5: Multi-modal Registration ===\n');

% Simulate different imaging modalities
infrared_sim = 1 - fixed + 0.05 * randn(size(fixed));  % Inverted + noise
infrared_sim = max(0, min(1, infrared_sim));

thermal_sim = imgaussfilt(fixed, 2) + 0.1 * randn(size(fixed));  % Blurred + noise
thermal_sim = max(0, min(1, thermal_sim));

% Cross-correlation registration
visible_norm = (fixed - mean(fixed(:))) / std(fixed(:));
infrared_norm = (infrared_sim - mean(infrared_sim(:))) / std(infrared_sim(:));

correlation = conv2(visible_norm, rot90(infrared_norm,2), 'same');
[~, max_idx] = max(correlation(:));
[max_row, max_col] = ind2sub(size(correlation), max_idx);
shift_row = max_row - round(h/2);
shift_col = max_col - round(w/2);
registered_ir = circshift(infrared_sim, [shift_row, shift_col]);

figure('Name', 'Multi-modal Registration');
subplot(2,2,1); imshow(fixed); title('Visible Light');
subplot(2,2,2); imshow(infrared_sim); title('Simulated Infrared');
subplot(2,2,3); imshow(registered_ir); title('Registered Infrared');
subplot(2,2,4); imshow(thermal_sim); title('Simulated Thermal');

%% Summary
fprintf('\n=== Image Registration Summary ===\n');
fprintf('✓ Transformation simulation completed\n');
fprintf('✓ Manual control point registration completed\n');
fprintf('✓ Automated feature detection completed\n');
fprintf('✓ Quality assessment completed\n');
fprintf('✓ Multi-modal registration demonstrated\n');
fprintf('Best registration PSNR: %.2f dB (%s)\n', ...
        max(metrics(:,3)), scenario_names{metrics(:,3) == max(metrics(:,3))});

disp('All image registration techniques successfully demonstrated!');
