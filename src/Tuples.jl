baremodule Tuples
using Base

# Since we're defining our own getindex and length methods to operate on types
# separately, it's difficult to then use Base's methods at the same time.
# Instead, we define them as t* within an Implementation module, and reassign
# them to the API names we want to use in this baremodule.
Base.include("implementation.jl")
const getindex = Implementation.tgetindex
const length = Implementation.tlength
const collect = Implementation.tcollect
const concatenate = Implementation.concatenate

end