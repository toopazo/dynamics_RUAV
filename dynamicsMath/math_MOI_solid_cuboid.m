function J_frd = math_MOI_solid_cuboid(mass, lf, lr, ld)
    Jf = (1.0 / 12.0) * mass * (lr^2 + ld^2);
    Jr = (1.0 / 12.0) * mass * (ld^2 + lf^2);
    Jd = (1.0 / 12.0) * mass * (lf^2 + lr^2);
    J_frd = [ [Jf, 0, 0]; [0, Jr, 0]; [0, 0, Jd] ];
end
