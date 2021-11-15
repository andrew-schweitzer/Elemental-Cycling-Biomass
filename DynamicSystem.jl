#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
Pkg.add("CSV")
Pkg.add("ECharts")
Pkg.add("Plots")

#                   --------------------------------------------------                   #

using Parameters
using Classes
using DataFrames
using DelimitedFiles
using CSV
using ECharts
using StaticArrays
using Plots


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
    RunModel(years)
    
    print("Model complete please look at output folder for data and plots.")
end 
    
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
                           atmosphere = Atmosphere(Mass = log10(4e18),NMass = log10(2.8e19)))

    Planet.NMass = log10(10^Planet.ocean.NMass + 10^Planet.crust.NMass + 
                         10^Planet.mantle.NMass + 10^Planet.atmosphere.NMass)

    Planet.ocean.Nfraction = 10^(Planet.ocean.NMass - Planet.NMass)
    Planet.crust.Nfraction = 10^(Planet.crust.NMass - Planet.NMass)
    Planet.mantle.Nfraction = 10^(Planet.mantle.NMass - Planet.NMass)
    Planet.atmosphere.Nfraction = 10^(Planet.atmosphere.NMass - Planet.NMass)

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

    Planet.ocean.Nfraction = 10^(Planet.ocean.NMass - Planet.NMass)
    Planet.crust.Nfraction = 10^(Planet.crust.NMass - Planet.NMass)
    Planet.mantle.Nfraction = 10^(Planet.mantle.NMass - Planet.NMass)
    Planet.atmosphere.Nfraction = 10^(Planet.atmosphere.NMass - Planet.NMass)

    return Planet

end

#                   --------------------------------------------------                   #

function store(t,Planet,Monitor)
    push!(Monitor,[t, Planet.ocean.volume, Planet.NMass, Planet.ocean.Nfraction,
                   Planet.ocean.NMass, Planet.crust.Nfraction, Planet.crust.NMass,
                   Planet.atmosphere.Nfraction, Planet.atmosphere.NMass,
                   Planet.mantle.Nfraction, Planet.mantle.NMass])
    return Monitor
end

#                   --------------------------------------------------                   #

function RunModel(years::Int64)
    
    t = 0
    Monitor,Planet = initialize()
    Monitor = store(t,Planet,Monitor)

    print("Inialization complete\n")
    t += 1 # initial values stored in timestep 0 so first that t represents
           # completed years
    
    print("\n t:",t)
    print("\n years:",years)

    
    while t < years
        
        Planet = evolve(t,Planet)
        Monitor = store(t,Planet,Monitor)

        t += 1
        

        TenPercent = convert(Int64,round(years/10))
        print("\n t:",t)



        if t == TenPercent
            #allow used to check model progression
            print("\n10% complete...\n")
        elseif t == 2*TenPercent
            #allow used to check model progression
            print("\n20% complete...\n")
        elseif t == 3*TenPercent
            #allow used to check model progression
            print("\n30% complete...\n")
        elseif t == 4*TenPercent
            #allow used to check model progression
            print("\n40% complete...\n")
        elseif t == 5*TenPercent
            #allow used to check model progression
            print("\n50% complete...\n")
        elseif t == 6*TenPercent
            #allow used to check model progression
            print("\n60% complete...\n")
        elseif t == 7*TenPercent
            #allow used to check model progression
            print("\n70% complete...\n")
        elseif t == 8*TenPercent
            #allow used to check model progression
            print("\n80% complete...\n")
        elseif t == 9*TenPercent
            #allow used to check model progression
            print("\n90% complete...\n")
        else
            # Visualize if the model has completed the proper number of runs
            #= if t == TFinal
                
        
                
            
                return print("Model Complete")
            end =#
            if t == years
                visualize(years,Monitor)
                CSV.write("/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/Data.csv",Monitor)
                print("\n\nModel Complete\n")
                print("\nModel data saved in /Outputs/Data.csv\n\n")
                return Planet,Monitor
            end
        end
    end
end

#                   --------------------------------------------------                   #