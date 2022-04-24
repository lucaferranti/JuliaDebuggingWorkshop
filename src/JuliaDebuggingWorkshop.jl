module JuliaDebuggingWorkshop

greet() = print("Hello Universe!")

export greet,
    increment,
    vectorsum,
    ieeelog,
    myloop,
    myabs,
    mybasket, Banana, Apple, Tuna, Salmon

include("exercise1.jl")
include("exercise2.jl")
include("exercise3.jl")
include("exercise4.jl")
end # module
