#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####


using Parameters
using Classes
using DataFrames
using StaticArrays



#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

@with_kw mutable struct Ocean
    volume::Float64 = 0.0 # volume of ocean in Liters
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::Float64 = 0.0 #mass
end

@with_kw mutable struct Crust
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::Float64 = 0.0 #mass
end

@with_kw mutable struct Mantle
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::Float64 = 0.0 #mass
end

@with_kw mutable struct Atmosphere
    volume::Float64 = 0.0 # volume of atmosphere in Liters
    Nfraction::Float64 = 0.0 #fraction of Planetary Nitrogen mass in atmosphere
    NMass::Float64 = 0.0 # mass of Nitrogen in atmosphere
end

@with_kw mutable struct PlanetaryBody
    NMass::Float64 = 0.0 # Mass of all N on planet
    Mass::Float64 = 0.0 # Mass of Planet
    ocean::Ocean
    crust::Crust
    atmosphere::Atmosphere
    mantle::Mantle
end

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####