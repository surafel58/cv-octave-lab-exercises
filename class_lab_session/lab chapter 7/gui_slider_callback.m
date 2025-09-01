% GUI Slider Callback for Eigenface Viewer

global gui_eigenfaces gui_img_size gui_text_handle gui_axes_handle;

% Get current slider value
eigenface_idx = round(get(gcbo, 'Value'));
eigenface_idx = max(1, min(eigenface_idx, size(gui_eigenfaces, 2)));

% Display eigenface
axes(gui_axes_handle);
imshow(reshape(gui_eigenfaces(:, end-eigenface_idx+1), gui_img_size), []);
title(sprintf('Eigenface %d (Sorted by Eigenvalue)', eigenface_idx));

% Update text
set(gui_text_handle, 'String', sprintf('Eigenface %d', eigenface_idx));
