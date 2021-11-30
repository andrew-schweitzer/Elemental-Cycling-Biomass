#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####


#= using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
Pkg.add("DataFrames")
Pkg.add("StaticArrays") =#


using Parameters
using Classes
using DataFrames
using StaticArrays


#####--------------------------------------------------------------------------------#####
#####--------------------------------------------------------------------------------#####

function F_Crust_Ocean(Planet) 

    alpha = 0.00001 * rand(500:1000) # kg/yr

    while alpha > Planet.crust.NMass
        alpha = alpha/2
    end

    Planet.crust.NMass -= alpha
    Planet.ocean.NMass += alpha

end

#                   --------------------------------------------------                   #

function F_Crust_Mantle(Planet)
    
    # The purpose of the rand(1000:99000) is to create more decimal points and more possible
    # values for the random to choose from allowing for both more randomness and increased
    # accuracy with more decimals.
    epsilon = 0.00001*rand(1000:50000)
    tao = 100

    delta = (1-epsilon)*(Planet.crust.NMass/tao)

    while delta > Planet.crust.NMass
        delta = delta/2
    end

    Planet.crust.NMass -= delta
    Planet.mantle.NMass += delta

end

#                   --------------------------------------------------                   #

function F_Ocean_Crust(Planet)

    VSed = log10(6.1e17)
    Rho = 1700
    Kf = 0.001

    F = 0.01*(VSed - (Planet.ocean.volume*Rho*Kf))

    while F > Planet.crust.NMass
        F = F/2
    end

    Planet.crust.NMass -= F
    Planet.ocean.NMass += F

end

#                   --------------------------------------------------                   #

function F_Mantle_Atmosphere(Planet) 

    delta = 6 + log10(rand(2800:3000))

    while delta > Planet.mantle.NMass
        delta = delta/2
    end

    Planet.mantle.NMass -= delta
    Planet.atmosphere.NMass += delta

end

#                   --------------------------------------------------                   #

function F_Mantle_Ocean(t,Planet) 

    tao = log(1e9)

    delta = -8*log10(1 + 2*exp(-t/tao))

    while delta > Planet.mantle.NMass
        delta = delta/2
    end

    Planet.mantle.NMass -= delta
    Planet.ocean.NMass += delta

end

#                   --------------------------------------------------                   #

function F_Meteor(t,Planet) 

    N0 = 2.4e5
    N1 = 2.4e8
    tao = 150

    Planet.atmosphere.NMass += 5 + log10( 2.4*( 1 + 1000*exp(-t/tao) ) )
    Planet.Mass += 5 + log10( 2.4*( 1 + 1000*exp(-t/tao) ) )

end

#                   --------------------------------------------------                   #

#= 

function F_Henry_old(Planet) 

    AtomicMassN2 = 0.032 # kg/mol

    #= Kmol = 1600 # L*Atm/mol
    Kkg = 1600 / AtomicMassN2 #changed units -> L*Atm/kg =#

    # calculate current nitrogen oceanic concentration and maximum nitrogen oceanic concentration
    Cmax = (Planet.atmosphere.NMass + Planet.ocean.volume + Planet.ocean.NMass) - (Planet.atmosphere.Mass*AtomicMassN2)
    Ccurr = Planet.ocean.NMass - (AtomicMassN2*Planet.ocean.volume)

    if Cmax - Ccurr < 0
        # if Ccurr is greater than Cmax nitrogen diffuses from ocean to atmoshpere
        Cdelta = Ccurr - Cmax
        Planet.ocean.NMass -= Cdelta*Planet.ocean.volume
        Planet.atmosphere.NMass += + Cdelta*Planet.ocean.volume

    elseif Cmax - Ccurr > 0
        # if Cmax is greater than Ccurr nitrogen dissolves from atmoshpere to ocean
        Cdelta = Cmax - Ccurr
        Planet.ocean.NMass += Cdelta*Planet.atmosphere.NMass
        Planet.atmosphere.NMass -= Cdelta*Planet.atmosphere.NMass

    else
        #No change if cmax = ccurr
    end

end
  =#
#                   --------------------------------------------------                   #

function F_Henry(Planet) 

    #=  Equation:

            Henry's Law but in reference to Hc which is dimensionless due to it being a 
            Ratio between the concentration of atmospheric Nitrogen to dissolved Nitrogen

            Hc * ConcentrationAtmosphere = ConcentrationOcean

            Hc for N2 is 1.5e-2

            (0.015) * ConcentrationAtmosphere = ConcentrationOcean

            if [(0.015) * ConcentrationAtmosphere > ConcentrationOcean]
                movement of Nitrogen from the atmosphere to the ocean
            
            if [(0.015) * ConcentrationAtmosphere < ConcentrationOcean]
                movement of Nitrogen from the ocean to the atmosphere
                                                                                        =#

    AtomicMassN2 = 0.032 # kg/mol
    
    #= since these values are stored as logarithms they are subtracted rather than divided
       additionally this function assumes that all nitrogen moves immedietly which is not 
       the most realistic but recursion would be a strong tool in making this function more 
        robust.
        Planet.atmosphere.NMass
        Planet.atmosphere.volume

        Planet.ocean.NMass
        Planet.ocean.volume
                                                                                        =#

    AtmosphericConc = (Planet.atmosphere.NMass - Planet.atmosphere.volume)/0.032
    OceanicConc = (Planet.ocean.NMass - Planet.ocean.volume)/0.032

    if (0.015) * AtmosphericConc > OceanicConc

        # here is can be seen that the oceanic concentration is low thus dissolves 
        # atmospheric nitrogen
        ConcDelta = 0.015 * AtmosphericConc - OceanicConc

        # Check if the concentration difference is larger than the reservoir being taken
        # from. Change value to half of the current resevoir value if this is true.
        while ConcDelta > AtmosphericConc

            ConcDelta = 0.5*ConcDelta

        end
        
        Planet.atmosphere.NMass -= (ConcDelta*Planet.atmosphere.volume)*0.032
        Planet.ocean.NMass += (ConcDelta*Planet.atmosphere.volume)*0.032

    elseif (0.015) * AtmosphericConc < OceanicConc

        # here is can be seen that the atmospheric concentration is low thus forces 
        # nitrogen to begin releasing 
        ConcDelta = OceanicConc - 0.015*AtmosphericConc

        # Check if the concentration difference is larger than the reservoir being taken
        # from. Change value to half of the current resevoir value if this is true.
        while ConcDelta > OceanicConc

            ConcDelta = 0.5*ConcDelta
            
        end

        Planet.atmosphere.NMass += (ConcDelta*Planet.ocean.volume)*0.032
        Planet.ocean.NMass -= (ConcDelta*Planet.ocean.volume)*0.032

    else
        #No change if cmax = ccurr
    end
end

#                   ----------------------------------------------------                   #

function F_Henry_looped(Planet) 

    #=  Equation:
    
            Henry's Law but in reference to Hc which is dimensionless due to it being a 
            Ratio between the concentration of atmospheric Nitrogen to dissolved Nitrogen

            Hc * ConcentrationAtmosphere = ConcentrationOcean

            Hc for N2 is 1.5e-2

            (0.015) * ConcentrationAtmosphere = ConcentrationOcean

            if [(0.015) * ConcentrationAtmosphere > ConcentrationOcean]
                movement of Nitrogen from the atmosphere to the ocean
            
            if [(0.015) * ConcentrationAtmosphere < ConcentrationOcean]
                movement of Nitrogen from the ocean to the atmosphere
                                                                                            =#
    
    AtomicMassN2 = 0.032 # kg/mol
    
    #= 
        since these values are stored as logarithms they are subtracted rather than divided
        additionally this function assumes that all nitrogen moves immedietly which is not 
        the most realistic but recursion would be a strong tool in making this function more 
        robust.
                                                                                            =#

    AtmosphericConc = (Planet.atmosphere.NMass - Planet.atmosphere.volume)/AtomicMassN2
    OceanicConc = (Planet.ocean.NMass - Planet.ocean.volume)/AtomicMassN2


    while 0.015*AtmosphericConc != OceanicConc
        
        if 0.015*AtmosphericConc > OceanicConc

            # here is can be seen that the oceanic concentration is low thus dissolves 
            # atmospheric nitrogen
            ConcDelta = (0.015*AtmosphericConc - OceanicConc)/10

            Planet.atmosphere.NMass -= (ConcDelta*Planet.atmosphere.volume)*AtomicMassN2
            Planet.ocean.NMass += (ConcDelta*Planet.atmosphere.volume)*AtomicMassN2
                
        elseif 0.015*AtmosphericConc < OceanicConc
    
            # here is can be seen that the atmospheric concentration is low thus forces 
            # nitrogen to begin releasing 
            ConcDelta = (OceanicConc - 0.015*AtmosphericConc)/10
            
            Planet.atmosphere.NMass += (ConcDelta*Planet.ocean.volume)*AtomicMassN2
            Planet.ocean.NMass -= (ConcDelta*Planet.ocean.volume)*AtomicMassN2

        end

        AtmosphericConc = AtomicMassN2*Planet.atmosphere.NMass - Planet.atmosphere.volume
        OceanicConc = AtomicMassN2*Planet.ocean.NMass - Planet.ocean.volume

    end
end