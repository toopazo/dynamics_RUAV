function [cmd_RPY, cmd_a_frd] = controller_ref_attitude(...
    t               , ... % time
    cmd_a_ned       , ... % commanded acceleration
    q_frd_ned       , ... % quaternion for R_frd_ned rotation
    cmd_yaw         , ... % commanded yaw
    controller_st   , ...
    medium_st         ...
    )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    tilt_max    = controller_st.MPC_TILTMAX_AIR;
    g_magn      = medium_st.g_magn;
    
    cmd_roll    = 0; 
    cmd_pitch   = 0; 
    % cmd_yaw     = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    if norm(cmd_a_ned) < 10^(-3)
        cmd_a_ned = [0; 0; 0];
    end
%    else
%        cmd_a_frd = cmd_a_frd / norm(cmd_a_frd);
%    end
    % cmd_a_frd = cmd_a_frd; %/ norm(cmd_a_frd);
    
    % a_ned_CM_ned
    cmd_an_ned = cmd_a_ned(1);
    cmd_ae_ned = cmd_a_ned(2);
    cmd_ad_ned = cmd_a_ned(3);
    cmd_a_frd  = math_quatrotate(q_frd_ned, cmd_a_ned);
    cmd_af_frd = cmd_a_frd(1);
    cmd_ar_frd = cmd_a_frd(2);
    cmd_ad_frd = cmd_a_frd(3);

    % Using small-angle approx on roll and pitch (yaw can be big)
    % mass * accel = sum Forces = T_frd + m*g_frd
    % m*a_frd = T_frd + Rappx_ned_frd*m*g_frd
    % m*[ af; ar; ad] = [0; 0; -T] + [-pitch; roll; m*g]
    % Therefore
    %   af      = -pitch
    %   ar      = roll
    %   m*ad    = -T + m*g
    %   => T    = m(g-ad)
    %   => yaw  = undetermined = free
    
    % T/m = g - ad
    specific_Thrust = g_magn - cmd_ad_ned;
    
    % saturate specific_Thrust, because Thrust can only be T >= 0
    if specific_Thrust <= 0
        specific_Thrust = +1/10000;
    end
    
    % point Thrust in cmd_a_frd direction 
    cmd_pitch = - cmd_af_frd / g_magn;
    cmd_roll  = + cmd_ar_frd / g_magn;
    cmd_yaw   = + cmd_yaw;

    % staturate output
    if abs(cmd_roll) >= tilt_max
        uv = cmd_roll / abs(cmd_roll);
        cmd_roll = tilt_max * uv;
    end
    if abs(cmd_pitch) >= tilt_max
        uv = cmd_pitch / abs(cmd_pitch);
        cmd_pitch = tilt_max * uv;
    end

    cmd_RPY = [0; 0; 0];
%    if t>= 10
%        cmd_pitch = deg2rad(-5);
%    end
%    RPY = simPx4.math_quat2angles(q_frd_ned);
%    yaw = RPY(3);
%    cmd_yaw = yaw + pi/10;
    cmd_RPY = [cmd_roll; cmd_pitch; cmd_yaw];

%    % Add Thrust compensation for pitch anf roll
%    RPY = math_quat2angles(q_frd_ned);
%    cmd_a_frd(3) = cmd_a_frd(3) / (cos(RPY(1))*cos(RPY(2)));
end

%    % T/m = g - ad
%    specific_Thrust = g_magn - cmd_ad_ned;

%    % saturate specific_Thrust, because Thrust can only be T >= 0
%    if specific_Thrust <= 0
%        specific_Thrust = +1/1000;
%    end
%    % point Thrust in cmd_a_ned direction 
%    cmd_roll  = + cmd_ae_ned / (specific_Thrust);
%    cmd_pitch = - cmd_an_ned / (specific_Thrust); 

