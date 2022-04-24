"""
    myabs(x)

computes the absolute value of x, definition here: https://en.wikipedia.org/wiki/Absolute_value#Real_numbers
"""
function myabs(x::Real)
    if x ≥ 0
        return x
    else
        return -x
    end
end

# fallback method, here we don't care about complex numbers
myabs(x) = throw(ArgumentError("My abs is defined only for real numbers"))
