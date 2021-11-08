#                   --------------------------------------------------                    #

using Pkg
Pkg.add("ECharts")

#                   --------------------------------------------------                    #

function visualize(TFinal)

    PlotSteps = range(1,TFinal,step = (TFinal/10))
    visualizeMassDistribution()
    visualizeNFractionDistribution()
    visualizeGlobalNDistribution()
    

end

#                   --------------------------------------------------                    #

function visualizeMassDistribution()

    AtmosphereicNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[AtmosphereNMass])
    OceanicNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[OceanNMass])
    CrustNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[CrustNMass])
    MantleNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[MantleNMass])

end

#                   --------------------------------------------------                    #

function visualizeNFractionDistribution()

    AtmosphereicNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[AtmosphereNFraction])
    OceanicNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[OceanNFraction])
    CrustNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[CrustNFraction])
    MantleNitogenMassPlot = Bar(x = Monitor[time], y = Monitor[MantleNFraction])

end

#                   --------------------------------------------------                    #

function visualizeGlobalNDistribution(PlotSteps)
    # pie plot to show distribution

    for step in PlotSteps
        filename = "GlobalNitrogenDistribution" + string(step) + ".png"

        x = ["Atmosphere","Ocean","Crust","Mantle"]

        y = [Monitor[AtmosphereNFraction][step],
             Monitor[OceanNFraction][step],
             Monitor[CrustNFraction][step],
             Monitor[MantleNFraction][step]]
        
        pie_chart = pie(x,y)
        savefig(pie_chart,filename)

    end

end

#                   --------------------------------------------------                    #