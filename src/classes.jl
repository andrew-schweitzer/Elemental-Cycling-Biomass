using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
using Parameters
using Classes

#creates common structure for all resevoirs with initial values set at 0.0
@with_kw struct Resevoir
    volume::BigFloat = 0.0
    mass::BigFloat = 0.0
    Nitrogen::BigFloat = 0.0
    CarbonDioxide::BigFloat = 0.0
    Oxygen::BigFloat = 0.0
    Phosphorous::BigFloat = 0.0
end

Ocean = Resevoir(volume = 1.3e18, Nitrogen = 2.4e16)
CrustOceanic = Resevoir(Nitrogen = 2.0e17)
CrustContinential = Resevoir(Nitrogen = 1.7e18)
Atmosphere = Resevoir(mass = 5.2e18,Nitrogen = 4e18)
Mantle = Resevoir(Nitrogen = BigFloat(2.8e19))

#this metric will be used to assure that no mass is created nor lost
PlanetMass = 6.0e24 