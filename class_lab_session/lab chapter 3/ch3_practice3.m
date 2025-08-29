% Chapter 3 Practice 3: Region-Based Segmentation

% Load required packages
pkg load image;
pkg load statistics;

% Read image
img = imread('../images/peppers.png');

if ndims(img) == 3
  img_double = double(img);
  [rows, cols, ~] = size(img_double);

  % Reshape image into 2D array: each row = pixel, columns = R,G,B
  data = reshape(img_double, rows*cols, 3);

  % Number of clusters
  K = 3

  % Run K-means
  [idx, C] = kmeans(data, K);

  % Map each pixel to its cluster centroid color
  clustered_img = reshape(C(idx,:), rows, cols, 3) / 255;

  % Display the clustered image
  figure;
  imshow(clustered_img);
  title(sprintf('%d-Cluster RGB Segmentation', K));
end
