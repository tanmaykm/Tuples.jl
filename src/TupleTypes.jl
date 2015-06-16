module TupleTypes

import Base: isvatuple

check(T) = (T===Tuple || T===NTuple) && throw(ArgumentError("parameters of $T are undefined"))

# Define methods for up to N tuple parameters to be evaluated in the Type domain
const N=4
ie = :()
for p=0:N
    params = ntuple(i->symbol(:P,i), p)
    global getpara, concatenate
    # Return the whole parameter list as an svec
    @eval getpara{$(params...)}(::Type{Tuple{$(params...)}}) = Base.svec($(params...))

    # Accessing by a constant value
    for i=1:p
        @eval getpara{$(params...)}(::Type{Tuple{$(params...)}}, ::Type{Val{$i}}) = $(params[i])
    end
    @eval getpara{$(params...), n}(t::Type{Tuple{$(params...)}}, ::Type{Val{n}}) = throw(BoundsError(t, n))

    # Accessing by a non-constant selects the proper value with an ifelse chain
    if p == 1
        ie = :(P1)
    elseif p > 1
        ie = :(ifelse(i == $p, $(params[p]), $ie))
    end
    @eval getpara{$(params...)}(t::Type{Tuple{$(params...)}}, i::Int) = (1 <= i <= $p || throw(BoundsError(t, i)); $ie)
    # It'd be nice to simply define the constant `i` computation in the type 
    # domain instead of relying upon dispatch, but it's not constant-folding:
    # @eval getparam{$(params...), i}(t::Type{Tuple{$(params...)}}, ::Type{Val{i}}) = (1 <= i <= $p || throw(BoundsError(t, i)); $ie)

    # concatenation
    for q=0:N
        qarams = ntuple(i->symbol(:Q,i), q)
        @eval concatenate{$(params...), $(qarams...)}(::Type{Tuple{$(params...)}},::Type{Tuple{$(qarams...)}}) = Tuple{$(params...), $(qarams...)}
    end
end


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
