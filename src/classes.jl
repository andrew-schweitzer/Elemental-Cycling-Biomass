#                   --------------------------------------------------                   #

#creates reservoir structs

@with_kw mutable struct Ocean
    volume::BigFloat = 0.0 #only significant for ocean
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Crust
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Mantle
    Nfraction::Float64 = 0.0 #fraction of total mass in resevoir
    NMass::BigFloat = 0.0 #mass
end

@with_kw mutable struct Atmosphere
    Nfraction::Float64 = 0.0 #fraction of Planetary Nitrogen mass in atmosphere
    NMass::BigFloat = 0.0 # mass of Nitrogen in atmosphere
    Mass::BigFloat = 0.0 # mass of atmosphere
end

@with_kw mutable struct PlanetaryBody
    NMass::BigFloat = 0.0 # Mass of all N on planet
    NFraction::Float64 = 1.0
    Mass::BigFloat = 0.0 # Mass of Planet
    ocean::Ocean
    crust::Crust
    atmosphere::Atmosphere
    mantle::Mantle
end

#                   --------------------------------------------------                   #
