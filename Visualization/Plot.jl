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
    Plots.plot(Monitor.time,Monitor.CrustNFraction,title = "Crust",legend = false,color = "green")

    Plots.plot!(Monitor.time,Monitor.OceanNFraction,title = "Ocean",legend = false,color = "blue")
    Plots.plot!(Monitor.time,Monitor.AtmosphereNFraction,title = "Atmosphere",legend = false,color = "black")
    Plots.plot!(Monitor.time,Monitor.MantleNFraction,title = "Mantle",legend = false,color = "orange")

    #= subplot = Plots.plot(CrustNFracPlot,OceanNFracPlot,AtmosphereNFracPlot,MantleNFracPlot,
                layout = (4,1)) =#

    
    png("/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenFractionOverTime.png")          

end


# VisualizeNFractionOverTime(Monitor)
#                   --------------------------------------------------                    #

function VisualizeNMassOverTime(Monitor)

    # Looks at the mass of Nitrogen in each resevoir and plots it along the time step.
    # This is the Nitrogen Mass by Reservoir Time Series
    
    PyPlot.clf()
    CrustNMassPlot = Plots.plot(Monitor.time,Monitor.CrustNMass,title = "Crust",legend = false,color = "black")
    gcf()
    OceanNMassPlot = Plots.plot(Monitor.time,Monitor.OceanNMass,title = "Ocean",legend = false,color = "black")
    gcf()
    AtmosphereNMassPlot = Plots.plot(Monitor.time,Monitor.AtmosphereNMass,title = "Atmosphere",legend = false,color = "black")
    gcf()
    MantleNMassPlot = Plots.plot(Monitor.time,y = Monitor.MantleNMass,title = "Mantle",legend = false,color = "black")
    gcf()
    PyPlot.clf()
    Plots.plot(CrustNMassPlot, OceanNMassPlot,AtmosphereNMassPlot,MantleNMassPlot,
                layout = (4,1))
    
    png("/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenMassOverTime.png")          
    
end

#                   --------------------------------------------------                    #

