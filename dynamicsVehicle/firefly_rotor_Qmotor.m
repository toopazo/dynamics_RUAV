function ...
    [...
        Qmotor     , ... % Motor torque
        Vmotor     , ... % voltage allowed into the motor
        Imotor       ... % current allowed into the motor
    ] = firefly_rotor_Qmotor(...
        omega       , ... % angVel of rotors
        throttle    , ... % throttle from controller
        vehicle_st  , ... % rotors parameters
        medium_st     ... % medium parameters
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    throttle_P  = vehicle_st.esc.throttle_P;
    angVel_P    = vehicle_st.esc.angVel_P;    
    motor_Km    = vehicle_st.motor.constants(1);
    motor_Kv    = vehicle_st.motor.constants(2);
    motor_Kt    = vehicle_st.motor.constants(3);
    motor_R     = vehicle_st.motor.constants(4);
    motor_I0    = vehicle_st.motor.constants(5);
    motor_Vmax  = vehicle_st.motor.constants(6);
    motor_Imax  = vehicle_st.motor.constants(7);
    nrotors     = vehicle_st.geometry.nrotors;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Motor torque, voltage and current
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Qmotor = zeros(nrotors, 1);
    Vmotor = zeros(nrotors, 1);
    Imotor = zeros(nrotors, 1);
    for roti = 1:nrotors   
        % Get motor RPM and throttle
        motor_omega     = abs(omega(roti));
        motor_throttle  = throttle(roti);
    
        % Get the effective voltage applied to the motor
        err_omega   = motor_throttle * throttle_P - motor_omega;
        Veff        = err_omega * angVel_P;

        % Saturate allowed voltage
        if Veff <= 0
            Veff = 0;
        end 
        if Veff >= motor_Vmax
            Veff = motor_Vmax;
        end
            
        % Current allowed into the motor
        % Kv = RPM/V
        % Ke = V / rad/s = 1/Kv
        % Veff = R*I + Ke*omega
        allowed_I = (Veff - motor_Kt * motor_omega) / motor_R;
        
        % Saturate allowed current
        if allowed_I <= 0
            allowed_I = 0;
        end
        if allowed_I >= motor_Imax
            allowed_I = motor_Imax;
        end
        % Saturate according to max_Pelec
        % Max Pelec for all (V, I) combinations
        % max_Pelec = motor_Vmax * motor_Imax;
        % Imax @ given V
        % Imax = max_Pelec / Veff;
        % if allowed_I >= Imax
        %     allowed_I = Imax;
        % end
        
        motor_Q = (allowed_I - motor_I0) * motor_Kt;
        if motor_Q < 0
            motor_Q = 0;
        end
        Pmotor = motor_Q * motor_omega;
        Pelec  = Veff * allowed_I;
        effcy  = Pmotor / Pelec;
    
        signi = firefly_rotor_spin_direction(roti);
        motor_Q = +1 * signi * motor_Q; % Qmotor favors the spin direction
        
        Qmotor(roti) = motor_Q;     % Motor torque
        Imotor(roti) = allowed_I;   % current allowed into the motor
        Vmotor(roti) = Veff;        % voltage allowed into the motor
    end    
end

