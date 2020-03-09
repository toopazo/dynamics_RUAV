function J_frd = math_MOI_solid_cylinder(mass, r, h, h_axis)
    switch h_axis
        case 1
            Jf = (1.0 / 2.0) * mass * r^2;
            Jr = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
            Jd = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
        case 2
            Jf = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
            Jr = (1.0 / 2.0) * mass * r^2;
            Jd = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
        case 3
            Jf = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
            Jr = (1.0 / 12.0) * mass * (3.0 * r^2 + h^2);
            Jd = (1.0 / 2.0) * mass * r^2;
    end
    J_frd = [ [Jf, 0, 0]; [0, Jr, 0]; [0, 0, Jd] ];
end
