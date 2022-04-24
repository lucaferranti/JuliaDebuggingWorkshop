"""
    ieeelog(x)

this function computes the natural logarithm of `x`, however when `x` is negative it returns
NaN instead of an error
"""
function ieeelog(x::Float64)
    return x
end

"""
    vectorsum(x, y)

this function computes the sum of two vectors x and y
"""
function vectorsum(x, y)
    n = length(x)
    z = zeros(n)
    for i in 0:n
        z[i] = x[i] + y[i]
    end
    return z
end


"""
    myloop(x)

takes a vector of numbers `x` and a vector of errors `err` and returns teh element in `x`
which has the smallest error in `err`. (you can assume the elements in `err` are distinct).
"""
function myloop(x, err)
    minerr = 0
    xbest = 0
    for (i, xi) in enumerate(x)
        if err[i] < minerr
            xbest = xi
            minerr = err[i]
        end
    end
    return xbest
end
