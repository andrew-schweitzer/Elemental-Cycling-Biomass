##----------------------------------------------------------------------------##
#
# List of Processes
#
#   Erosion:
#       The breakdown of the surface of the crust that deposits minerals and
#       material in the waterways and ocean.
#
#   Subduction:
#       The movement of crust mass and material .
#
#   Convection:
#       The movements of the fluids based upon their temperature. There are three
#       applications of this in the model: the atmosphere, ocean, and mantle. 
#       Although this also exists in the core due to lack of observable data 
#       about the core the behavior is not included in this model.
#
#   Sedimentation:
#       The settling of sediment in the oceans onto the crust where layering
#       pressure, and time for sendiemntary rock in the oceanic crust.
#
#   Precipitation:
#       The movement of minerals from the atmosphere to the ocean and crust
#       via rain and dust settling.
#
#   Volcanism:
#       The movement of mantle material through the crust that can deposit on the
#       crust and occasionally in the ocean. Additionally, non-ocean volcanos
#       move material into the atmosphere.
#
#   Meteors:
#       Solar dust and rocks add minerals and mass to the planet.
#
##----------------------------------------------------------------------------##

function Erosion()
    
end

function Subduction()
    
end

function Convection()
    
end

function Sedimentation()
    
end

function Precipitation()
    
end

function Volcanism()
    
end

function Meteors()
    
end

function Henry()
    p = mol_frac_N*Atmosphere_pressure #Atm
    c = mol_N_ocean/Ocean.volume # mol/Liter
    KN2 = 1600 #Liters*Atm/mol

    if p/c > KN2
        #partial pressure high
        #gases will move from atmosphere to ocean
    elseif p/c < KN2
        #concentration high
        #gases will move from ocean to atmosphere
    else
        #no movement due to gases dissolving in oceans 
end