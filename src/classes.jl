using Pkg
Pkg.add("Classes")
Pkg.add("Parameters")
using Parameters
using Classes

#creates common structure for all resevoirs with initial values set at 0.0
@with_kw struct Resevoir
    volume::BigFloat = 0.0 #only significant for ocean
    Nitrogen::BigFloat = 0.0 #mass
    #CarbonDioxide::BigFloat = 0.0  #mass
    #Oxygen::BigFloat = 0.0  #mass
    #Phosphorous::BigFloat = 0.0  #mass
end

Ocean = Resevoir(volume = 1.3e18, Nitrogen = N1/Ntotal)
Crust = Resevoir(Nitrogen = (N2+N3)/Ntotal)
Atmosphere = Resevoir(Nitrogen = N4/Ntotal)
Mantle = Resevoir(Nitrogen = N5/Ntotal)



N1 = 2.4e16
N2 = 2.0e17
N3 = 1.7e18
N4 = 4e18
N5 = 2.8e19
Ntotal = N1 + N2 + N3 + N4 + N5