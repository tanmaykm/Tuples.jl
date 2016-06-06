using Tuples
using Base.Test

## Tuples.collect

@test Tuples.collect(Tuple{}) === Core.svec()
@test Tuples.collect(Tuple{1,2,3}) === Core.svec(1,2,3)
@test Tuples.collect(Tuple{Int,AbstractString}) === Core.svec(Int,AbstractString)
@test_throws ArgumentError Tuples.collect(Tuple)
@test_throws ArgumentError Tuples.collect(NTuple)
#@test_throws ArgumentError Tuples.collect(Tuple{Vararg{Int}})
#@test_throws ArgumentError Tuples.collect(Tuple{AbstractString,Vararg{Int}})

## Tuples.getindex
@test Tuples.getindex(Tuple{1,2,3}, 1) === 1
@test Tuples.getindex(Tuple{1,2,3}, 2) === 2
@test Tuples.getindex(Tuple{1,2,3}, 3) === 3
@test Tuples.getindex(Tuple{1,2,3}, Val{1}) === 1
@test Tuples.getindex(Tuple{1,2,3}, Val{2}) === 2
@test Tuples.getindex(Tuple{1,2,3}, Val{3}) === 3
@test Tuples.getindex(Tuple{1,2,3}, 2:3) === Base.svec(2,3)
@test_throws BoundsError Tuples.getindex(Tuple{1,2,3}, 0)
@test_throws BoundsError Tuples.getindex(Tuple{1,2,3}, 4)
@test_throws BoundsError Tuples.getindex(Tuple{1,2,3}, Val{0})
@test_throws BoundsError Tuples.getindex(Tuple{1,2,3}, Val{4})
@test Tuples.getindex(Tuple{Int, AbstractString}, 1) === Int
@test Tuples.getindex(Tuple{Int, AbstractString}, 2) === AbstractString
@test Tuples.getindex(Tuple{Int, AbstractString}, Val{1}) === Int
@test Tuples.getindex(Tuple{Int, AbstractString}, Val{2}) === AbstractString
@test Tuples.getindex(Tuple{Int, AbstractString}, [2,1]) === Base.svec(AbstractString,Int)
@test_throws BoundsError Tuples.getindex(Tuple{Int, AbstractString}, 0)
@test_throws BoundsError Tuples.getindex(Tuple{Int, AbstractString}, 3)
@test_throws BoundsError Tuples.getindex(Tuple{Int, AbstractString}, Val{0})
@test_throws BoundsError Tuples.getindex(Tuple{Int, AbstractString}, Val{3})
@test_throws ArgumentError Tuples.getindex(Tuple, 1)
@test_throws ArgumentError Tuples.getindex(NTuple, 1)
@test Tuples.getindex(Tuple{Vararg{Int}}, Val{1}) === Int
@test Tuples.getindex(Tuple{Vararg{Int}}, Val{1000}) === Int
@test Tuples.getindex(Tuple{Vararg{Int}}, Val{10^10}) === Int
@test Tuples.getindex(Tuple{Vararg{Int}}, [10^10, 10^10+1]) === Base.svec(Int,Int)
@test_throws BoundsError Tuples.getindex(Tuple{Vararg{Int}}, 0)
@test_throws BoundsError Tuples.getindex(Tuple{Vararg{Int}}, Val{0})
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, 1) === Int
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, 2) === AbstractString
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, 3) === AbstractString
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, Val{1}) === Int
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, Val{2}) === AbstractString
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, Val{3}) === AbstractString
@test Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, [1,3]) === Base.svec(Int,AbstractString)
@test_throws BoundsError Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, 0)
@test_throws BoundsError Tuples.getindex(Tuple{Int, Vararg{AbstractString}}, Val{0})

# bug in Julia https://github.com/JuliaLang/julia/issues/11725
f{T<:Integer}(::T, ::T) = 1
fm = first(methods(f))
g{I<:Integer}(::I, ::I) = 1
gm = first(methods(g))
@test Tuples.getindex(fm.sig, 1)==fm.sig.parameters[1]
@test Tuples.getindex(gm.sig, 1)==gm.sig.parameters[1]


## Concatenate

@test Tuples.concatenate(Tuple{}, Tuple{}) === Tuple{}
@test Tuples.concatenate(Tuple{Int}, Tuple{}) === Tuple{Int}
@test Tuples.concatenate(Tuple{}, Tuple{Int}) === Tuple{Int}
@test Tuples.concatenate(Tuple{Int}, Tuple{AbstractString}) === Tuple{Int,AbstractString}
@test Tuples.concatenate(Tuple{1,2,3}, Tuple{4,5,6}) === Tuple{1,2,3,4,5,6}
@test Tuples.concatenate(Tuple{}, Tuple{Vararg{Int}}) === Tuple{Vararg{Int}}
@test Tuples.concatenate(Tuple{AbstractString}, Tuple{Int, Vararg{AbstractString}}) === Tuple{AbstractString, Int, Vararg{AbstractString}}
@test_throws ArgumentError Tuples.concatenate(Tuple, Tuple{Int})
@test_throws ArgumentError Tuples.concatenate(Tuple{}, Tuple)
@test_throws ArgumentError Tuples.concatenate(Tuple{Vararg{AbstractString}}, Tuple{Int})


## Length

@test Tuples.length(Tuple{}) === 0
@test Tuples.length(Tuple{Int}) === 1
@test Tuples.length(Tuple{Int8, Int16}) === 2
@test Tuples.length(Tuple{Int8, Int16, Int32}) === 3
@test Tuples.length(Tuple{Int8, Int16, Int32, Int64}) === 4
@test Tuples.length(Tuple{Vararg{AbstractString}}) === 1
@test Tuples.length(Tuple{Int,Vararg{AbstractString}}) === 2
@test Tuples.length(Tuple{Int8, Int16,Vararg{AbstractString}}) === 3
@test Tuples.length(Tuple{Int8, Int16, Int32,Vararg{AbstractString}}) === 4
@test Tuples.length(Tuple{Int8, Int16, Int32, Int64,Vararg{AbstractString}}) === 5


# Test NTuple
@test NTuple(i->Val{i}, 1) === Tuple{Val{1}}
@test NTuple(i->Val{i}, 2) === Tuple{Val{1}, Val{2}}
@test NTuple(i->Val{i}, 3) === Tuple{Val{1}, Val{2}, Val{3}}
@test NTuple(i->Val{i}, 4) === Tuple{Val{1}, Val{2}, Val{3}, Val{4}}
