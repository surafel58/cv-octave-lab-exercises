% Q1: Matrix Multiplication
% This function performs matrix multiplication

function C = Q1_matrix_multiply(A, B)
    [rowsA, colsA] = size(A);
    [rowsB, colsB] = size(B);
    if colsA != rowsB
        error("Matrix dimensions do not match for multiplication");
    end
    C = zeros(rowsA, colsB);
    for i = 1:rowsA
        for j = 1:colsB
            for k = 1:colsA
                C(i,j) = C(i,j) + A(i,k) * B(k,j);
            end
        end
    end
end
