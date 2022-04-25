function badloop(x)
    n = length(x)
    c = zeros(Int, n)
    for i in 1:n
        c[i] += x[i]
    end
    return c
end

function complexfunction(x, y, z)
    w = x - y
    t = w + z
    p = innerfunction(w, t)
    return log(p)
end

function innerfunction(w, t)
    tmp = (w - t)/42
    e = t/3
    return tmp^e
end
