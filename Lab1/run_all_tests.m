% Lab 1 - Run All Tests
% This script tests all the functions implemented in Lab 1

fprintf('=======================================================\n');
fprintf('             LAB 1 - COMPREHENSIVE TESTING\n');
fprintf('=======================================================\n\n');

% Test Q1: Matrix Multiplication
fprintf('Q1: Matrix Multiplication Test\n');
fprintf('-------------------------------\n');
A = [1, 2; 3, 4];
B = [5, 6; 7, 8];
fprintf('Matrix A:\n');
disp(A);
fprintf('Matrix B:\n');
disp(B);
fprintf('Result A * B:\n');
result_q1 = Q1_matrix_multiply(A, B);
disp(result_q1);
fprintf('\n');

% Test Q2: Bisection Method
fprintf('Q2: Bisection Method Test\n');
fprintf('--------------------------\n');
f = @(x) x^3 - x - 2;
fprintf('Function: f(x) = x^3 - x - 2\n');
fprintf('Finding root in interval [1, 2] with tolerance 1e-5\n');
root = Q2_bisection_method(f, 1, 2, 1e-5);
fprintf('Root found: %.6f\n', root);
fprintf('Verification f(%.6f) = %.6f\n', root, f(root));
fprintf('\n');

% Test Q3a: Bubble Sort
fprintf('Q3a: Bubble Sort Test\n');
fprintf('---------------------\n');
test_array = [5, 1, 4, 2, 8];
fprintf('Original array: ');
disp(test_array);
sorted_bubble = Q3a_bubble_sort(test_array);
fprintf('Sorted array:   ');
disp(sorted_bubble);
fprintf('\n');

% Test Q3b: Merge Sort
fprintf('Q3b: Merge Sort Test\n');
fprintf('--------------------\n');
test_array = [5, 1, 4, 2, 8];
fprintf('Original array: ');
disp(test_array);
sorted_merge = Q3b_merge_sort(test_array);
fprintf('Sorted array:   ');
disp(sorted_merge);
fprintf('\n');

% Test Q3c: Quick Sort
fprintf('Q3c: Quick Sort Test\n');
fprintf('--------------------\n');
test_array = [5, 1, 4, 2, 8];
fprintf('Original array: ');
disp(test_array);
sorted_quick = Q3c_quick_sort(test_array);
fprintf('Sorted array:   ');
disp(sorted_quick);
fprintf('\n');

% Test Q4: Binary Search
fprintf('Q4: Binary Search Test\n');
fprintf('----------------------\n');
search_array = [1, 3, 5, 7, 9];
search_key = 5;
fprintf('Sorted array: ');
disp(search_array);
fprintf('Searching for: %d\n', search_key);
index = Q4_binary_search(search_array, search_key);
if index ~= -1
    fprintf('Element found at index: %d\n', index);
else
    fprintf('Element not found\n');
end
fprintf('\n');

% Test Q5: Recursive Factorial
fprintf('Q5: Recursive Factorial Test\n');
fprintf('-----------------------------\n');
n = 5;
fprintf('Calculating factorial of %d\n', n);
factorial_result = Q5_recursive_factorial(n);
fprintf('%d! = %d\n', n, factorial_result);
fprintf('\n');

% Test Q6: Palindrome Checker
fprintf('Q6: Palindrome Checker Test\n');
fprintf('----------------------------\n');
test_strings = {"Racecar", "A man a plan a canal Panama", "Hello", "Was it a rat I saw"};
for i = 1:length(test_strings)
    str = test_strings{i};
    is_palin = Q6_palindrome_checker(str);
    if is_palin
        result_str = "Palindrome";
    else
        result_str = "Not a palindrome";
    end
    fprintf('"%s" -> %s\n', str, result_str);
end
fprintf('\n');

% Test Q7: Statistical Functions
fprintf('Q7: Statistical Functions Test\n');
fprintf('-------------------------------\n');
data = [1, 2, 4, 2, 6, 2, 9];
fprintf('Data set: ');
disp(data);
stats = Q7_stats_functions(data);
fprintf('Mean:             %.2f\n', stats.mean);
fprintf('Median:           %.2f\n', stats.median);
fprintf('Mode:             %.2f\n', stats.mode);
fprintf('\n');

fprintf('=======================================================\n');
fprintf('                 ALL TESTS COMPLETED\n');
fprintf('=======================================================\n'); 