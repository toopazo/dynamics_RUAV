function Clift = firefly_coeff_Clift(aoa, ssa, Mach, altitude)
    Clift = firefly_coeff_Cdrag(aoa, ssa, Mach, altitude) / 10;
end

