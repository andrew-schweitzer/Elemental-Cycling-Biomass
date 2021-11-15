##---------------------------------------------------------------------------------------##
#
# List of Processes
#
#   F_Crust_Ocean:
#       
#   F_Crust_Mantle:
#       
#   F_Ocean_Crust:
#       
#   F_Mantle_Atmosphere:
#       
#   F_Mantle_Ocean:
#
#   F_Henry:
#
#   F_Meteor:
#
##---------------------------------------------------------------------------------------##

#using Pkg
#Pkg.add("PeriodicTable")
Pkg.add("Random")
#using PeriodicTable
using Random

#                   --------------------------------------------------                    #

function F_Crust_Ocean(Planet) 

    alpha = 0.000001 * rand(50:100) # kg/yr

    Planet.crust.NMass -= alpha
    Planet.ocean.NMass += alpha

end

#                   --------------------------------------------------                   #

function F_Crust_Mantle(Planet)
    
    epsilon = 0.01 * rand(1:100)
    tao = 100

    Planet.crust.NMass -= epsilon*(Planet.crust.NMass/tao)
    Planet.mantle.NMass += epsilon*(Planet.crust.NMass/tao)

end

#                   --------------------------------------------------                   #

function F_Ocean_Crust(Planet)

    VSed = log10(6.1e17)
    Rho = 1700
    Kf = 0.001

    F = 0.001*(VSed - (Planet.ocean.volume*Rho*Kf))

    Planet.crust.NMass -= F
    Planet.ocean.NMass += F

end

#                   --------------------------------------------------                   #

function F_Mantle_Atmosphere(Planet) 

    delta = log10(1e6 * rand(2800:3000))

    Planet.crust.NMass -= delta
    Planet.ocean.NMass += delta

end

#                   --------------------------------------------------                   #

function F_Mantle_Ocean(t,Planet) 

    tao = 1e9

    Planet.mantle.NMass -= -8*log10(1 + 2*exp(-t/tao))
    Planet.ocean.NMass += -8*log10(1 + 2*exp(-t/tao))

end

#                   --------------------------------------------------                   #

function F_Meteor(t,Planet) 

    N0 = 2.4e5
    N1 = 2.4e8
    Ndelta = 2.3976e8
    tao = 150

    Planet.atmosphere.NMass += 5*log10( 2.4*( 1 + 1000*exp(-t/tao) ) )
    Planet.Mass += 5*log10( 2.4*( 1 + 1000*exp(-t/tao) ) )

end

#                   --------------------------------------------------                   #

function F_Henry(Planet) 

    AtomicMassN2 = 2 * 16 / 1000 # g/mol

    Kmol = 1600 # L*Atm/mol
    Kkg = 1600 / AtomicMassN2 #changed units -> L*Atm/kg

    # calculate current nitrogen oceanic concentration and maximum nitrogen oceanic concentration
    Cmax = Kkg*Planet.atmosphere.NMass*Planet.ocean.volume*AtomicMassN2/Planet.atmosphere.Mass
    Ccurr = Planet.ocean.NMass/(AtomicMassN2*Planet.ocean.volume)

    if Cmax - Ccurr < 0
        # if Ccurr is greater than Cmax nitrogen diffuses from ocean to atmoshpere
        Cdelta = Ccurr - Cmax
        Planet.ocean.NMass = Planet.ocean.NMass - Cdelta*Planet.ocean.volume
        Planet.atmosphere.NMass = Planet.atmosphere.NMass + Cdelta*Planet.ocean.volume

    elseif Cmax - Ccurr > 0
        # if Cmax is greater than Ccurr nitrogen dissolves from atmoshpere to ocean
        Cdelta = Cmax - Ccurr
        Planet.ocean.NMass = Planet.ocean.NMass + Cdelta*Planet.ocean.volume
        Planet.atmosphere.NMass = Planet.atmosphere.NMass - Cdelta*Planet.ocean.volume

    else
        #No change if cmax = ccurr
    end

end

#                   --------------------------------------------------                   #