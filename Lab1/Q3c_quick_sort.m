% Q3c: Quick Sort
% This function sorts an array using quick sort algorithm

function arr = Q3c_quick_sort(arr)
    if length(arr) <= 1
        return;
    end
    pivot = arr(1);
    left = arr(arr < pivot);
    mid = arr(arr == pivot);
    right = arr(arr > pivot);
    arr = [Q3c_quick_sort(left), mid, Q3c_quick_sort(right)];
end
