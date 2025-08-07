% Setup Directories for Lab2
% This script creates all necessary directories for Lab2 functions

fprintf('Setting up Lab2 directories...\n');

% Create main directories
directories = {
    'images/',
    'images/test_images/',
    'images/downloaded/',
    'images/processed/'
};

for i = 1:length(directories)
    dir_path = directories{i};
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
        fprintf('Created: %s\n', dir_path);
    else
        fprintf('Already exists: %s\n', dir_path);
    end
end

fprintf('\nDirectory setup completed!\n');
fprintf('You can now run Lab2 functions without directory errors.\n');