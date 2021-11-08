#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
Pkg.add("CSV")

#                   --------------------------------------------------                   #

using Parameters
using Classes
using DataFrames
using StaticArrays
using DelimitedFiles
using CSV

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

#creates reservoir structs

@with_kw mutable struct Ocean
    volume::BigFloat = 0.0 #only significant for ocean
    Nfraction::BigFloat = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Crust
    Nfraction::BigFloat = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Mantle
    Nfraction::BigFloat = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Atmosphere
    Nfraction::BigFloat = 0.0 #fraction of Planetary Nitrogen mass in atmosphere
    NMass::BigFloat = 0.0 # mass of Nitrogen in atmosphere
    Mass::BigFloat = 0.0 # mass of atmosphere
end

@with_kw mutable struct PlanetaryBody
    NMass::BigFloat = 0.0 # Mass of all N on planet
    NFraction::BigFloat = 1.0
    Mass::BigFloat = 0.0 # Mass of Planet
    ocean::Ocean
    crust::Crust
    atmosphere::Atmosphere
    mantle::Mantle
end

#                   --------------------------------------------------                   #

# Initialize the resevoirs

#= Planet = PlanetaryBody(Mass = 6e24,
                       ocean = Ocean(volume = 1.3e18,NMass = 2.4e16),
                       crust = Crust(NMass = 1.9e18),
                       mantle = Mantle(NMass = 4e18),
                       atmosphere = Atmosphere(Mass = 4e18,NMass = 2.8e19),
                       NMass = (Planet.ocean.NMass + Planet.crust.NMass + 
                                Planet.mantle.NMass + Planet.atmosphere.NMass))

Planet.ocean.Nfraction = Planet.ocean.NMass/Planet.NMass
Planet.crust.Nfraction = Planet.crust.NMass/Planet.NMass
Planet.mantle.Nfraction = Planet.mantle.NMass/Planet.NMass
Planet.atmosphere.Nfraction = Planet.atmosphere.NMass/Planet.NMass
t = 1 =#

#                   --------------------------------------------------                   #

#= Monitor = DataFrame(time = Int64[],
                    VOcean = BigFloat[],
                    OceanNFraction = Float64[],
                    OceanNMass = BigFloat[],
                    CrustNFraction = Float64[],
                    CrustNMass = BigFloat[],
                    AtmosphereNFraction = Float64[],
                    AtmosphereNMass = BigFloat[],
                    MantleNFraction = Float64[],
                    MantleNMass = BigFloat[],
                    NMassTotal = BigFloat[])       

push!(Monitor, [t, 
                Planet.ocean.volume, 
                Planet.NMass,
                Planet.ocean.Nfraction, 
                Planet.ocean.NMass,
                Planet.crust.Nfraction, 
                Planet.crust.NMass,
                Planet.atmosphere.Nfraction, 
                Planet.atmosphere.NMass,
                Planet.mantle.Nfraction, 
                Planet.mantle.NMass]) =#

#                   --------------------------------------------------                   #