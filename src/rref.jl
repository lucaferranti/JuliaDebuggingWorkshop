rref(A) = rref!(copy(A))

function rref!(A::AbstractMatrix)
    m, n = size(A)
    minmn = min(m,n)
    @inbounds for k = 1:minmn

        if k < m
            # find maximum index
            absmax, kp = _findmax_abs(view(A, k:m, k))
            iszero(absmax) && throw(ArgumentError("Could not find a pivot with non-zero absolute value in column $k."))
            kp += k - 1

            # Swap rows k and kp if needed
            k != kp && _swap!(A, k, kp)
        end

        # Scale first column
        _scale!(A, k)

        # Update the rest
        _eliminate!(A, k)
    end
    return A
end


@inline function _findmax_abs(v)

    @inbounds begin
        absmax = abs(first(v))
        kp = firstindex(v)

        for (i, vi) in enumerate(v)
            absi = abs(vi)
            if absi < absmax
                kp = i
                absmax = absi
            end
        end
    end
    return absmax, kp
end


@inline function _swap!(A, k, kp)
    @inbounds for i = 1:size(A, 2)
        tmp = A[k,i]
        A[k,i] = A[kp,i]
        A[kp,i] = tmp
    end
end

@inline function _scale!(A, k)
    @inbounds begin
        Akkinv = inv(A[k,k])
        for i = k+1:size(A, 1)
            A[i,k] *= Akkinv
        end
    end
end

@inline function _eliminate!(A, k)
    m, n = size(A)
    @inbounds begin
        for j = k+1:n
            for i = k+1:m
                A[i,j] -= A[i,k]*A[k,j]
            end
        end

        for i = k+1:m
            A[i, k] = zero(eltype(A))
        end
    end
end
