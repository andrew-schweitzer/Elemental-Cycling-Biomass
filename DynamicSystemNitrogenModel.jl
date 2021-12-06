#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

#= print("Please wait for packages needed for model to be installed...\n")
using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
Pkg.add("CSV")
Pkg.add("Plots")
Pkg.add("PyPlot") =#

print("Please wait for packages needed for model to be called...\n")
using Parameters, Classes, DataFrames, DelimitedFiles, CSV, StaticArrays, Plots, PyPlot

print("Please wait for files needed for model to be called...\n")
include("src/classes.jl")
include("src/Processes.jl")
include("Visualization/Plot.jl")

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

function initialize()

    #initialize dataframe to track changes

    Monitor = DataFrame(time = Int64[],
                    VOcean = Float64[],
                    OceanNFraction = Float64[],
                    OceanNMass = Float64[],
                    CrustNFraction = Float64[],
                    CrustNMass = Float64[],
                    AtmosphereNFraction = Float64[],
                    AtmosphereNMass = Float64[],
                    MantleNFraction = Float64[],
                    MantleNMass = Float64[],
                    NMassTotal = Float64[])   

    # Due to dimensional consraints within julia to perform calculations the log base 10 was taken.

    Planet = PlanetaryBody(Mass = log10(6e24),
                           ocean = Ocean(volume = log10(1.3e18),NMass = log10(2.4e16)),
                           crust = Crust(NMass = log10(1.9e18)),
                           mantle = Mantle(NMass = log10(4e18)),
                           atmosphere = Atmosphere(volume = log10(3.64e20),NMass = log10(2.8e19)))

    Planet.NMass = log10(2.4e16 + 1.9e18 + 4e18 + 2.8e19)
    
    Planet.ocean.Nfraction = 100*10^(Planet.ocean.NMass - Planet.NMass)
    Planet.crust.Nfraction = 100*10^(Planet.crust.NMass - Planet.NMass)
    Planet.mantle.Nfraction = 100*10^(Planet.mantle.NMass - Planet.NMass)
    Planet.atmosphere.Nfraction = 100*10^(Planet.atmosphere.NMass - Planet.NMass)

    return Monitor,Planet
end

#                   --------------------------------------------------                   #

function evolve(t,Planet)

    F_Crust_Ocean(Planet)
    F_Crust_Mantle(Planet)
    F_Ocean_Crust(Planet)
    F_Mantle_Atmosphere(Planet)
    F_Mantle_Ocean(t,Planet)
    F_Henry(Planet)
    F_Meteor(t,Planet)

    Planet.ocean.Nfraction = 100*10^(Planet.ocean.NMass - Planet.NMass)
    Planet.crust.Nfraction = 100*10^(Planet.crust.NMass - Planet.NMass)
    Planet.mantle.Nfraction = 100*10^(Planet.mantle.NMass - Planet.NMass)
    Planet.atmosphere.Nfraction = 100*10^(Planet.atmosphere.NMass - Planet.NMass)

    return Planet

end

#                   --------------------------------------------------                   #

function store(t,Planet,Monitor)
    push!(Monitor,[t, 
                   Planet.ocean.volume, 
                   Planet.ocean.Nfraction,
                   Planet.ocean.NMass, 
                   Planet.crust.Nfraction, 
                   Planet.crust.NMass,
                   Planet.atmosphere.Nfraction, 
                   Planet.atmosphere.NMass,
                   Planet.mantle.Nfraction, 
                   Planet.mantle.NMass,
                   Planet.NMass]) 
    return Monitor
end

#                   --------------------------------------------------                   #

function RunModel(years::Int64,filename::String = "")
    
    t = 0
    Monitor,Planet = initialize()
    Monitor = store(t,Planet,Monitor)

    print("\nInialization complete\n")
    t += 1 # initial values stored in timestep 0 so first that t represents
           # completed years
    

    
    while t < years+1
        
        Planet = evolve(t,Planet)
        Monitor = store(t,Planet,Monitor)

        t += 1

        if t == years

            print("\n\nModel Complete\n")
            print("Model runs complete now visualizing and exporting data...\n\n")
            visualize(Monitor)

            if filename == ""
                filename = "Data"
            else
                filename = "/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/" * filename * ".csv"
            end

            CSV.write("/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/Data.csv",Monitor)

            
            print("\nModel data saved in /Outputs/Data.csv\n\n")

            return Planet,Monitor
        end

    end
end

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

#   Planet,Monitor = RunModel(1000,"Data")
# ENV["GRDIR"]=""
# Pkg.build("GR")
#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

print("\n\nWelcome to the Elemental Cycling Model!",
      "\nPlease Indicate from the below list what to do next:",
      "\n1 : Need inputs",
      "\n2 : Input variables\n\n")

option = readline()
option = parse(Int64,option)

if option == 1

    print("\nThe inputs for the model are:",
          "\nTFinal = 0 [total years for model to run]",
          "\nfilename = output file name\n")

else

    print("\nPlease indicate the time length for model as a positive integer:")
    years = readline()
    years = parse(Int64,years)

    print("\nPlease indicate the filename [if none leave empty]:")
    filename = readline()

    print("\nBeginning Model...\n")
    Planet,Monitor = RunModel(years,filename)
    
    print("\n\nModel complete please look at Output folder for data and plots.\n")
end 

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####