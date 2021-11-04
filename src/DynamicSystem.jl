
#                   --------------------------------------------------                   #

function initialize()

    # call classes.jl to construct classes and call Processes.jl to access functions
    
    

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

    t = 1

end

#                   --------------------------------------------------                   #

function evolve()

    
    #call processes

end

#                   --------------------------------------------------                   #

function visualize()

    
    #call processes

end

#                   --------------------------------------------------                   #
function Model(Tfinal = 100,t=0)

    include("src/Plot.jl")
    include("src/classes.jl")
    include("src/Processes.jl")
    
    while t < Tfinal

        t += 1
        if t == 1
            initialize() #create 
        else
            evolve()
        end
        store()
        visualize()

    end

end

#                   --------------------------------------------------                   #

function store()
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
