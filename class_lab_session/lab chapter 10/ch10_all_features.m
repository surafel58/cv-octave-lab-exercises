% Chapter 10: Complete Feature Extraction and Recognition Overview

pkg load image;
img = im2double(imread('../images/cameraman.tif'));

fprintf('Building complete feature extraction overview...\n');

% Extract all types of features
edges_canny = edge(img, 'canny');
edges_sobel = edge(img, 'sobel');
corners = cornermetric(img);
corner_thresh = corners > 0.05 * max(corners(:));
[corner_r, corner_c] = find(corner_thresh);

% LoG blob detection
log_filter = fspecial('log', [5 5], 0.5);
blob_img = imfilter(img, log_filter, 'replicate');
blob_response = -blob_img;
blob_thresh = blob_response > 0.02;
[blob_r, blob_c] = find(blob_thresh);

% Template matching example
template_patch = img(80:99, 120:139);
corr_result = normxcorr2(template_patch, img);
[max_corr, idx] = max(corr_result(:));
[y_match, x_match] = ind2sub(size(corr_result), idx);

% Multi-scale corner detection
scales = [0.8, 1.0, 1.2];
multiscale_corners = {};
for s = 1:length(scales)
    if scales(s) == 1.0
        img_scale = img;
    else
        img_scale = imresize(img, scales(s));
        img_scale = imresize(img_scale, size(img));
    end
    corners_scale = cornermetric(img_scale);
    corner_thresh_scale = corners_scale > 0.05 * max(corners_scale(:));
    [r_scale, c_scale] = find(corner_thresh_scale);
    multiscale_corners{s} = [r_scale, c_scale];
end

% Feature statistics
feature_stats = struct();
feature_stats.total_pixels = numel(img);
feature_stats.edge_pixels_canny = sum(edges_canny(:));
feature_stats.edge_pixels_sobel = sum(edges_sobel(:));
feature_stats.corner_points = length(corner_r);
feature_stats.blob_points = length(blob_r);
feature_stats.mean_intensity = mean(img(:));
feature_stats.std_intensity = std(img(:));
feature_stats.max_corner_response = max(corners(:));
feature_stats.template_correlation = max_corr;

% Create comprehensive display
figure('Position', [50, 50, 1600, 1000], 'Name', 'Complete Feature Extraction Overview');

% Row 1: Basic features
subplot(4, 5, 1); imshow(img); title('Original Image', 'FontWeight', 'bold', 'FontSize', 12);
subplot(4, 5, 2); imshow(edges_canny); title('Canny Edges', 'FontSize', 11);
subplot(4, 5, 3); imshow(edges_sobel); title('Sobel Edges', 'FontSize', 11);
subplot(4, 5, 4); imshow(corners, []); title('Corner Response', 'FontSize', 11); colormap(gca, 'hot');
subplot(4, 5, 5); imshow(blob_img, []); title('LoG Response', 'FontSize', 11); colormap(gca, 'jet');

% Row 2: Feature points overlaid
subplot(4, 5, 6); imshow(img); hold on; 
plot(corner_c, corner_r, 'r*', 'MarkerSize', 4);
title(sprintf('Harris Corners (%d)', length(corner_r)), 'FontSize', 11);

subplot(4, 5, 7); imshow(img); hold on;
plot(blob_c, blob_r, 'go', 'MarkerSize', 6, 'LineWidth', 2);
title(sprintf('LoG Blobs (%d)', length(blob_r)), 'FontSize', 11);

subplot(4, 5, 8); imshow(img); hold on;
rectangle('Position', [x_match-size(template_patch,2)/2, y_match-size(template_patch,1)/2, ...
                      size(template_patch,2), size(template_patch,1)], 'EdgeColor', 'g', 'LineWidth', 2);
title('Template Match', 'FontSize', 11);

subplot(4, 5, 9); imshow(template_patch);
title('Template', 'FontSize', 11);

subplot(4, 5, 10); imshow(corr_result, []);
title('Correlation Map', 'FontSize', 11); colorbar;

% Row 3: Multi-scale features
for s = 1:3
    subplot(4, 5, 10 + s);
    imshow(img); hold on;
    corners_at_scale = multiscale_corners{s};
    if ~isempty(corners_at_scale)
        plot(corners_at_scale(:,2), corners_at_scale(:,1), 'bo', 'MarkerSize', 4);
    end
    title(sprintf('Scale %.1fx (%d)', scales(s), size(corners_at_scale, 1)), 'FontSize', 10);
end

% Combined multi-scale visualization
subplot(4, 5, 14);
imshow(img); hold on;
colors = {'r', 'g', 'b'};
for s = 1:3
    corners_at_scale = multiscale_corners{s};
    if ~isempty(corners_at_scale)
        plot(corners_at_scale(:,2), corners_at_scale(:,1), [colors{s} 'o'], 'MarkerSize', 3);
    end
end
title('Multi-scale Combined', 'FontSize', 10);
legend({'Scale 0.8x', 'Scale 1.0x', 'Scale 1.2x'}, 'Location', 'best', 'FontSize', 8);

% Feature statistics visualization
subplot(4, 5, 15);
feature_counts = [feature_stats.edge_pixels_canny, feature_stats.edge_pixels_sobel, ...
                  feature_stats.corner_points, feature_stats.blob_points];
feature_names = {'Canny', 'Sobel', 'Corners', 'Blobs'};
bar(feature_counts);
set(gca, 'XTickLabel', feature_names, 'FontSize', 9);
title('Feature Counts', 'FontSize', 10);
ylabel('Count');

% Row 4: Analysis and comparison
subplot(4, 5, 16);
edge_comparison = [feature_stats.edge_pixels_canny, feature_stats.edge_pixels_sobel];
pie(edge_comparison);
title('Edge Detection Comparison', 'FontSize', 10);
legend({'Canny', 'Sobel'}, 'Location', 'best', 'FontSize', 8);

subplot(4, 5, 17);
% Feature density (features per 1000 pixels)
densities = 1000 * [feature_stats.corner_points, feature_stats.blob_points] / feature_stats.total_pixels;
bar(densities);
set(gca, 'XTickLabel', {'Corners', 'Blobs'});
title('Feature Density', 'FontSize', 10);
ylabel('Per 1000 Pixels');

% Intensity histogram with features marked
subplot(4, 5, 18);
histogram(img(:), 50, 'Normalization', 'probability');
hold on;
% Mark mean intensities of corner and blob regions
if ~isempty(corner_r)
    corner_intensities = [];
    for k = 1:min(length(corner_r), 100) % Sample to avoid too many points
        corner_intensities = [corner_intensities, img(corner_r(k), corner_c(k))];
    end
    xline(mean(corner_intensities), 'r--', 'LineWidth', 2);
end
title('Intensity Distribution', 'FontSize', 10);
xlabel('Intensity');
ylabel('Probability');

% Performance metrics
subplot(4, 5, 19);
metrics = [feature_stats.template_correlation, feature_stats.max_corner_response, ...
           feature_stats.std_intensity];
metric_names = {'Template Corr', 'Max Corner', 'Intensity Std'};
bar(metrics);
set(gca, 'XTickLabel', metric_names, 'FontSize', 8);
title('Quality Metrics', 'FontSize', 10);

% Feature combination visualization
subplot(4, 5, 20);
imshow(img); hold on;
% Overlay all features with different colors and markers
plot(corner_c, corner_r, 'r*', 'MarkerSize', 4);
plot(blob_c, blob_r, 'go', 'MarkerSize', 4);
% Add edge overlay
edge_overlay = cat(3, edges_canny*0.5, edges_canny*0.5, ones(size(edges_canny)));
h = imshow(edge_overlay); set(h, 'AlphaData', edges_canny*0.3);
title('All Features Combined', 'FontSize', 10);

% Add main title and section labels
annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Complete Feature Extraction and Recognition Overview', ...
           'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

annotation('textbox', [0.02, 0.82, 0.1, 0.03], 'String', 'Basic Features:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.62, 0.1, 0.03], 'String', 'Feature Points:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.42, 0.1, 0.03], 'String', 'Multi-scale:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.22, 0.1, 0.03], 'String', 'Analysis:', ...
           'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'EdgeColor', 'none');

% Print comprehensive analysis
fprintf('\n=== COMPLETE FEATURE EXTRACTION ANALYSIS ===\n');
fprintf('Image Information:\n');
fprintf('  Size: %dx%d pixels\n', size(img, 1), size(img, 2));
fprintf('  Mean intensity: %.3f\n', feature_stats.mean_intensity);
fprintf('  Intensity std: %.3f\n', feature_stats.std_intensity);

fprintf('\nEdge Features:\n');
fprintf('  Canny edges: %d pixels (%.2f%% coverage)\n', ...
        feature_stats.edge_pixels_canny, 100*feature_stats.edge_pixels_canny/feature_stats.total_pixels);
fprintf('  Sobel edges: %d pixels (%.2f%% coverage)\n', ...
        feature_stats.edge_pixels_sobel, 100*feature_stats.edge_pixels_sobel/feature_stats.total_pixels);

fprintf('\nCorner Features:\n');
fprintf('  Harris corners: %d detected\n', feature_stats.corner_points);
fprintf('  Corner density: %.2f per 1000 pixels\n', 1000*feature_stats.corner_points/feature_stats.total_pixels);
fprintf('  Max corner response: %.6f\n', feature_stats.max_corner_response);

fprintf('\nBlob Features:\n');
fprintf('  LoG blobs: %d detected\n', feature_stats.blob_points);
fprintf('  Blob density: %.2f per 1000 pixels\n', 1000*feature_stats.blob_points/feature_stats.total_pixels);

fprintf('\nTemplate Matching:\n');
fprintf('  Best correlation: %.4f\n', feature_stats.template_correlation);
fprintf('  Match location: (%d, %d)\n', x_match-size(template_patch,2)/2, y_match-size(template_patch,1)/2);

fprintf('\nMulti-scale Analysis:\n');
for s = 1:length(scales)
    fprintf('  Scale %.1fx: %d corners\n', scales(s), size(multiscale_corners{s}, 1));
end

total_features = feature_stats.edge_pixels_canny + feature_stats.corner_points + feature_stats.blob_points;
fprintf('\nSummary:\n');
fprintf('  Total features detected: %d\n', total_features);
fprintf('  Feature richness: %.1f features per 100 pixels\n', 100*total_features/feature_stats.total_pixels);
fprintf('  Most prominent: %s\n', feature_names{find(feature_counts == max(feature_counts))});
