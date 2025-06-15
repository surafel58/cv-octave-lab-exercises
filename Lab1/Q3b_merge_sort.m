% Q3b: Merge Sort
% This function sorts an array using merge sort algorithm

function arr = Q3b_merge_sort(arr)
    if length(arr) <= 1
        return;
    end
    mid = floor(length(arr)/2);
    left = Q3b_merge_sort(arr(1:mid));
    right = Q3b_merge_sort(arr(mid+1:end));
    arr = merge(left, right);
end

function result = merge(left, right)
    result = [];
    while ~isempty(left) && ~isempty(right)
        if left(1) <= right(1)
            result(end+1) = left(1);
            left(1) = [];
        else
            result(end+1) = right(1);
            right(1) = [];
        end
    end
    result = [result, left, right];
end
