abstract type Food end
abstract type Fruit <: Food end
abstract type Fish <: Food end

struct Banana <: Fruit end
struct Apple <: Fruit end

struct Tuna <: Fish end
struct Salmon <: Fish end

mybasket(::Tuna, ::Fruit) = "I have tuna and some fruit"
mybasket(::Salmon, ::Fruit) = "I have salmon and some fruit"

mybasket(::Fruit, ::Food) = "I have fruit and some food"
mybasket(::Fish, ::Apple) = "I have some fish and an apple"

mybasket(::Food, ::Food) = "I have food"
