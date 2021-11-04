#                   --------------------------------------------------                    #

using Pkg
Pkg.add("ECharts")

#                   --------------------------------------------------                    #

function visualize()

    visualizeMassDistribution()
    visualizeNFractionDistribution()
    visualizeGlobalNDistribution()

end

#                   --------------------------------------------------                    #

function visualizeMassDistribution()

    AtmosphereicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[AtmosphereNMass])
    OceanicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[OceanNMass])
    CrustNitogenMassPlot = plot(x = Monitor[time], y = Monitor[CrustNMass])
    MantleNitogenMassPlot = plot(x = Monitor[time], y = Monitor[MantleNMass])

end

#                   --------------------------------------------------                    #

function visualizeNFractionDistribution()

    AtmosphereicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[AtmosphereNFraction])
    OceanicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[OceanNFraction])
    CrustNitogenMassPlot = plot(x = Monitor[time], y = Monitor[CrustNFraction])
    MantleNitogenMassPlot = plot(x = Monitor[time], y = Monitor[MantleNFraction])

end

#                   --------------------------------------------------                    #

function visualizeGlobalNDistribution()
    # Bar plot of 
    AtmosphereicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[AtmosphereNFraction])
    OceanicNitogenMassPlot = plot(x = Monitor[time], y = Monitor[OceanNFraction])
    CrustNitogenMassPlot = plot(x = Monitor[time], y = Monitor[CrustNFraction])
    MantleNitogenMassPlot = plot(x = Monitor[time], y = Monitor[MantleNFraction])

end

#                   --------------------------------------------------                    #