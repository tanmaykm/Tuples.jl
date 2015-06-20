using Types
using Base.Test

## Types.collect

@test Types.collect(Tuple{}) === Core.svec()
@test Types.collect(Tuple{1,2,3}) === Core.svec(1,2,3)
@test Types.collect(Tuple{Int,String}) === Core.svec(Int,String)
@test_throws ArgumentError Types.collect(Tuple)
@test_throws ArgumentError Types.collect(NTuple)
#@test_throws ArgumentError Types.collect(Tuple{Vararg{Int}})
#@test_throws ArgumentError Types.collect(Tuple{String,Vararg{Int}})

## Types.getindex
@test Types.getindex(Tuple{1,2,3}, 1) === 1
@test Types.getindex(Tuple{1,2,3}, 2) === 2
@test Types.getindex(Tuple{1,2,3}, 3) === 3
@test Types.getindex(Tuple{1,2,3}, Val{1}) === 1
@test Types.getindex(Tuple{1,2,3}, Val{2}) === 2
@test Types.getindex(Tuple{1,2,3}, Val{3}) === 3
@test Types.getindex(Tuple{1,2,3}, 2:3) === Base.svec(2,3)
@test_throws BoundsError Types.getindex(Tuple{1,2,3}, 0)
@test_throws BoundsError Types.getindex(Tuple{1,2,3}, 4)
@test_throws BoundsError Types.getindex(Tuple{1,2,3}, Val{0})
@test_throws BoundsError Types.getindex(Tuple{1,2,3}, Val{4})
@test Types.getindex(Tuple{Int, String}, 1) === Int
@test Types.getindex(Tuple{Int, String}, 2) === String
@test Types.getindex(Tuple{Int, String}, Val{1}) === Int
@test Types.getindex(Tuple{Int, String}, Val{2}) === String
@test Types.getindex(Tuple{Int, String}, [2,1]) === Base.svec(String,Int)
@test_throws BoundsError Types.getindex(Tuple{Int, String}, 0)
@test_throws BoundsError Types.getindex(Tuple{Int, String}, 3)
@test_throws BoundsError Types.getindex(Tuple{Int, String}, Val{0})
@test_throws BoundsError Types.getindex(Tuple{Int, String}, Val{3})
@test_throws ArgumentError Types.getindex(Tuple, 1)
@test_throws ArgumentError Types.getindex(NTuple, 1)
@test Types.getindex(Tuple{Vararg{Int}}, Val{1}) === Int
@test Types.getindex(Tuple{Vararg{Int}}, Val{1000}) === Int
@test Types.getindex(Tuple{Vararg{Int}}, Val{10^10}) === Int
@test Types.getindex(Tuple{Vararg{Int}}, [10^10, 10^10+1]) === Base.svec(Int,Int)
@test_throws BoundsError Types.getindex(Tuple{Vararg{Int}}, 0)
@test_throws BoundsError Types.getindex(Tuple{Vararg{Int}}, Val{0})
@test Types.getindex(Tuple{Int, Vararg{String}}, 1) === Int
@test Types.getindex(Tuple{Int, Vararg{String}}, 2) === String
@test Types.getindex(Tuple{Int, Vararg{String}}, 3) === String
@test Types.getindex(Tuple{Int, Vararg{String}}, Val{1}) === Int
@test Types.getindex(Tuple{Int, Vararg{String}}, Val{2}) === String
@test Types.getindex(Tuple{Int, Vararg{String}}, Val{3}) === String
@test Types.getindex(Tuple{Int, Vararg{String}}, [1,3]) === Base.svec(Int,String)
@test_throws BoundsError Types.getindex(Tuple{Int, Vararg{String}}, 0)
@test_throws BoundsError Types.getindex(Tuple{Int, Vararg{String}}, Val{0})

# bug in Julia https://github.com/JuliaLang/julia/issues/11725
f{T<:Integer}(::T, ::T) = 1
fm = first(methods(f))
g{I<:Integer}(::I, ::I) = 1
gm = first(methods(g))
@test Types.getindex(fm.sig, 1)==fm.sig.parameters[1]
@test Types.getindex(gm.sig, 1)==gm.sig.parameters[1]


## Concatenate

@test Types.concatenate(Tuple{}, Tuple{}) === Tuple{}
@test Types.concatenate(Tuple{Int}, Tuple{}) === Tuple{Int}
@test Types.concatenate(Tuple{}, Tuple{Int}) === Tuple{Int}
@test Types.concatenate(Tuple{Int}, Tuple{String}) === Tuple{Int,String}
@test Types.concatenate(Tuple{1,2,3}, Tuple{4,5,6}) === Tuple{1,2,3,4,5,6}
@test Types.concatenate(Tuple{}, Tuple{Vararg{Int}}) === Tuple{Vararg{Int}}
@test Types.concatenate(Tuple{String}, Tuple{Int, Vararg{String}}) === Tuple{String, Int, Vararg{String}}
@test_throws ArgumentError Types.concatenate(Tuple, Tuple{Int})
@test_throws ArgumentError Types.concatenate(Tuple{}, Tuple)
@test_throws ArgumentError Types.concatenate(Tuple{Vararg{String}}, Tuple{Int})


## Length

@test Types.length(Tuple{}) === 0
@test Types.length(Tuple{Int}) === 1
@test Types.length(Tuple{Int8, Int16}) === 2
@test Types.length(Tuple{Int8, Int16, Int32}) === 3
@test Types.length(Tuple{Int8, Int16, Int32, Int64}) === 4
@test Types.length(Tuple{Vararg{String}}) === 1
@test Types.length(Tuple{Int,Vararg{String}}) === 2
@test Types.length(Tuple{Int8, Int16,Vararg{String}}) === 3
@test Types.length(Tuple{Int8, Int16, Int32,Vararg{String}}) === 4
@test Types.length(Tuple{Int8, Int16, Int32, Int64,Vararg{String}}) === 5
