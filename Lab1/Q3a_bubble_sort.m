% Q3a: Bubble Sort
% This function sorts an array using bubble sort algorithm

function arr = Q3a_bubble_sort(arr)
    n = length(arr);
    for i = 1:n-1
        for j = 1:n-i
            if arr(j) > arr(j+1)
                temp = arr(j);
                arr(j) = arr(j+1);
                arr(j+1) = temp;
            end
        end
    end
end
