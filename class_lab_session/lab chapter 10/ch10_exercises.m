% Chapter 10 Exercises: Advanced Feature Extraction and Recognition

pkg load image;
img = im2double(imread('../images/cameraman.tif'));

fprintf('Starting Chapter 10 Exercises...\n\n');

%% Exercise 1: Apply corner detection on different standard images
fprintf('Exercise 1: Corner Detection on Different Images\n');

% Load different test images (using available images)
img_cameraman = im2double(imread('../images/cameraman.tif'));
img_coins = im2double(imread('../images/coins.png'));

% Convert color image to grayscale if needed
if size(img_coins, 3) == 3
    img_coins = rgb2gray(img_coins);
end

% Try to load peppers if available, otherwise create synthetic test image
try
    img_peppers = im2double(imread('../images/peppers.png'));
    if size(img_peppers, 3) == 3
        img_peppers = rgb2gray(img_peppers);
    end
catch
    % Create synthetic test image with geometric shapes
    img_peppers = zeros(256, 256);
    img_peppers(50:150, 50:150) = 1; % Square
    img_peppers(180:220, 180:220) = 0.7; % Smaller square
    img_peppers = imgaussfilt(img_peppers, 1); % Smooth edges
end

test_images = {img_cameraman, img_coins, img_peppers};
image_names = {'Cameraman', 'Coins', 'Test Pattern'};

figure('Position', [50, 50, 1600, 800]);

corner_stats = zeros(3, 3); % [image_idx, threshold_level]
thresholds = [0.01, 0.05, 0.1];

for i = 1:length(test_images)
    % Compute Harris corners
    corners = cornermetric(test_images{i});
    
    subplot(3, 6, (i-1)*6 + 1);
    imshow(test_images{i});
    title(sprintf('%s Original', image_names{i}), 'FontWeight', 'bold');
    
    subplot(3, 6, (i-1)*6 + 2);
    imshow(corners, []);
    title('Corner Response');
    colormap(gca, 'hot');
    
    % Different thresholds
    for j = 1:3
        corner_thresh = corners > thresholds(j) * max(corners(:));
        [r, c] = find(corner_thresh);
        corner_stats(i, j) = length(r);
        
        subplot(3, 6, (i-1)*6 + 2 + j);
        imshow(test_images{i}); hold on;
        plot(c, r, 'r*', 'MarkerSize', 6);
        title(sprintf('%.0f%% Thresh (%d corners)', thresholds(j)*100, length(r)));
    end
    
    % Statistics plot
    subplot(3, 6, (i-1)*6 + 6);
    bar(thresholds*100, corner_stats(i, :));
    title('Corners vs Threshold');
    xlabel('Threshold %');
    ylabel('# Corners');
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 1: Corner Detection Comparison', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 2: Matching patches from rotated or scaled versions
fprintf('Exercise 2: Template Matching with Geometric Transformations\n');

% Create transformed versions of the image
angle_rotation = 30; % degrees
scale_factor = 0.8;

% Rotation
img_rotated = imrotate(img, angle_rotation, 'bilinear', 'crop');

% Scaling
img_scaled = imresize(img, scale_factor);
img_scaled_padded = padarray(img_scaled, [floor((size(img,1)-size(img_scaled,1))/2), ...
                                         floor((size(img,2)-size(img_scaled,2))/2)], 0, 'both');
if size(img_scaled_padded, 1) < size(img, 1)
    img_scaled_padded = padarray(img_scaled_padded, [1, 0], 0, 'post');
end
if size(img_scaled_padded, 2) < size(img, 2)
    img_scaled_padded = padarray(img_scaled_padded, [0, 1], 0, 'post');
end

% Extract distinctive patch from original (face region)
patch_size = 20;
patch_row = 100;
patch_col = 150;
template_patch = img(patch_row:patch_row+patch_size-1, patch_col:patch_col+patch_size-1);

% Template matching on transformed images
corr_original = normxcorr2(template_patch, img);
corr_rotated = normxcorr2(template_patch, img_rotated);
corr_scaled = normxcorr2(template_patch, img_scaled_padded);

% Find best matches
[max_corr_orig, idx_orig] = max(corr_original(:));
[y_orig, x_orig] = ind2sub(size(corr_original), idx_orig);

[max_corr_rot, idx_rot] = max(corr_rotated(:));
[y_rot, x_rot] = ind2sub(size(corr_rotated), idx_rot);

[max_corr_scale, idx_scale] = max(corr_scaled(:));
[y_scale, x_scale] = ind2sub(size(corr_scaled), idx_scale);

figure('Position', [100, 100, 1400, 800]);

% Row 1: Original images
subplot(3, 4, 1); imshow(img); title('Original Image', 'FontWeight', 'bold');
subplot(3, 4, 2); imshow(img_rotated); title(sprintf('Rotated %d°', angle_rotation));
subplot(3, 4, 3); imshow(img_scaled_padded); title(sprintf('Scaled %.1fx', scale_factor));
subplot(3, 4, 4); imshow(template_patch); title('Template Patch');

% Row 2: Correlation maps
subplot(3, 4, 5); imshow(corr_original, []); title('Original Correlation'); colorbar;
subplot(3, 4, 6); imshow(corr_rotated, []); title('Rotated Correlation'); colorbar;
subplot(3, 4, 7); imshow(corr_scaled, []); title('Scaled Correlation'); colorbar;

% Row 3: Matched results
subplot(3, 4, 9);
imshow(img); hold on;
rectangle('Position', [x_orig-patch_size/2, y_orig-patch_size/2, patch_size, patch_size], 'EdgeColor', 'g', 'LineWidth', 2);
title(sprintf('Original Match (%.3f)', max_corr_orig));

subplot(3, 4, 10);
imshow(img_rotated); hold on;
rectangle('Position', [x_rot-patch_size/2, y_rot-patch_size/2, patch_size, patch_size], 'EdgeColor', 'g', 'LineWidth', 2);
title(sprintf('Rotated Match (%.3f)', max_corr_rot));

subplot(3, 4, 11);
imshow(img_scaled_padded); hold on;
rectangle('Position', [x_scale-patch_size/2, y_scale-patch_size/2, patch_size, patch_size], 'EdgeColor', 'g', 'LineWidth', 2);
title(sprintf('Scaled Match (%.3f)', max_corr_scale));

% Matching performance comparison
subplot(3, 4, 12);
match_scores = [max_corr_orig, max_corr_rot, max_corr_scale];
bar(match_scores);
set(gca, 'XTickLabel', {'Original', 'Rotated', 'Scaled'});
title('Matching Performance');
ylabel('Correlation Score');

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 2: Geometric Transformation Matching', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 3: SIFT/ORB Alternative - Multi-scale Corner Detection
fprintf('Exercise 3: Multi-scale Feature Detection (SIFT/ORB Alternative)\n');

% Since external SIFT/ORB toolboxes might not be available, implement multi-scale detection
scales = [0.8, 1.0, 1.2, 1.5];
all_keypoints = [];

figure('Position', [50, 100, 1400, 800]);

for s = 1:length(scales)
    % Scale the image
    if scales(s) == 1.0
        img_scale = img;
    else
        img_scale = imresize(img, scales(s));
        img_scale = imresize(img_scale, size(img)); % Resize back for comparison
    end
    
    % Detect corners at this scale
    corners_scale = cornermetric(img_scale);
    corner_thresh = corners_scale > 0.05 * max(corners_scale(:));
    [r_scale, c_scale] = find(corner_thresh);
    
    % Store keypoints with scale information
    for k = 1:length(r_scale)
        all_keypoints = [all_keypoints; r_scale(k), c_scale(k), scales(s), corners_scale(r_scale(k), c_scale(k))];
    end
    
    subplot(2, 4, s);
    imshow(img_scale); hold on;
    plot(c_scale, r_scale, 'ro', 'MarkerSize', 4);
    title(sprintf('Scale %.1fx (%d features)', scales(s), length(r_scale)));
end

% Combine all keypoints and remove duplicates
if size(all_keypoints, 1) > 0
    % Simple non-maximum suppression
    keypoint_radius = 10;
    unique_keypoints = [];
    
    for i = 1:size(all_keypoints, 1)
        is_unique = true;
        for j = 1:size(unique_keypoints, 1)
            dist = sqrt((all_keypoints(i,1) - unique_keypoints(j,1))^2 + ...
                       (all_keypoints(i,2) - unique_keypoints(j,2))^2);
            if dist < keypoint_radius
                % Keep the stronger response
                if all_keypoints(i,4) > unique_keypoints(j,4)
                    unique_keypoints(j,:) = all_keypoints(i,:);
                end
                is_unique = false;
                break;
            end
        end
        if is_unique
            unique_keypoints = [unique_keypoints; all_keypoints(i,:)];
        end
    end
else
    unique_keypoints = [];
end

% Display final keypoints
subplot(2, 4, 5);
imshow(img); hold on;
if size(unique_keypoints, 1) > 0
    scatter(unique_keypoints(:,2), unique_keypoints(:,1), unique_keypoints(:,3)*50, 'r', 'filled');
end
title(sprintf('Multi-scale Features (%d)', size(unique_keypoints, 1)));

% Feature descriptor visualization (simplified)
if size(unique_keypoints, 1) > 0
    % Show patches around top keypoints
    [~, sorted_idx] = sort(unique_keypoints(:,4), 'descend');
    top_features = min(3, size(unique_keypoints, 1));
    
    for f = 1:top_features
        idx = sorted_idx(f);
        r = round(unique_keypoints(idx, 1));
        c = round(unique_keypoints(idx, 2));
        patch_size = 16;
        
        if r > patch_size/2 && r <= size(img,1) - patch_size/2 && ...
           c > patch_size/2 && c <= size(img,2) - patch_size/2
            patch = img(r-patch_size/2:r+patch_size/2-1, c-patch_size/2:c+patch_size/2-1);
            subplot(2, 4, 5 + f);
            imshow(patch);
            title(sprintf('Feature %d Patch', f));
        end
    end
end

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 3: Multi-scale Feature Detection', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Exercise 4: Basic Recognition Pipeline
fprintf('Exercise 4: Multi-feature Recognition Pipeline\n');

% Step 1: Extract multiple types of features
edges_canny = edge(img, 'canny');
corners = cornermetric(img);
corner_points = corners > 0.05 * max(corners(:));
log_filter = fspecial('log', [5 5], 0.5);
blob_response = -imfilter(img, log_filter, 'replicate');
blob_points = blob_response > 0.02;

% Step 2: Create feature vector for the image
feature_vector = [
    sum(edges_canny(:)), ...           % Total edge pixels
    sum(corner_points(:)), ...         % Total corner points
    sum(blob_points(:)), ...          % Total blob points
    mean(corners(:)), ...             % Mean corner response
    std(corners(:)), ...              % Corner response variance
    mean(img(:)), ...                 % Mean intensity
    std(img(:))                       % Intensity variance
];

% Step 3: Test on image patches for recognition
patch_size = 64;
num_patches = 9;
patch_features = zeros(num_patches, length(feature_vector));

figure('Position', [100, 150, 1400, 800]);

patch_idx = 1;
for row = 1:3
    for col = 1:3
        % Extract patch
        r_start = (row-1) * patch_size + 50;
        c_start = (col-1) * patch_size + 50;
        r_end = min(r_start + patch_size - 1, size(img, 1));
        c_end = min(c_start + patch_size - 1, size(img, 2));
        
        patch = img(r_start:r_end, c_start:c_end);
        
        % Extract features for this patch
        patch_edges = edge(patch, 'canny');
        patch_corners = cornermetric(patch);
        patch_corner_points = patch_corners > 0.05 * max(patch_corners(:));
        patch_blob_response = -imfilter(patch, log_filter, 'replicate');
        patch_blob_points = patch_blob_response > 0.02;
        
        patch_features(patch_idx, :) = [
            sum(patch_edges(:)), ...
            sum(patch_corner_points(:)), ...
            sum(patch_blob_points(:)), ...
            mean(patch_corners(:)), ...
            std(patch_corners(:)), ...
            mean(patch(:)), ...
            std(patch(:))
        ];
        
        % Display patch
        subplot(4, 4, patch_idx);
        imshow(patch);
        title(sprintf('Patch %d', patch_idx));
        
        % Overlay features
        hold on;
        [pr, pc] = find(patch_corner_points);
        plot(pc, pr, 'r*', 'MarkerSize', 3);
        
        patch_idx = patch_idx + 1;
    end
end

% Feature similarity analysis
feature_distances = zeros(num_patches, 1);
for i = 1:num_patches
    % Normalize features and compute distance from whole image
    norm_patch = patch_features(i, :) ./ max(abs(patch_features(i, :)) + eps);
    norm_whole = feature_vector ./ max(abs(feature_vector) + eps);
    feature_distances(i) = norm(norm_patch - norm_whole);
end

% Display feature analysis
subplot(4, 4, 10);
bar(feature_distances);
title('Feature Distance from Whole Image');
xlabel('Patch Number');
ylabel('Normalized Distance');

% Most/least representative patches
[~, most_similar] = min(feature_distances);
[~, least_similar] = max(feature_distances);

subplot(4, 4, 11);
bar(patch_features(most_similar, :));
title(sprintf('Most Similar Patch %d Features', most_similar));

subplot(4, 4, 12);
bar(patch_features(least_similar, :));
title(sprintf('Least Similar Patch %d Features', least_similar));

% Feature correlation matrix
subplot(4, 4, 13:16);
correlation_matrix = corrcoef(patch_features);
imagesc(correlation_matrix);
colorbar;
title('Feature Correlation Matrix');
feature_labels = {'Edges', 'Corners', 'Blobs', 'Corner Mean', 'Corner Std', 'Intensity Mean', 'Intensity Std'};
set(gca, 'XTick', 1:length(feature_labels), 'XTickLabel', feature_labels, 'XTickLabelRotation', 45);
set(gca, 'YTick', 1:length(feature_labels), 'YTickLabel', feature_labels);

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Exercise 4: Multi-feature Recognition Pipeline', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

%% Summary Report
fprintf('\n=== CHAPTER 10 EXERCISES SUMMARY ===\n');
fprintf('Exercise 1 - Corner Detection Comparison:\n');
for i = 1:length(image_names)
    fprintf('  %s: %d corners (1%% thresh)\n', image_names{i}, corner_stats(i, 1));
end

fprintf('\nExercise 2 - Geometric Transformation Matching:\n');
fprintf('  Original: %.3f correlation\n', max_corr_orig);
fprintf('  Rotated (30°): %.3f correlation (%.1f%% of original)\n', max_corr_rot, 100*max_corr_rot/max_corr_orig);
fprintf('  Scaled (0.8x): %.3f correlation (%.1f%% of original)\n', max_corr_scale, 100*max_corr_scale/max_corr_orig);

fprintf('\nExercise 3 - Multi-scale Feature Detection:\n');
fprintf('  Total keypoints found: %d\n', size(all_keypoints, 1));
fprintf('  Unique keypoints after NMS: %d\n', size(unique_keypoints, 1));

fprintf('\nExercise 4 - Recognition Pipeline:\n');
fprintf('  Whole image features: [%.0f edges, %.0f corners, %.0f blobs]\n', ...
        feature_vector(1), feature_vector(2), feature_vector(3));
fprintf('  Most representative patch: %d (distance: %.3f)\n', most_similar, feature_distances(most_similar));
fprintf('  Least representative patch: %d (distance: %.3f)\n', least_similar, feature_distances(least_similar));

fprintf('\nAll exercises completed successfully!\n');
