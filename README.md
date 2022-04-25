# Debuggin in Julia Workshop

This Repository contains the material for the Debugging in Julia workshop for the debugging course of AaltoSciComp.

## Installation

- clone this repository and enter the folder

```
git clone https://github.com/lucaferranti/JuliaDebuggingWorkshop.git
```

```
cd JuliaDebuggingWorkshop
```

- activate and instantiate the environment

```
julia --project
```

```julia
julia> using Pkg; Pkg.instantiate()
```

- that's it, this will take care of downloading all dependencies you need. 

- **from now on, we will assume you are in the `JuliaDebuggingWorkshop` folder**

## Schedule

**Tentative** schedule

| Time | Topic  |
|:--------------:|:---------------------:|
| 12:00 -- 12:10 | welcome + ice breaker |
| 12:10 -- 12:50 | Julia overview and common julia gotchas |
| 12:50 -- 13:00 | break :coffee: |
| 13:00 -- 13:20 | Debugger.jl and Infiltrator.jl demo |
| 13:20 -- 13:40 | individual exercises |
| 13:40 -- 14:00 | exercises solution |
| 14:00 -- 14:10 | break                                         |
| 14:10 -- 14:30 | defense against dark arts: type stability, world age problem  |
| 14:30 -- 15:00 | time for extra questions/discussion/exercises | 

## Episodes

### The only one you need to know

The ultimate debugging technique is... look for help on the internet, hence let us first have a quick overview on where and how to ask help.

The Julia community is very friendly and if you get stuck there are a lot of places to get help, particularly:

- [Julia Discourse](https://discourse.julialang.org/): the julia forum, *the* place to post questions
- [Julia slack/discord/zulip](https://julialang.org/community/): chats where people passionate about julia hang out

When asking a question, it's good to remember that most people out there use their *free time* to develop open source, hence a few tips:

- be polite!
- be specific! Don't just say "I want to do X but it doesn't work", always post an example of your non-working code to show you gave a try first (this is also a smart application of [Cunningham's law](https://en.wikipedia.org/wiki/Ward_Cunningham#%22Cunningham's_Law%22))
- don't post a screenshot of your code and error message, otherwise people cannot directly copy-paste it to try, always use text
- most forums allow for syntax highlight, check it out before posting your code.
- if your code is a bigger project, try to reduce it to a Minimum Working Example (MWE), that is try to first identify what part is causing the problem (this workshop will hopefully help you) and write a short simple example demonstrating your issue. See also [stack-overflow guide](https://stackoverflow.com/help/minimal-reproducible-example) on creating MWEs.
- Not getting your answer immediately does **not** mean a whole commmunity is unwelcoming!!

### The one where you forgot to revise

In the `JuliaDebuggingWorkshop`, let's start the julia REPL and activate the environment
```
julia --project
```

this package will have all the codes we need for the workshop, let's import it with `using JuliaDebuggingWorkshop`. Let's first call the function `greet` defined in the file `JuliaDebugginWorkshop.jl`.

```
julia> greet()
Hello World!
```

now let's modify the definition of the function to return the string `Hello Universe!` and rerun it, the result will probably be

```julia
julia> greet()
Hello World!
```

why?? because by default the new updates in the code will not be loaded in the REPL. Obviously, killing and restarting the REPL everytime is not an option, for this reason, there is a beautiful package: [Revise.jl](https://github.com/timholy/Revise.jl), that will track the changes and update automatically (with a few limitations, check the docs for more info). You need to load Revise.jl **before** the package you want to modify

```julia
julia> greet()
Hello World!

julia> greet()
Hello Universe!
```

Indeed, you probably want to use Revise every time you write Julia code, hence you may want to add it to your `startup.jl` file.

> **Note: the one where it works when it shouldn't**
>
> If you are using the julia session from visual studio code (started with <kbd>Alt</kbd>+<kbd>J</kbd>+<kbd>O</kbd>), then `Revise.jl` is already loaded for you and everything is already fine

### The one where something is missing

Suppose you have a method 

```julia
myadd(x::Int, y::Int) = x + y
```

now run

```julia
julia> myadd(1.0, 2.0)
ERROR: MethodError: no method matching myadd(::Float64, ::Float64)
Stacktrace:
 [1] top-level scope
   @ REPL[6]:1
```

why? Because you imposed above that your function can only take integers as input and then you called it with floats. There are several ways to fix this, e.g.

- use a more generic type signature, e.g.
```julia
myadd(x, y) = x + y
```

```julia
myadd(x::Number, y::Number) = x + y
```

- define a new method
```julia
myadd(x::Float64, y::Float64) = x + y
```

When would you prefer the first option? when the second?

### The one where something is ambiguous

Consider the following example

```julia
f(x::Int, y::Int) = x + y
f(x, y) = x - y
```

now we have

```julia
julia> f(1, 2)
3
```

because the first method is more specific than the second and when Julia has multiple methods to pick from, it will pick the most specific one. Let us consider now the following example

```julia
g(x::Int, y) = "int and something"
g(x, y::Int) = "something and int"

```julia
julia> g(1, 1.0)
"int and something"

julia> g(1.0, 2)
"something and int"

julia> g(1, 2)
ERROR: MethodError: g(::Int64, ::Int64) is ambiguous. Candidates:
  g(x::Int64, y) in Main at REPL[10]:1
  g(x, y::Int64) in Main at REPL[11]:1
Possible fix, define
  g(::Int64, ::Int64)
Stacktrace:
 [1] top-level scope
   @ REPL[14]:1
```

In the last case, both defined methods are equally specific and hence Julia cannot know what to pick, this is known as *methods ambiguity*. A quick and easy fix (which Julia also suggests) is to define the new method to solve the ambiguity, in this case

```julia
julia> g(x::Int, y::Int) = "int and int"
g (generic function with 3 methods)

julia> g(1, 2)
"int and int"
```

This is fine most of the times, but if you have *a lot* of ambiguities, then you probably want to rethink your design, an interesting discussion with good pointers can be found [here](https://docs.julialang.org/en/v1/manual/methods/#man-method-design-ambiguities).

Finally, [Aqua.jl](https://docs.julialang.org/en/v1/manual/methods/#man-method-design-ambiguities) is a very nice package that helps detecting ambiguities in your package (and much more)! Make sure to use it in your development.

### The one where better safe then sorry

Sometimes you are not happy with the default error messages and want to throw your own errors, this can be achieved with the `throw` function

e.g. 

```julia
function mydivision(x::Number, y::Number)
    iszero(y) && throw(ArgumentError("Noo! you are dividing by zero, this can destoy the world!!"))
    return x / y
end
```

A list of available exceptions can be found [here](https://docs.julialang.org/en/v1/manual/control-flow/#Built-in-Exceptions).

With the design above, if we call the function with arguments which are not numbers, we will get a method error

```julia
julia> mydivision("123", "456")
ERROR: MethodError: no method matching mydivision(::String, ::String)
Stacktrace:
 [1] top-level scope
   @ REPL[2]:1
```

This is ok, but if you want, you can also define a fallback method with a more informative error message

```julia
mydivision(x, y) = throw(ArgumentError("expected two numbers, but got $(typeof(x)) and $(typeof(y)) instead."))
```

```juli
julia> mydivision("123", [1, 2, 3])
ERROR: ArgumentError: expected two numbers, but got String and Vector{Int64} instead.
Stacktrace:
 [1] mydivision(x::String, y::Vector{Int64})
   @ Main ./REPL[3]:1
 [2] top-level scope
   @ REPL[4]:1
```

### The one where we get serious

Interactive demo about `Debugger.jl` and `Infiltrator.jl`. This will be done using the codes in `debuggerdemo.jl` and `rref.jl`

### The one where you are on your own

Time to solve the exercises! All relevant functions are defined in the file with the corresponding exercise number, e.g. the functions for the first exercise are defined in `exercise1.j` etc. All the functions are exported, meaning that if you have imported this package, you can just call them from the REPL.

#### Exercise 1

The function `increment` should add ``1`` to the given input, but it doesn't seem to work, try to call e.g. `increment(1)`, study the error and fix it.

#### Exercise 2

This package has some tests that can be run with `using Pkg; Pkg.test()`. All tests reguard the functions in `exercise2.jl`. At the moment all tests are failing, it is your task to fix them!

**Hint!**: If you get stuck at a test and want to move on to fix the next one, you can change `@test` to `@test_skip`

#### Exercise 3

The function is `exercise3.jl` seems innocent and correct, but it actually has a bug. Try to find it and fix it!

**Note!**: This is somehow a slightly more advanced exercise, if dont like this (not everyone will!), feel free to skip it and move on.

#### Exercise 4

The functions in `exercise4.jl` have some methods ambiguities, fix them! You can either use the function `test_ambiguities(JuliaDebuggingWorkshop)` from `Aqua.jl` (remember to import it) or the built-in static code analyzer in your brain.


### The one where the instructor is there for you

Instructors will go through the solutions here.

### The one where you get unstable

Demo about type instability and how to detect it
