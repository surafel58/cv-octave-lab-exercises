% Q2: Bisection Method
% This function finds the root of a function using bisection method

function root = Q2_bisection_method(f, a, b, tol)
    if f(a) * f(b) > 0
        error("Function must have opposite signs at a and b");
    end
    while (b - a)/2 > tol
        c = (a + b) / 2;
        if f(c) == 0
            break;
        elseif f(a)*f(c) < 0
            b = c;
        else
            a = c;
        end
    end
    root = (a + b) / 2;
end
