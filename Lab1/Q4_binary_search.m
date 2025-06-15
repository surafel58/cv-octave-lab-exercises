% Q4: Binary Search
% This function searches for an element in a sorted array using binary search

function index = Q4_binary_search(arr, key)
    low = 1;
    high = length(arr);
    index = -1;
    while low <= high
        mid = floor((low + high) / 2);
        if arr(mid) == key
            index = mid;
            return;
        elseif arr(mid) < key
            low = mid + 1;
        else
            high = mid - 1;
        end
    end
end
