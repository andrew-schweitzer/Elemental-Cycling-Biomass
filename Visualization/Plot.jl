#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####


using Classes
using Parameters
using DataFrames
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
    CrustNFracPlot = Plots.bar(Monitor.time,Monitor.CrustNFraction,title = "Crust",legend = false)
    gcf()
    OceanNFracPlot = Plots.bar(Monitor.time,Monitor.OceanNFraction,title = "Ocean",legend = false)
    gcf()
    AtmosphereNFracPlot = Plots.bar(Monitor.time,Monitor.AtmosphereNFraction,title = "Atmosphere",legend = false)
    gcf()
    MantleNFracPlot = Plots.bar(Monitor.time,Monitor.MantleNFraction,title = "Mantle",legend = false)
    gcf()
    PyPlot.clf()
    subplot = Plots.plot(CrustNFracPlot,OceanNFracPlot,AtmosphereNFracPlot,MantleNFracPlot,
                layout = 4)


    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenFractionOverTime.png")          

end

#                   --------------------------------------------------                    #

function VisualizeNMassOverTime(Monitor)

    # Looks at the mass of Nitrogen in each resevoir and plots it along the time step.
    # This is the Nitrogen Mass by Reservoir Time Series
    
    PyPlot.clf()
    CrustNMassPlot = Plots.bar(Monitor.time,Monitor.CrustNMass,title = "Crust",legend = false)
    gcf()
    OceanNMassPlot = Plots.bar(Monitor.time,Monitor.OceanNMass,title = "Ocean",legend = false)
    gcf()
    AtmosphereNMassPlot = Plots.bar(Monitor.time,Monitor.AtmosphereNMass,title = "Atmosphere",legend = false)
    gcf()
    MantleNMassPlot = Plots.bar(Monitor.time,Monitor.MantleNMass,title = "Mantle",legend = false)
    gcf()
    PyPlot.clf()
    subplot = Plots.plot(CrustNMassPlot, OceanNMassPlot,AtmosphereNMassPlot,MantleNMassPlot,
                layout = 4)


    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenMassOverTime.png")          
    
end

#                   --------------------------------------------------                    #

