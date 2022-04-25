module JuliaDebuggingWorkshop

greet() = print("Hello World!")

export greet,
    badloop, complexfunction,
    increment,
    vectorsum,
    ieeelog,
    myloop,
    myabs,
    rref,
    mybasket, Banana, Apple, Tuna, Salmon

include("exercise1.jl")
include("exercise2.jl")
include("exercise3.jl")
include("exercise4.jl")
include("debuggerdemo.jl")
include("rref.jl")
end # module
