using TupleTypes
using Base.Test

## TupleTypes.collect

@test TupleTypes.collect(Tuple{}) === Core.svec()
@test TupleTypes.collect(Tuple{1,2,3}) === Core.svec(1,2,3)
@test TupleTypes.collect(Tuple{Int,String}) === Core.svec(Int,String)
@test_throws ArgumentError TupleTypes.collect(Tuple)
@test_throws ArgumentError TupleTypes.collect(NTuple)
#@test_throws ArgumentError TupleTypes.collect(Tuple{Vararg{Int}})
#@test_throws ArgumentError TupleTypes.collect(Tuple{String,Vararg{Int}})

## TupleTypes.getindex
@test TupleTypes.getindex(Tuple{1,2,3}, 1) === 1
@test TupleTypes.getindex(Tuple{1,2,3}, 2) === 2
@test TupleTypes.getindex(Tuple{1,2,3}, 3) === 3
@test TupleTypes.getindex(Tuple{1,2,3}, 2:3) === Base.svec(2,3)
@test_throws BoundsError TupleTypes.getindex(Tuple{1,2,3}, 0)
@test_throws BoundsError TupleTypes.getindex(Tuple{1,2,3}, 4)
@test TupleTypes.getindex(Tuple{Int, String}, 1) === Int
@test TupleTypes.getindex(Tuple{Int, String}, 2) === String
@test TupleTypes.getindex(Tuple{Int, String}, [2,1]) === Base.svec(String,Int)
@test_throws BoundsError TupleTypes.getindex(Tuple{Int, String}, 0)
@test_throws BoundsError TupleTypes.getindex(Tuple{Int, String}, 3)
@test_throws ArgumentError TupleTypes.getindex(Tuple, 1)
@test_throws ArgumentError TupleTypes.getindex(NTuple, 1)
@test TupleTypes.getindex(Tuple{Vararg{Int}}, 1) === Int
@test TupleTypes.getindex(Tuple{Vararg{Int}}, 1000) === Int
@test TupleTypes.getindex(Tuple{Vararg{Int}}, 10^10) === Int
@test TupleTypes.getindex(Tuple{Vararg{Int}}, [10^10, 10^10+1]) === Base.svec(Int,Int)
@test_throws BoundsError TupleTypes.getindex(Tuple{Vararg{Int}}, 0)
@test TupleTypes.getindex(Tuple{Int, Vararg{String}}, 1) === Int
@test TupleTypes.getindex(Tuple{Int, Vararg{String}}, 2) === String
@test TupleTypes.getindex(Tuple{Int, Vararg{String}}, 3) === String
@test TupleTypes.getindex(Tuple{Int, Vararg{String}}, [1,3]) === Base.svec(Int,String)
@test_throws BoundsError TupleTypes.getindex(Tuple{Int, Vararg{String}}, 0)

# bug in Julia https://github.com/JuliaLang/julia/issues/11725
f{T<:Integer}(::T, ::T) = 1
fm = first(methods(f))
g{I<:Integer}(::I, ::I) = 1
gm = first(methods(g))
@test TupleTypes.getindex(fm.sig, 1)==fm.sig.parameters[1]
@test TupleTypes.getindex(gm.sig, 1)==gm.sig.parameters[1]


## Concatenate

@test TupleTypes.concatenate(Tuple{}, Tuple{}) === Tuple{}
@test TupleTypes.concatenate(Tuple{Int}, Tuple{}) === Tuple{Int}
@test TupleTypes.concatenate(Tuple{}, Tuple{Int}) === Tuple{Int}
@test TupleTypes.concatenate(Tuple{Int}, Tuple{String}) === Tuple{Int,String}
@test TupleTypes.concatenate(Tuple{1,2,3}, Tuple{4,5,6}) === Tuple{1,2,3,4,5,6}
@test TupleTypes.concatenate(Tuple{}, Tuple{Vararg{Int}}) === Tuple{Vararg{Int}}
@test TupleTypes.concatenate(Tuple{String}, Tuple{Int, Vararg{String}}) === Tuple{String, Int, Vararg{String}}
@test_throws ArgumentError TupleTypes.concatenate(Tuple, Tuple{Int})
@test_throws ArgumentError TupleTypes.concatenate(Tuple{}, Tuple)
@test_throws ArgumentError TupleTypes.concatenate(Tuple{Vararg{String}}, Tuple{Int})
