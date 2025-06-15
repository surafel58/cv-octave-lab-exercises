% Q5: Recursive Factorial
% This function calculates factorial recursively

function f = Q5_recursive_factorial(n)
    if n == 0
        f = 1;
    else
        f = n * Q5_recursive_factorial(n - 1);
    end
end
