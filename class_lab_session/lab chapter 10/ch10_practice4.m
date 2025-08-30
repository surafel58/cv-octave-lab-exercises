% Chapter 10 Practice 4: Feature Matching and Recognition

% Load image
pkg load image;
img = im2double(imread('../images/cameraman.tif'));

% 5.1 Feature Descriptor (Simplified - Intensity Patch)
patch1 = img(30:39, 40:49); % Patch from reference image
imshow(patch1);
title('Template Patch');

% 5.2 Template Matching (Correlation-Based)
figure('Position', [100, 100, 1400, 800]);

subplot(2, 4, 1);
imshow(img);
title('Original Image', 'FontWeight', 'bold');

subplot(2, 4, 2);
imshow(patch1);
title('Template Patch');

% Perform normalized cross-correlation
corr_result = normxcorr2(patch1, img);
[max_corr, idx] = max(corr_result(:));
[y, x] = ind2sub(size(corr_result), idx);

subplot(2, 4, 3);
imshow(corr_result, []);
title('Correlation Result');
colorbar;

subplot(2, 4, 4);
imshow(img);
hold on;
rectangle('Position', [x-9, y-9, 10, 10], 'EdgeColor', 'g');
title('Matched Template Location');

% Try multiple template patches
patch2 = img(80:89, 120:129); % Different patch
patch3 = img(150:159, 200:209); % Another patch

corr_result2 = normxcorr2(patch2, img);
corr_result3 = normxcorr2(patch3, img);

[max_corr2, idx2] = max(corr_result2(:));
[y2, x2] = ind2sub(size(corr_result2), idx2);

[max_corr3, idx3] = max(corr_result3(:));
[y3, x3] = ind2sub(size(corr_result3), idx3);

subplot(2, 4, 5);
imshow(patch2);
title('Template Patch 2');

subplot(2, 4, 6);
imshow(patch3);
title('Template Patch 3');

subplot(2, 4, 7);
imshow(img); hold on;
rectangle('Position', [x-9, y-9, 10, 10], 'EdgeColor', 'g', 'LineWidth', 2);
rectangle('Position', [x2-9, y2-9, 10, 10], 'EdgeColor', 'r', 'LineWidth', 2);
rectangle('Position', [x3-9, y3-9, 10, 10], 'EdgeColor', 'b', 'LineWidth', 2);
title('All Template Matches');
legend('Patch 1', 'Patch 2', 'Patch 3', 'Location', 'best');

% Correlation scores comparison
subplot(2, 4, 8);
corr_scores = [max_corr, max_corr2, max_corr3];
bar(corr_scores);
set(gca, 'XTickLabel', {'Patch 1', 'Patch 2', 'Patch 3'});
title('Correlation Scores');
ylabel('Max Correlation');
grid on;

annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Template Matching and Feature Recognition', ...
           'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'EdgeColor', 'none');

% Detailed matching analysis
fprintf('Template Matching Results:\n');
fprintf('=========================\n');
fprintf('Patch 1 (30:39, 40:49):\n');
fprintf('  - Best match at: (%d, %d)\n', x-size(patch1,2)/2, y-size(patch1,1)/2);
fprintf('  - Correlation score: %.4f\n', max_corr);
fprintf('  - Mean patch intensity: %.4f\n', mean(patch1(:)));

fprintf('\nPatch 2 (80:89, 120:129):\n');
fprintf('  - Best match at: (%d, %d)\n', x2-size(patch2,2)/2, y2-size(patch2,1)/2);
fprintf('  - Correlation score: %.4f\n', max_corr2);
fprintf('  - Mean patch intensity: %.4f\n', mean(patch2(:)));

fprintf('\nPatch 3 (150:159, 200:209):\n');
fprintf('  - Best match at: (%d, %d)\n', x3-size(patch3,2)/2, y3-size(patch3,1)/2);
fprintf('  - Correlation score: %.4f\n', max_corr3);
fprintf('  - Mean patch intensity: %.4f\n', mean(patch3(:)));

fprintf('\nBest matching patch: Patch %d with score %.4f\n', find(corr_scores == max(corr_scores)), max(corr_scores));
