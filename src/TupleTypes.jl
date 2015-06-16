module TupleTypes

import Base: isvatuple


check{T}(::Type{T}) = (T===Tuple || T===NTuple) && throw(ArgumentError("parameters of $T are undefined"))
# (Needs the parameters: https://github.com/JuliaLang/julia/issues/11712)

# Might as well use this for all datatypes
function getpara{T}(::Type{T})
    check(T)
    T.parameters # just return the svec, avoids allocations
end

function getpara{T}(::Type{T}, i::Integer)
    check(T)
    L = length(T.parameters)
    if isvatuple(T) && i >= L
        T.parameters[end].parameters[1]
    else
        1 <= i <= L || throw(BoundsError(T, i))
        T.parameters[i]
    end
end

getpara{T}(::Type{T}, is::Integer...) = Base.svec([getpara(T,i) for i in is]...)

function concatenate{T<:Tuple, S<:Tuple}(::Type{T}, ::Type{S})
    check(T); check(S); 
    isvatuple(T) && throw(ArgumentError("cannot concatenate the varargs tuple $T with $S"))
    Tuple{T.parameters..., S.parameters...}
end


end # module
