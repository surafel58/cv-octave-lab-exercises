% Chapter 11 Practice 3: Estimating the Geometric Transformation
% Applies affine transformation using control points

pkg load image;

% Load and create transformed images
fixed = im2double(imread('../images/cameraman.tif'));
moving = imrotate(fixed, 10, 'bilinear', 'crop');
moving = circshift(moving, [10, 15]);

% Control points (from practice 2)
mp = [100, 120; 200, 150; 150, 200]; % Moving image points
fp = [110, 130; 210, 160; 160, 210]; % Fixed image points

% Estimate geometric transformation using fitgeotrans (as per lab instruction)
try
    % Try using fitgeotrans as specified in lab manual
    tform = fitgeotrans(mp, fp, 'affine');
    
    % Apply transformation using imwarp
    registered = imwarp(moving, tform, 'OutputView', imref2d(size(fixed)));
    disp('Transformation applied using fitgeotrans and imwarp');
    
catch
    % Fallback to manual implementation if functions not available
    disp('fitgeotrans/imwarp not available, using manual implementation...');
    
    % Manual affine transformation estimation
    A = [mp ones(size(mp,1),1)];
    tform_x = A \ fp(:,1);
    tform_y = A \ fp(:,2);
    
    % Create 3x3 transformation matrix properly
    T = [tform_x(1), tform_x(2), tform_x(3);
         tform_y(1), tform_y(2), tform_y(3);
         0,          0,          1];
    
    % Apply transformation manually
    [h, w] = size(fixed);
    [X, Y] = meshgrid(1:w, 1:h);
    coords = [X(:), Y(:), ones(numel(X),1)];
    new_coords = coords * T';
    X_new = reshape(new_coords(:,1), h, w);
    Y_new = reshape(new_coords(:,2), h, w);
    
    % Register using interpolation
    registered = interp2(moving, X_new, Y_new, 'linear', 0);
end

% Display results using imshowpair (as per lab instruction)
try
    % Try using imshowpair as specified in lab manual
    figure;
    imshowpair(fixed, registered, 'montage');
    title('Fixed Image (Left) vs Registered Image (Right)');
    
catch
    % Fallback to manual display if imshowpair not available
    disp('imshowpair not available, using manual display...');
    figure;
    subplot(1,3,1); 
    imshow(fixed); 
    title('Fixed Image');
    
    subplot(1,3,2); 
    imshow(registered); 
    title('Registered Image');
    
    subplot(1,3,3); 
    imshow(abs(fixed - registered), []); 
    title('Difference');
end

disp('Affine transformation applied successfully');
