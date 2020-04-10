function [cmd_throttle] = controller_mixer(...
    cmd_ad_frd      , ...
    cmd_angAccel    , ...
    controller_st     ...
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    angAccel_max    = controller_st.MPC_ANGACC_MAX;
    accel_d_max     = controller_st.MPC_ACC_DOWN_MAX;
    hover_thtl      = controller_st.hover_thtl;
    
    % coder.extrinsic('linsolve')
    % coder.extrinsic('size')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % output is Thrust level for T1 T2 T3 T4
    
    % Yaw rotation can be archive by:
    % 
    % 1) Torque: If the Thrust vector has an f-r component, 
    % then we can archive yaw rotation as in the case of pitch and roll. 
    % 
    % 2) Reaction-torque: Yaw rotation can also be archived by the aerodynamic
    % torque produced by rotors (drag). This is an external torque whose net
    % effect is applied to the CM of the vehicle
            
    cmd_throttle = [0; 0; 0; 0; 0; 0; 0; 0];
    
    % From build/nuttx_px4fmu-v4_default/src/lib/mixer/mixer_multirotor_normalized.generated.h
%    const MultirotorMixer::Rotor _config_octa_cox[] = {
%	    { -0.707107,  0.707107,  1.000000,  1.000000 },
%	    {  0.707107,  0.707107, -1.000000,  1.000000 },
%	    {  0.707107, -0.707107,  1.000000,  1.000000 },
%	    { -0.707107, -0.707107, -1.000000,  1.000000 },
%	    {  0.707107,  0.707107,  1.000000,  1.000000 },
%	    { -0.707107,  0.707107, -1.000000,  1.000000 },
%	    { -0.707107, -0.707107,  1.000000,  1.000000 },
%	    {  0.707107, -0.707107, -1.000000,  1.000000 },
%    };
    
    % Inwards canted rotors effects (e.g firefly and dragonfly)
    % rotors number 1 2 3 4 5 6 7 8 
    % Y rate sign   - + - + + - + -     
    config_octa_cox = [...
        ...% R rate,    P rate,    Y rate,     accel_d
        [ -0.707107,  0.707107,  1.000000,  -1.000000 ]; ...     % rotor1
        [  0.707107,  0.707107, -1.000000,  -1.000000 ]; ...     % rotor2
        [  0.707107, -0.707107,  1.000000,  -1.000000 ]; ...     % rotor3
        [ -0.707107, -0.707107, -1.000000,  -1.000000 ]; ...     % rotor4
        [  0.707107,  0.707107,  1.000000,  -1.000000 ]; ...     % rotor5
        [ -0.707107,  0.707107, -1.000000,  -1.000000 ]; ...     % rotor6
        [ -0.707107, -0.707107,  1.000000,  -1.000000 ]; ...     % rotor7
        [  0.707107, -0.707107, -1.000000,  -1.000000 ]; ...     % rotor8
    ];
        
    num_rotors = 8;
    mixer_output = zeros(num_rotors, 1);
    m_rotors = config_octa_cox;
    roll_column      = 1;
    pitch_column     = 2;
    yaw_column       = 3;
    thrust_column    = 4;      
    
    % Scale inputs and perform Control Allocation
    roll_rate   = cmd_angAccel(1) / angAccel_max;
    pitch_rate  = cmd_angAccel(2) / angAccel_max;
    yaw_rate    = cmd_angAccel(3) / angAccel_max;
    vert_accel  = cmd_ad_frd / accel_d_max;
    
    for i = 1:num_rotors
        vert_out = ...
            hover_thtl  + ...
            vert_accel  * m_rotors(i, thrust_column)   ...
            ;
        if vert_out >= 0.95
            vert_out = 0.95;
        end
        
        out = ...
            roll_rate   * m_rotors(i, roll_column)   + ...
            pitch_rate  * m_rotors(i, pitch_column)  + ...
            yaw_rate    * m_rotors(i, yaw_column)    + ...
            vert_out                                   ...
            ;
%        out = ...
%            hover_thtl  + ...
%            roll_rate   * m_rotors(i, roll_column)   + ...
%            pitch_rate  * m_rotors(i, pitch_column)  + ...
%            yaw_rate    * m_rotors(i, yaw_column)    + ...
%            vert_accel  * m_rotors(i, thrust_column)   ...
%            ;
        cmd_throttle(i) = out;
    end
    
    % Saturate throttle
    throttle_min = 0.0;
    throttle_max = 1.0;
    i = 0;
    for i=1:num_rotors
        if cmd_throttle(i) < throttle_min
            cmd_throttle(i) = throttle_min;
        end
        if cmd_throttle(i) > throttle_max
            cmd_throttle(i) = throttle_max;
        end
    end    
    % cmd_throttle
        
end

