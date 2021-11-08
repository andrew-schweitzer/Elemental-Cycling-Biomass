
#                   --------------------------------------------------                   #

function initialize()

    include("src/classes.jl")
    include("src/Processes.jl")
    

    #initialize dataframe to track changes

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

    Planet = PlanetaryBody(Mass = 6e24,
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

end

#                   --------------------------------------------------                   #

function evolve(t)

    F_Crust_Ocean()
    F_Crust_Mantle()
    F_Ocean_Crust()
    F_Mantle_Atmosphere()
    F_Mantle_Ocean(t)
    F_Henry()
    F_Meteor(t)

end

#                   --------------------------------------------------                   #

function store(t,Planet)
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
                Planet.mantle.NMass])
end

#                   --------------------------------------------------                   #

function RunModel(TFinal = 100,t=0,CSV = false)

    initialize()
    store(t,Planet)

    while t < TFinal
        t += 1
        evolve(t)
        store(t,Planet)
    end

    include("Visualization/Plot.jl")
    visualize(TFinal)

    if CSV != false
        CSV.write("/Outputs/Data.csv")

end

#                   --------------------------------------------------                   #