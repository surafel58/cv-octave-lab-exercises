% Chapter 11 Practice 2: Manual Control Point Registration
% Interactive point selection between moving and fixed images

pkg load image;

% Load and create transformed images
fixed = im2double(imread('../images/cameraman.tif'));
moving = imrotate(fixed, 10, 'bilinear', 'crop');
moving = circshift(moving, [10, 15]);

% Display images for reference
figure('Name', 'Reference Images');
subplot(1,2,1); imshow(fixed); title('Fixed Image (Target)');
subplot(1,2,2); imshow(moving); title('Moving Image (Source - to be aligned)');

disp('=== Understanding Control Point Registration ===');
disp('Goal: Find matching points between images to calculate transformation');
disp('The moving image needs to be aligned to match the fixed image');
disp(' ');

% Manual control point selection using cpselect (as per lab instruction)
try
    % Try using cpselect as specified in lab manual
    disp('Using cpselect for point selection...');
    [mp, fp] = cpselect(moving, fixed, 'Wait', true);
    disp('Control points selected using cpselect');
    
catch
    % Fallback to ginput if cpselect is not available
    disp('cpselect not available, using manual point selection...');
    disp(' ');
    disp('INSTRUCTIONS:');
    disp('1. First: Click on distinctive features in the FIXED image (target)');
    disp('2. Then: Click on the SAME features in the MOVING image');
    disp('3. Click features that are easy to identify (corners, edges, etc.)');
    disp(' ');
    
    % Get number of points to select
    num_points = 4;
    fprintf('You will select %d corresponding point pairs\n', num_points);
    disp(' ');
    
    % Select points in FIXED image first (clearer workflow)
    figure('Name', 'Step 1: Select Points in Fixed Image');
    imshow(fixed);
    title('STEP 1: Fixed Image - Click on distinctive features');
    hold on;
    disp('STEP 1: Click on distinctive features in the FIXED image...');
    disp('(Look for corners, edges, or unique patterns)');
    [fx, fy] = ginput(num_points);
    fp = [fx, fy];
    
    % Plot selected points on fixed image
    plot(fx, fy, 'go', 'MarkerSize', 10, 'LineWidth', 3);
    for i = 1:length(fx)
        text(fx(i)+5, fy(i)-5, num2str(i), 'Color', 'green', 'FontSize', 14, 'FontWeight', 'bold');
    end
    title('STEP 1 COMPLETE: Fixed Image - Selected Points');
    disp(' ');
    disp('Good! Now find the SAME features in the moving image...');
    disp(' ');
    
    % Select corresponding points in moving image  
    figure('Name', 'Step 2: Select Corresponding Points in Moving Image');
    imshow(moving);
    title('STEP 2: Moving Image - Click on the SAME features in the SAME ORDER');
    hold on;
    disp('STEP 2: Click on the CORRESPONDING features in the MOVING image...');
    disp('IMPORTANT: Click the same features in the SAME ORDER (1,2,3,4)');
    [mx, my] = ginput(num_points);
    mp = [mx, my];
    
    % Plot selected points on moving image
    plot(mx, my, 'ro', 'MarkerSize', 10, 'LineWidth', 3);
    for i = 1:length(mx)
        text(mx(i)+5, my(i)-5, num2str(i), 'Color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
    end
    title('STEP 2 COMPLETE: Moving Image - Selected Points');
end

% Show final correspondence visualization
figure('Name', 'Control Point Correspondence Results');
subplot(1,2,1);
imshow(fixed); hold on;
plot(fp(:,1), fp(:,2), 'go', 'MarkerSize', 10, 'LineWidth', 3);
for i = 1:size(fp,1)
    text(fp(i,1)+5, fp(i,2)-5, num2str(i), 'Color', 'green', 'FontSize', 14, 'FontWeight', 'bold');
end
title('Fixed Image Points (GREEN)');

subplot(1,2,2);
imshow(moving); hold on;
plot(mp(:,1), mp(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 3);
for i = 1:size(mp,1)
    text(mp(i,1)+5, mp(i,2)-5, num2str(i), 'Color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
end
title('Moving Image Points (RED)');

% Display results with clear explanation
disp(' ');
disp('=== CONTROL POINT SELECTION COMPLETE ===');
disp('Selected corresponding point pairs:');
for i = 1:size(mp,1)
    fprintf('Pair %d: Fixed(%.1f,%.1f) <-> Moving(%.1f,%.1f)\n', ...
            i, fp(i,1), fp(i,2), mp(i,1), mp(i,2));
end
disp(' ');
disp('NEXT STEP: These points will be used in Practice 3 to:');
disp('- Calculate the geometric transformation between images');
disp('- Register (align) the moving image to the fixed image');
disp('- Evaluate registration accuracy');
disp(' ');
disp('SUCCESS: Point correspondence established!');
