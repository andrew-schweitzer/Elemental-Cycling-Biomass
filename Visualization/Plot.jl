#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####


using Classes, Parameters, DataFrames, StaticArrays, Plots, PyPlot


#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####



function visualize(Monitor)

    VisualizeNFractionOverTime(Monitor)
    VisualizeNMassOverTime(Monitor)

end

#                   --------------------------------------------------                    #

function VisualizeNFractionOverTime(Monitor)

    PyPlot.clf()
    CrustNFracPlot = Plots.plot(Monitor.time, 
                                Monitor.CrustNFraction,
                                label = "Crust",
                                legend = false,
                                color = "green",
                                left_margin = [20Plots.mm 0Plots.mm])
    PyPlot.clf()
    OceanNFracPlot = Plots.plot(Monitor.time,
                                Monitor.OceanNFraction,
                                label = "Ocean",
                                legend = false,
                                color = "blue",
                                left_margin = [20Plots.mm 0Plots.mm])
    PyPlot.clf()
    AtmosphereNFracPlot = Plots.plot(Monitor.time,
                                     Monitor.AtmosphereNFraction,
                                     label = "Atmosphere",
                                     legend = false,color = "black",
                                     left_margin = [20Plots.mm 0Plots.mm])
    PyPlot.clf()    
    MantleNFracPlot = Plots.plot(Monitor.time,
                                 Monitor.MantleNFraction,
                                 label = "Mantle",
                                 legend = false,color = "orange",
                                 left_margin = [20Plots.mm 0Plots.mm])
    PyPlot.clf()
    subplot = Plots.plot(CrustNFracPlot,
                         OceanNFracPlot,
                         AtmosphereNFracPlot,
                         MantleNFracPlot,
                         layout = (4,1),
                         legend = true,
                         figsize=(10,20),
                         left_margin = [20Plots.mm 0Plots.mm])

    
    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenFractionOverTime.png")          

end


# VisualizeNFractionOverTime(Monitor)
#                   --------------------------------------------------                    #

function VisualizeNMassOverTime(Monitor)

    # Looks at the mass of Nitrogen in each resevoir and plots it along the time step.
    # This is the Nitrogen Mass by Reservoir Time Series
    
    PyPlot.clf()
    CrustNMassPlot = Plots.bar(Monitor.time,Monitor.CrustNMass,title = "Crust",legend = false,color = "black")
    gcf()
    OceanNMassPlot = Plots.bar(Monitor.time,Monitor.OceanNMass,title = "Ocean",legend = false,color = "black")
    gcf()
    AtmosphereNMassPlot = Plots.bar(Monitor.time,Monitor.AtmosphereNMass,title = "Atmosphere",legend = false,color = "black")
    gcf()
    MantleNMassPlot = Plots.bar(Monitor.time,y = Monitor.MantleNMass,title = "Mantle",legend = false,color = "black")
    gcf()
    PyPlot.clf()
    subplot = Plots.plot(CrustNMassPlot, OceanNMassPlot,AtmosphereNMassPlot,MantleNMassPlot,
                layout = (4,1),
                left_margin = [20Plots.mm 0Plots.mm])
    
    png(subplot,"/home/andrew/Desktop/Elemental-Cycling-Biomass/Outputs/NitrogenMassOverTime.png")          
    
end

#                   --------------------------------------------------                    #

