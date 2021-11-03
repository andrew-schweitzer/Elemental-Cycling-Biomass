#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
using Parameters
using Classes
using DataFrames
using StaticArrays

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
    Nfraction::BigFloat = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct PlanetaryBody
    NMassPlanet::BigFloat = 0.0 # Mass of all N on planet
    NFraction::BigFloat = 1.0
    MassPlanet::BigFloat = 0.0 # Mass of Planet
    ocean::Ocean
    crust::Crust
    atmosphere::Atmosphere
    mantle::Mantle
end

#                   --------------------------------------------------                   #

# Initialize the resevoirs

Planet = PlanetaryBody(ocean = Ocean(volume = 1.3e18,NMass = 2.4e16),
                       crust = Crust(NMass = 1.9e18),
                       mantle = Mantle(NMass = 4e18),
                       atmosphere = Atmosphere(NMass = 2.8e19))

Planet.NMassPlanet = Planet.ocean.NMass + Planet.crust.NMass + Planet.mantle.NMass + Planet.atmosphere.NMass
Planet.MassPlanet = 6e24

Planet.ocean.Nfraction = Planet.ocean.NMass/Planet.NMassPlanet
Planet.crust.Nfraction = Planet.crust.NMass/Planet.NMassPlanet
Planet.mantle.Nfraction = Planet.mantle.NMass/Planet.NMassPlanet
Planet.atmosphere.Nfraction = Planet.atmosphere.NMass/Planet.NMassPlanet
t = 1

#                   --------------------------------------------------                   #

Monitor = DataFrame(time = Int64[],
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

push!(Monitor, [t, Planet.ocean.volume, Planet.NMassPlanet,
                Planet.ocean.Nfraction, Planet.ocean.NMass,
                Planet.crust.Nfraction, Planet.crust.NMass,
                Planet.atmosphere.Nfraction, Planet.atmosphere.NMass,
                Planet.mantle.Nfraction, Planet.mantle.NMass])

#                   --------------------------------------------------                   #