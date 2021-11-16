#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####


using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays")
Pkg.add("CSV")
Pkg.add("Plots")
Pkg.add("PyPlot")


using Parameters
using Classes
using DataFrames
using DelimitedFiles
using CSV
using StaticArrays
using Plots
using PyPlot


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
                           atmosphere = Atmosphere(Mass = log10(4e18),NMass = log10(2.8e19)))

    Planet.NMass = log10(10^Planet.ocean.NMass + 10^Planet.crust.NMass + 
                         10^Planet.mantle.NMass + 10^Planet.atmosphere.NMass)

    Planet.ocean.Nfraction = 10^Planet.ocean.NMass / 10^Planet.NMass
    Planet.crust.Nfraction = 10^Planet.crust.NMass / 10^Planet.NMass
    Planet.mantle.Nfraction = 10^Planet.mantle.NMass / 10^Planet.NMass
    Planet.atmosphere.Nfraction = 10^Planet.atmosphere.NMass / 10^Planet.NMass

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

function RunModel(years::Int64,filename::String)
    
    t = 0
    Monitor,Planet = initialize()
    Monitor = store(t,Planet,Monitor)

    print("Inialization complete\n")
    t += 1 # initial values stored in timestep 0 so first that t represents
           # completed years
    

    
    while t < years
        
        Planet = evolve(t,Planet)
        Monitor = store(t,Planet,Monitor)

        t += 1
        

        TenPercent = ceil(years/10)



        if t == TenPercent
            #allow used to check model progression
            print("\n10% complete...",
                  "\n",t,"years\n")
        elseif t == ceil(2*TenPercent)

            #allow used to check model progression
            print("\n20% complete...\n",
            "\n",t,"years\n")
        elseif t == ceil(3*TenPercent)
            #allow used to check model progression
            print("\n30% complete...\n",
            "\n",t,"years\n")

        elseif t == ceil(4*TenPercent)
            #allow used to check model progression
            print("\n40% complete...\n",
            "\n",t,"years\n")

        elseif t == ceil(5*TenPercent)
            #allow used to check model progression
            print("\n50% complete...\n",
            "\n",t,"years\n")

        elseif t == ceil(6*TenPercent)
            #allow used to check model progression
            print("\n60% complete...\n",
            "\n",t,"years\n")
        elseif t == ceil(7*TenPercent)
            #allow used to check model progression
            print("\n70% complete...\n",
            "\n",t,"years\n")

        elseif t == ceil(8*TenPercent)
            #allow used to check model progression
            print("\n80% complete...\n",
            "\n",t,"years\n")

        elseif t == ceil(9*TenPercent)
            #allow used to check model progression
            print("\n90% complete...\n",
            "\n",t,"years\n")

        else
            if t == years

                visualize(Monitor)

                if filename == ""
                    filename = "Data"
                else
                    filename = "/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/" * filename * ".csv"
                end

                CSV.write(filename,Monitor)

                print("\n\nModel Complete\n")
                print("\nModel data saved in /Outputs/Data.csv\n\n")

                return Planet,Monitor
            end
        end
    end
end

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

#   Planet,Monitor = RunModel(10,"10years")

#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

print("Welcome to the Elemental Cycling Model!",
      "\nPlease Indicate from the below list what to do next:",
      "\n1 : Need inputs",
      "\n2 : Input variables\n\n")

option = readline()
option = parse(Int64,option)

if option == 1

    print("The inputs for the model are:",
          "\nTFinal = 0 [total years for model to run]",
          "\nfilename = output file name")

else

    print("\nPlease indicate the time length for model as a positive integer:")
    years = readline()
    years = parse(Int64,years)

    print("\nBeginning Model...\n")
    Planet,Monitor = RunModel(year,filename)
    
    print("\n\nModel complete please look at Output folder for data and plots.")
end 

#                   --------------------------------------------------                   #
