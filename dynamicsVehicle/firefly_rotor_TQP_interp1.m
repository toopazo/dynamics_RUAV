function ...
    [...
        Trotor  , ... % rotor thrust  
        Qrotor  , ... % rotor torque (due to drag)
        Protor    ... % rotor power
    ] = firefly_rotor_TQP_interp1(...
        omega       , ... % AngVel of frdi wrt frd, expressed in frdi coord
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    persistent kde_cf185_dp
    if isempty(kde_cf185_dp)
        
        % KDE-CF185-DP 
        Vsupply = 30;
        rpm2rads = (2*pi) / 60;
        rads2rpm = 60 / (2*pi);
        
        % KDE data
        throttle_arr    = [0  25.0  37.5  50.0   62.5   75.0   87.50     100 ];
        current_arr     = [0  0.90  1.80  3.10   5.10   7.90   11.70   15.50 ];
        Trotor_arr      = [0  4.12  7.26  11.57  16.48  22.36  30.11   38.34 ];
        %                  0  201   261    339    416   473     550     615  rad/s
        rpm_arr         = [0  1920  2500   3240   3980  4520    5260    5880 ];
                
        % Paero = Pelec * effcy
        % Paero = Qaero * w
        % Qaero = Paero / w
        power_arr       = Vsupply * current_arr;
        omega_arr       = rpm_arr.*rpm2rads;
        effcy           = 0.95;
        Qaero_arr       = effcy * power_arr ./ omega_arr;
        Qaero_arr(1)    = 0;
        % omega_arr
        % Qaero_arr               
        
        kde_cf185_dp.throttle_arr   = throttle_arr;
        kde_cf185_dp.current_arr    = current_arr;
        kde_cf185_dp.power_arr      = power_arr;
        kde_cf185_dp.Trotor_arr     = Trotor_arr;
        kde_cf185_dp.rpm_arr        = rpm_arr;
        kde_cf185_dp.omega_arr      = omega_arr;
        kde_cf185_dp.Qaero_arr      = Qaero_arr;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Qaero Trotor Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    omega_arr   = kde_cf185_dp.omega_arr;
    Qaero_arr   = kde_cf185_dp.Qaero_arr;
    Trotor_arr  = kde_cf185_dp.Trotor_arr;
    power_arr  = kde_cf185_dp.power_arr;
    
    omega = abs(omega);

    % vq = interp1(x, v(x), xq)
    vq2 = interp1(omega_arr, Trotor_arr, omega, 'linear');
    Trotor = vq2;              
    
    % vq = interp1(x, v(x), xq)
    vq1 = interp1(omega_arr, Qaero_arr, omega, 'linear');
    Qrotor = vq1;     
    
    % vq = interp1(x, v(x), xq)
    vq2 = interp1(omega_arr, power_arr, omega, 'linear');
    Protor = vq2;
end

