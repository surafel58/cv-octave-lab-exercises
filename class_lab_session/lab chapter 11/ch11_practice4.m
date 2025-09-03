% Chapter 11 Practice 4: Automated Registration using Feature Matching
% Detect Harris corners for automated point correspondence

pkg load image;

% Load and create transformed images
fixed = im2double(imread('../images/cameraman.tif'));
moving = imrotate(fixed, 10, 'bilinear', 'crop');
moving = circshift(moving, [10, 15]);

% Manual Harris corner detection (detectHarrisFeatures alternative)
function corners = detect_harris_corners(img, threshold)
    % Compute gradients using Sobel operators for better results
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
    
    Ix = conv2(img, sobel_x, 'same');
    Iy = conv2(img, sobel_y, 'same');
    
    % Harris matrix components with Gaussian smoothing
    sigma = 1.5;
    Ix2 = imgaussfilt(Ix.^2, sigma);
    Iy2 = imgaussfilt(Iy.^2, sigma);
    Ixy = imgaussfilt(Ix.*Iy, sigma);
    
    % Harris response with improved sensitivity
    k = 0.04;
    det_M = Ix2.*Iy2 - Ixy.^2;
    trace_M = Ix2 + Iy2;
    R = det_M - k*(trace_M.^2);
    
    % Normalize response
    R = R / max(R(:));
    
    % Non-maximum suppression (Octave compatible)
    try
        R_max = ordfilt2(R, 9, ones(3,3));
        R = R .* (R == R_max);
    catch
        % Manual non-maximum suppression if ordfilt2 not available
        [h, w] = size(R);
        R_suppressed = zeros(h, w);
        for i = 2:h-1
            for j = 2:w-1
                local_max = max(max(R(i-1:i+1, j-1:j+1)));
                if R(i,j) == local_max && R(i,j) > 0
                    R_suppressed(i,j) = R(i,j);
                end
            end
        end
        R = R_suppressed;
    end
    
    % Find corners above threshold
    [y, x] = find(R > threshold);
    corners = [x, y];
    
    % Limit number of corners to most prominent ones
    if size(corners, 1) > 100
        [~, idx] = sort(R(R > threshold), 'descend');
        corners = corners(idx(1:100), :);
    end
end

% Detect corners in both images with lower threshold
corners1 = detect_harris_corners(fixed, 0.001);
corners2 = detect_harris_corners(moving, 0.001);

% If still no corners, try even lower threshold
if size(corners1, 1) == 0
    corners1 = detect_harris_corners(fixed, 0.0001);
end
if size(corners2, 1) == 0
    corners2 = detect_harris_corners(moving, 0.0001);
end

% Display detected corners
figure;
subplot(1,2,1);
imshow(fixed);
hold on;
plot(corners1(:,1), corners1(:,2), 'r+', 'MarkerSize', 8);
title(['Fixed Image - ', num2str(size(corners1,1)), ' corners']);

subplot(1,2,2);
imshow(moving);
hold on;
plot(corners2(:,1), corners2(:,2), 'r+', 'MarkerSize', 8);
title(['Moving Image - ', num2str(size(corners2,1)), ' corners']);

disp(['Detected ', num2str(size(corners1,1)), ' corners in fixed image']);
disp(['Detected ', num2str(size(corners2,1)), ' corners in moving image']);
