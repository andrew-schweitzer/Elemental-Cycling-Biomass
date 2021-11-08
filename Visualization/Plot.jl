#                   --------------------------------------------------                    #

using Pkg
Pkg.add("ECharts")

#                   --------------------------------------------------                    #

function visualize(TFinal)

    PlotSteps = range(1,TFinal,step = (TFinal/10))
    
    VisualizeNFractionOverTime()
    VisualizeNMassOverTime()
    VisualizeGlobalNDistribution(PlotSteps)
    

end

#                   --------------------------------------------------                    #

function VisualizeNFractionOverTime()
    NitrogenDistributionPlot = bar(x = Monitor[time], 
                                   hcat(Monitor[AtmosphereNFraction], 
                                        Monitor[OceanNFraction], 
                                        Monitor[CrustNFraction],
                                        Monitor[MantleNFraction]), 
                                   color = ["grey", "blue", "brown","red"], 
                                   stack = true)
    title!(NitrogenDistributionPlot, 
           text = "Nitrogen Fraction of Global Nitrogen mass by Resevoir Time Series")
    filename = "/Outputs/NitrogenDistributionPlot.png"
    savefig(NitrogenDistributionPlot,filename)         

end

#                   --------------------------------------------------                    #

function VisualizeNMassOverTime()

    # Looks at the mass of Nitrogen in each resevoir and plots it along the time step.
    # This is the Nitrogen Mass by Reservoir Time Series

    NitogenMassPlot = line(x = Monitor[time], 
                               hcat(Monitor[AtmosphereNMass],
                                    Monitor[OceanNMass],
                                    Monitor[CrustNMass],
                                    Monitor[MantleNMass]))

    title!(NitogenMassPlot, text = "Nitrogen Mass by Resevoir Time Series")
    filename = "/Outputs/NitogenMassPlot.png"
    savefig(NitogenMassPlot,filename)
    
end

#                   --------------------------------------------------                    #

function VisualizeGlobalNDistribution(PlotSteps)

    # pie plot to show distribution at each 10% time step.
    # useful to view as a series to see larger time shifts 
    # and its influence on Nitrogen distribution

    for step in PlotSteps
        filename = "/Outputs/GlobalNitrogenDistribution" + string(step) + ".png"

        x = ["Atmosphere","Ocean","Crust","Mantle"]

        y = [Monitor[AtmosphereNFraction][step],
             Monitor[OceanNFraction][step],
             Monitor[CrustNFraction][step],
             Monitor[MantleNFraction][step]]
        
        pie_chart = pie(x,y)
        title!(pie_chart, 
               text = "Global Nitrogen Distribution by Resevoir",
               subtext = "Time: " + str(step))
        savefig(pie_chart,filename)

    end

end

#                   --------------------------------------------------                    #
