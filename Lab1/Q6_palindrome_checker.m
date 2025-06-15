% Q6: Palindrome Checker
% This function checks if a string is a palindrome

function isPalin = Q6_palindrome_checker(s)
    s = tolower(regexprep(s, '[^a-zA-Z0-9]', ''));
    isPalin = strcmp(s, fliplr(s));
end
