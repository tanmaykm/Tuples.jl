module TupleTypes

import Base: isvatuple

function parameters{T<:Tuple}(::Type{T})
    if isvatuple(T) || T===Tuple || T===NTuple
        throw(ArgumentError("elements of $T are undefined"))
    end
    (T.parameters...)
end

function getparam{T<:Tuple}(::Type{T}, i::Integer)
    (T===Tuple || T===NTuple) && throw(ArgumentError("parameters of $T are undefined"))
    L = length(T.parameters)
    if isvatuple(T) && i >= L
        T.parameters[end].parameters[1]
    else
        1 <= i <= L || throw(BoundsError(T, i))
        T.parameters[i]
    end
end

function concatenate{T<:Tuple, S<:Tuple}(::Type{T}, ::Type{S})
    (T===Tuple || T===NTuple || S===Tuple || S===NTuple) && throw(ArgumentError("parameters of $T or $S is undefined"))
    isvatuple(T) && throw(ArgumentError("cannot concatenate the varargs tuple $T with $S"))
    Tuple{T.parameters..., S.parameters...}
end


end # module
