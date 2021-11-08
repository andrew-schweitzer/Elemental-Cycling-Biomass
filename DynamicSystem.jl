#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
Pkg.add("CSV")
Pkg.add("ECharts")

#                   --------------------------------------------------                   #

using Parameters
using Classes
using DataFrames
using StaticArrays
using DelimitedFiles
using CSV
using ECharts


#                   --------------------------------------------------                   #

include("src/classes.jl")
include("src/Processes.jl")
include("Visualization/Plot.jl")

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

print("Welcome to the Elemental Cycling Model!",
      "\nPlease Indicate from the below list what to do next:",
      "\n1 : Need inputs",
      "\n2 : Input variables")

option = readline()
option = parse(Int64,option)

if option == 1

    print("The inputs for the model are:",
          "TFinal = 0 [total years for model to run]",
          "t = 0 [starting time]",
          "CSV = false [true will write data to csv in output folder]")

else

    print("Please indicate the time length for model as a positive integer:")
    years = readline()
    years = parse(Int64,years)
    
    print("Please choose whether to write to csv [true,false]:")
    print_csv = readline()

    print("Beginning Model...")
    RunModel(TFinal=years,PrintCSV=print_csv)
    
    print("Model complete please look at output folder for data and plots.")
end 
    
#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

function initialize()

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
                           atmosphere = Atmosphere(Mass = 4e18,NMass = 2.8e19))

    Planet.NMass = (Planet.ocean.NMass + Planet.crust.NMass + Planet.mantle.NMass + Planet.atmosphere.NMass)

    Planet.ocean.Nfraction = Planet.ocean.NMass/Planet.NMass
    Planet.crust.Nfraction = Planet.crust.NMass/Planet.NMass
    Planet.mantle.Nfraction = Planet.mantle.NMass/Planet.NMass
    Planet.atmosphere.Nfraction = Planet.atmosphere.NMass/Planet.NMass

    return Monitor,Planet
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

function store(t,Planet,Monitor)
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

function RunModel(TFinal::Int64)
    
    t = 0
    while t < TFinal
        
        if t == 0

            Monitor,Planet = initialize()
            store(t,Planet,Monitor)
            print("Inialization complete")
            t += 1 # initial values stored in timestep 0 so first that t represents
                    # completed years
        else
            
            evolve(t)
            store(t,Planet,Monitor)

            t += 1

            if t > Int(TFinal/10)
                print("10% complete...")
            elseif t > 2*Int(TFinal/10)
                print("20% complete...")
            elseif t > 3*Int(TFinal/10)
                print("30% complete...")
            elseif t > 4*Int(TFinal/10)
                print("40% complete...")
            elseif t > 5*Int(TFinal/10)
                print("50% complete...")
            elseif t > 6*Int(TFinal/10)
                print("60% complete...")
            elseif t > 7*Int(TFinal/10)
                print("70% complete...")
            elseif t > 8*Int(TFinal/10)
                print("80% complete...")
            elseif t > 9*Int(TFinal/10)
                print("90% complete...")
            else
                print("")
            end
        end
    end
        
    # Visualize if the model has completed the proper number of runs
    if t == TFinal
        visualize(TFinal)

        CSV.write("/Outputs/Data.csv")
        print("Model data saved in /Outputs/Data.csv")
    
        return print("Model Complete")
    end
end

#                   --------------------------------------------------                   #