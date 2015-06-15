using TupleTypes
using Base.Test

import TupleTypes: getpara, concatenate

## getpara

@test getpara(Tuple{}) === Core.svec()
@test getpara(Tuple{1,2,3}) === Core.svec(1,2,3)
@test getpara(Tuple{Int,String}) === Core.svec(Int,String)
@test_throws ArgumentError getpara(Tuple)
@test_throws ArgumentError getpara(NTuple)
#@test_throws ArgumentError getpara(Tuple{Vararg{Int}})
#@test_throws ArgumentError getpara(Tuple{String,Vararg{Int}})

## getpara
@test getpara(Tuple{1,2,3}, 1) === 1
@test getpara(Tuple{1,2,3}, 2) === 2
@test getpara(Tuple{1,2,3}, 3) === 3
@test_throws BoundsError getpara(Tuple{1,2,3}, 0)
@test_throws BoundsError getpara(Tuple{1,2,3}, 4)
@test getpara(Tuple{Int, String}, 1) === Int
@test getpara(Tuple{Int, String}, 2) === String
@test_throws BoundsError getpara(Tuple{Int, String}, 0)
@test_throws BoundsError getpara(Tuple{Int, String}, 3)
@test_throws ArgumentError getpara(Tuple, 1)
@test_throws ArgumentError getpara(NTuple, 1)
@test getpara(Tuple{Vararg{Int}}, 1) === Int
@test getpara(Tuple{Vararg{Int}}, 1000) === Int
@test getpara(Tuple{Vararg{Int}}, 10^10) === Int
@test_throws BoundsError getpara(Tuple{Vararg{Int}}, 0)
@test getpara(Tuple{Int, Vararg{String}}, 1) === Int
@test getpara(Tuple{Int, Vararg{String}}, 2) === String
@test getpara(Tuple{Int, Vararg{String}}, 3) === String
@test_throws BoundsError getpara(Tuple{Int, Vararg{String}}, 0)

## Concatenate

@test concatenate(Tuple{}, Tuple{}) === Tuple{}
@test concatenate(Tuple{Int}, Tuple{}) === Tuple{Int}
@test concatenate(Tuple{}, Tuple{Int}) === Tuple{Int}
@test concatenate(Tuple{Int}, Tuple{String}) === Tuple{Int,String}
@test concatenate(Tuple{1,2,3}, Tuple{4,5,6}) === Tuple{1,2,3,4,5,6}
@test concatenate(Tuple{}, Tuple{Vararg{Int}}) === Tuple{Vararg{Int}}
@test concatenate(Tuple{String}, Tuple{Int, Vararg{String}}) === Tuple{String, Int, Vararg{String}}
@test_throws ArgumentError concatenate(Tuple, Tuple{Int})
@test_throws ArgumentError concatenate(Tuple{}, Tuple)
@test_throws ArgumentError concatenate(Tuple{Vararg{String}}, Tuple{Int})
