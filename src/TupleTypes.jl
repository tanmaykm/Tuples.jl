module TupleTypes

import Base: isvatuple

check(T) = (T===Tuple || T===NTuple) && throw(ArgumentError("parameters of $T are undefined"))

# Might as well use this for all datatypes
function getpara(T::Type)
    check(T)
    T.parameters # just return the svec, avoids allocations
end

function getpara(T::Type, i::Integer)
    check(T)
    L = length(T.parameters)
    if isvatuple(T) && i >= L
        T.parameters[end].parameters[1]
    else
        1 <= i <= L || throw(BoundsError(T, i))
        T.parameters[i]
    end
end

getpara{I<:Integer}(T::Type, is::AbstractVector{I}) = Base.svec([getpara(T,i) for i in is]...)

function concatenate{T<:Tuple, S<:Tuple}(::Type{T}, ::Type{S})
    check(T); check(S); 
    isvatuple(T) && throw(ArgumentError("cannot concatenate the varargs tuple $T with $S"))
    Tuple{T.parameters..., S.parameters...}
end


end # module
