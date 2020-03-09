function [Cd] = model_body_Cd(M)

    % Calculates drag coeeficient of a sphere as a function of Mach number
    % It assumes high Re numbers

    M_arr    = [0.00 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 3.00 5.00 1e10];
    Cd_arr   = [0.42 0.45 0.50 0.60 0.72 0.86 1.00 1.05 1.01 0.95 0.91 0.87 0.87];

    Cd = interp1(M_arr, Cd_arr, M);

end
