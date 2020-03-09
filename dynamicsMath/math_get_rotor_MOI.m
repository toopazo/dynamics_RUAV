function [Jroti_frd_roti, Jroti_frd_CM] = get_rotor_MOI(...
    r_frd_CM_CG, r_frd_Ri_CG, R_abci_frd, Jroti_abc_rot, mass)
    
    % MOI wrt local cmi
    R_frd_abci = R_abci_frd^(-1);
    Jroti_frd_roti = R_frd_abci * Jroti_abc_rot * R_abci_frd;

    % MOI wrt global CM (Parallel axis theorem)
    r_frd_rot_CG = r_frd_Ri_CG;
    r_frd_rot_CM = r_frd_rot_CG - r_frd_CM_CG;
    Jroti_frd_CM = Jroti_frd_roti + math_MOI_point_mass(mass, r_frd_rot_CM);        
end
