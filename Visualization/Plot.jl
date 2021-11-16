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


#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

function visualize(Monitor)

    VisualizeNFractionOverTime(Monitor)
    VisualizeNMassOverTime(Monitor)

end

#                   --------------------------------------------------                    #

function VisualizeNFractionOverTime(Monitor)

    PyPlot.clf()
    P1 = Plots.bar(Monitor.time,Monitor.CrustNFraction,title = "Crust",legend = false)
    gcf()
    P2 = Plots.bar(Monitor.time,Monitor.OceanNFraction,title = "Ocean",legend = false)
    gcf()
    P3 = Plots.bar(Monitor.time,Monitor.AtmosphereNFraction,title = "Atmosphere",legend = false)
    gcf()
    P4 = Plots.bar(Monitor.time,Monitor.MantleNFraction,title = "Mantle",legend = false)
    gcf()
    PyPlot.clf()
    subplot = Plots.plot(P1,P2,P3,P4,
                layout = 4)


    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenFractionOverTime.png")          

end

#                   --------------------------------------------------                    #

function VisualizeNMassOverTime(Monitor)

    # Looks at the mass of Nitrogen in each resevoir and plots it along the time step.
    # This is the Nitrogen Mass by Reservoir Time Series
    
    PyPlot.clf()
    P1 = Plots.bar(Monitor.time,Monitor.CrustNMass,title = "Crust",legend = false)
    gcf()
    P2 = Plots.bar(Monitor.time,Monitor.OceanNMass,title = "Ocean",legend = false)
    gcf()
    P3 = Plots.bar(Monitor.time,Monitor.AtmosphereNMass,title = "Atmosphere",legend = false)
    gcf()
    P4 = Plots.bar(Monitor.time,Monitor.MantleNMass,title = "Mantle",legend = false)
    gcf()
    PyPlot.clf()
    subplot = Plots.plot(P1,P2,P3,P4,
                layout = 4)


    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenMassOverTime.png")          
    
end

#                   --------------------------------------------------                    #

