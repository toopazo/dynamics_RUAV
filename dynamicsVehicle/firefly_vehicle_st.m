function st = firefly_vehicle_st()

    coder.extrinsic('angle2dcm');      % simulink stupidity
  
%    Note:   See line 648 for actual paramter definition. 
%            All previous lines are preliminary calculations
       
%{
    n
    ^
    |
    |
    +-------> e
    d
                               +-----+
                               |     |
                               |     |
    +---------+                |     |                +---------+
    |         |                |     |                |         |
    |    +-------------------------------------------------+    |
    |    |    |                |     |                |    |    |
    |    |    |                |     |                |    |    |
    |    +-------------------------------------------------+    |
    |         |                |     |                |         |
    +---------+                |     |                +---------+
                               |  f  |
                               |  ^  |
                               |  |  |
                               |  |  |
                               | CM--|-----> r 
                               |     |
                               |     |
                               |     |
                               |     |
    +---------+                |     |                +---------+
    |         |                |     |                |         |
    |    +-------------------------------------------------+    |
    |    |    |                |     |                |    |    |
    |    |    |                |     |                |    |    |
    |    +-------------------------------------------------+    |
    |         |                |     |                |         |
    +---------+                +-----+                +---------+
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Defintions:
    
    wrt     = With respect to
  
    body    = Assumed as rigid and continuos
    
    bcm      = Center of mass of the body. 
               This is the origin of the (f, r, d) coord system   
  
    bcg      = Center of Geometry
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Coordinate systems and rotations:
    
    ned     = Inertial reference frame
    
    frd     = Non-inertial reference frame of the body
    
    RPY     = [Roll; Pitch; Yaw] rotation angles. 
            Roll is rotation along f
            Pitch is rotation along r
            Yaw is rotation along d
    
    Rotation matrices assume a 3-2-1 rotation = Y-P-R rotation
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Variable names:
    
    r_coordA_pointB_pointC  = Position, expressed in A coordinates, of point B 
                            with respect to point C
    
    JobjA_coordB_cmC        = Moments of inertia of object A, expressed in B 
                            coordinates, about center of mass C
    
    R_coordA_coordB         = Rotation matrix between coordinates A and B, 
                            it transform a vector from coordB to coordA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    Discussion about CM and CG:
    
    By definition r_frd_CM_CM = [0; 0; 0];
    
    In general, we know the relative location of a vechicle components (motors,
    propellers, and so on) wrt the CG of the vechicle and not the CM
    
    If the body is not perfectly balanced, the location of CG wrt frd coord 
    could be non-zero. In general it could even vary with time.
    
    r_frd_CG_CM = [0; 0; 0];        % here we assumed perfect balance
    r_frd_bcm_cg = - r_frd_CG_CM;

    By noting that any point P in frd coord system can be writter as

         f          P
         ^                  
         |
         |      CG            
        CM-----> r

        r_frd_P_CM = r_frd_CG_CM + r_frd_P_CG
        r_frd_P_CG = r_frd_bcm_cg + r_frd_P_CM
    we can re-write 
        r_frd_P_CM = r_frd_P_CG - r_frd_bcm_cg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    Units:
    
    All units are SI => (kg, m, s)
    
%}

    % deg2rad = pi / 180;
    % rad2deg = 180 / pi;
    % rpm2rads = (2*pi) / 60;
    % rads2rpm = 60 / (2*pi);

    r_frd_CM_CM = [0; 0; 0];
    r_frd_bcm_cg = [0; 0; 0];
    r_frd_CG_CM = -r_frd_bcm_cg;

    % cm2m = 1.0 / 100;
    % g2kg = 1.0 / 1000;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Inertia properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    
    body_mass = 15.0;
        
    J_frd_bcm = [...
        [ 2.3497,    0,      0       ]; ...
        [ 0,         1.3518, 0       ]; ...
        [ 0,         0,      3.4830  ]  ...
    ];
    Jinv_frd_bcm  = J_frd_bcm^(-1);

    st.inertia.mass         = body_mass;        % Mass in kg
    st.inertia.J_frd_bcm    = J_frd_bcm;     % MOI matrix in kg m^2
    st.inertia.Jinv_frd_bcm = Jinv_frd_bcm;  % MOI matrix in kg m^2
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Aerodynamic properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       

    st.aero.cross_area  = 1;        % front view area
    st.aero.wing_span   = 1.2;      % wing span
    st.aero.wing_chord  = 0.1;      % mean aero wing chord    
    st.aero.charLenght  = 1.2; 
    
    % Coeff = fnct(aoa, ssa, Mach, altitude)
    st.aero.coeff.Cdrag         = @firefly_coeff_Cdrag;
    st.aero.coeff.Clift         = @firefly_coeff_Clift;
    st.aero.coeff.Ccrosswind    = @firefly_coeff_Ccrosswind;
    st.aero.coeff.CrollM        = @firefly_coeff_CrollM;
    st.aero.coeff.CpitchM       = @firefly_coeff_CpitchM;
    st.aero.coeff.CyawM         = @firefly_coeff_CyawM;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Geometry properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
    st.geometry.nrotors = 8;    
    
    % distance of rot1 wrt Center of Geometry
    rx = 0.33;
    ry = 0.60;
    rz = 0.12;
    
    % Create array of locations for all rotors
    r_frd_roti_cg = zeros(3, st.geometry.nrotors);
    
    r_frd_roti_cg(:, 1) = [+rx; +ry; -rz];
    r_frd_roti_cg(:, 6) = [+rx; +ry; +rz];
    
    r_frd_roti_cg(:, 2) = [+rx; -ry; -rz];
    r_frd_roti_cg(:, 5) = [+rx; -ry; +rz];
    
    r_frd_roti_cg(:, 3) = [-rx; -ry; -rz];
    r_frd_roti_cg(:, 8) = [-rx; -ry; +rz];
    
    r_frd_roti_cg(:, 4) = [-rx; +ry; -rz];
    r_frd_roti_cg(:, 7) = [-rx; +ry; +rz];
        
    st.geometry.r_frd_roti_cg = r_frd_roti_cg;    
        
    % angle2dcm(yaw, pitch, roll) = Rotation matrix of Rotor-i wrt (f, r, d)
    % Create array of DCMs for all rotors
    R_frdi_frd = zeros(3, 3, st.geometry.nrotors);
    R_frd_frdi = zeros(3, 3, st.geometry.nrotors);
        
    rot1_yaw      = 0*pi/180;
    rot1_pitch    = 0*pi/180;     % +10*pi/180;
    rot1_roll     = -10*pi/180;
    R_frdi_frd(:, :, 1) = angle2dcm(rot1_yaw, rot1_pitch, rot1_roll);
    R_frd_frdi(:, :, 1) = R_frdi_frd(:, :, 1)^(-1);
    rot6_yaw      = rot1_yaw;
    rot6_pitch    = rot1_pitch;
    rot6_roll     = rot1_roll;
    R_frdi_frd(:, :, 6)  = angle2dcm(rot6_yaw, rot6_pitch, rot6_roll);
    R_frd_frdi(:, :, 6) = R_frdi_frd(:, :, 6)^(-1);
    
    rot2_yaw      = 0*pi/180;
    rot2_pitch    = 0*pi/180;     % +10*pi/180;
    rot2_roll     = +10*pi/180;
    R_frdi_frd(:, :, 2) = angle2dcm(rot2_yaw, rot2_pitch, rot2_roll);
    R_frd_frdi(:, :, 2) = R_frdi_frd(:, :, 2)^(-1);
    rot5_yaw      = rot2_yaw;
    rot5_pitch    = rot2_pitch;
    rot5_roll     = rot2_roll;
    R_frdi_frd(:, :, 5) = angle2dcm(rot5_yaw, rot5_pitch, rot5_roll);
    R_frd_frdi(:, :, 5) = R_frdi_frd(:, :, 5)^(-1);
    
    rot3_yaw      = 0*pi/180;
    rot3_pitch    = 0*pi/180;     % -10*pi/180;
    rot3_roll     = +10*pi/180;
    R_frdi_frd(:, :, 3) = angle2dcm(rot3_yaw, rot3_pitch, rot3_roll);
    R_frd_frdi(:, :, 3) = R_frdi_frd(:, :, 3)^(-1);
    rot8_yaw      = rot3_yaw;
    rot8_pitch    = rot3_pitch;
    rot8_roll     = rot3_roll;
    R_frdi_frd(:, :, 8) = angle2dcm(rot8_yaw, rot8_pitch, rot8_roll);
    R_frd_frdi(:, :, 8) = R_frdi_frd(:, :, 8)^(-1);

    rot4_yaw      = 0*pi/180;
    rot4_pitch    = 0*pi/180;     % -10*pi/180;
    rot4_roll     = -10*pi/180;
    R_frdi_frd(:, :, 4) = angle2dcm(rot4_yaw, rot4_pitch, rot4_roll);
    R_frd_frdi(:, :, 4) = R_frdi_frd(:, :, 4)^(-1);
    rot7_yaw      = rot4_yaw;
    rot7_pitch    = rot4_pitch;
    rot7_roll     = rot4_roll;
    R_frdi_frd(:, :, 7) = angle2dcm(rot7_yaw, rot7_pitch, rot7_roll);
    R_frd_frdi(:, :, 7) = R_frdi_frd(:, :, 7)^(-1);
    
    st.geometry.R_frdi_frd = R_frdi_frd;           % Rotation matrix array
    st.geometry.R_frd_frdi = R_frd_frdi;           % Rotation matrix array         
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Controller gains
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    st.controller.hover_thtl = 0.4;
    
    % fprintf('Safety params \n');      
    st.controller.MPC_TILTMAX_AIR       = deg2rad(45.000);     % rad    
    st.controller.MPC_ACC_DOWN_MAX      = 1.350;                  % m / s^2
    st.controller.MPC_ACC_HOR_MAX       = 0.9546; % cos(pi/4)*g = 0.9546 => x1.5 = 1.4319 % m / s^2
    st.controller.MPC_ACC_UP_MAX        = 3.000;                  % m / s^2 
    st.controller.MPC_ANGACC_MAX        = deg2rad(45.000);       % rad / s^2 
    st.controller.MC_ROLLRATE_MAX       = deg2rad(90.000);
    st.controller.MC_PITCHRATE_MAX      = deg2rad(90.000);
    st.controller.MC_YAWRATE_MAX        = deg2rad(90.000);
    st.controller.MPC_XY_VEL_MAX        = 12.500;
    st.controller.MPC_Z_VEL_MAX         = 10.000;
    st.controller.MPC_Z_VEL_MAX_DN      = 05.000;
    st.controller.MPC_Z_VEL_MAX_UP      = 10.000;
    
    % fprintf('Roll rate <==> P \n');    
    % anglAccel / anglVel = rad/s^2 / rad/s = 1 / s
    st.controller.MC_ROLLRATE_P        = 0.7948; % 2.5
    st.controller.MC_ROLLRATE_I        = 0.2266; % 0.5    
    st.controller.MC_ROLLRATE_D        = 0.0;
    st.controller.MC_ROLLRATE_FF       = 000.000;
        
    % fprintf('Pitch rate <==> Q \n');
    % anglAccel / anglVel = rad/s^2 / rad/s = 1 / s
    st.controller.MC_PITCHRATE_P       = 2.0;  % 2.8065   
    st.controller.MC_PITCHRATE_I       = 0.001; %0.5        
    st.controller.MC_PITCHRATE_D       = 0.0;
    st.controller.MC_PITCHRATE_FF      = 000.000;

    % fprintf('Yaw rate <==> R \n');
    % anglAccel / anglVel = rad/s^2 / rad/s = 1 / s
    st.controller.MC_YAWRATE_P         = 5.000;              
    st.controller.MC_YAWRATE_I         = 0.001;
    st.controller.MC_YAWRATE_D         = 0.0;
    st.controller.MC_YAWRATE_FF        = 000.000;
    
    % fprintf('Roll angle <==> theta = R \n');
    % angleVel / angle = rad/s / rad = 1 / s
    st.controller.MC_ROLL_P            = 0.5909; %0.8
    st.controller.MC_ROLL_TC           = 000.200;
    
    % fprintf('Pitch angle <==> phi = P \n');
    % angleVel / angle = rad/s / rad = 1 / s         
    st.controller.MC_PITCH_P           = 0.6210;    % 0.5
    st.controller.MC_PITCH_TC          = 000.200;
    
    % fprintf('Yaw angle <==> psi = Y \n');
    % angleVel / angle = rad/s / rad = 1 / s
    st.controller.MC_YAW_P             = 0.2;
    st.controller.MC_YAW_FF            = 000.000; % 000.500
    
    % fprintf('ne velocity (xy) \n');
    % accel / vel = m/s^2 / m/s = 1 / s
    st.controller.MPC_XY_VEL_P         = 1.10; % 1.00*0.9546/6.0 % = 0.1767 %0.0636*10  
    st.controller.MPC_XY_VEL_I         = 0.00164;% 0.05*0.9546/6.0 = 0.0079   %0.0014*10
    st.controller.MPC_XY_VEL_D         = 0.0;
    
    % fprintf('d velocity (z) \n');
    % accel / vel = m/s^2 / m/s = 1 / s
    st.controller.MPC_Z_VEL_P          = 1.00*1.350/2.0; % = 0.6750
    st.controller.MPC_Z_VEL_I          = 0.10*1.350/1.0; % = 0.0675
    st.controller.MPC_Z_VEL_D          = 0.0;

    % fprintf('ne position (xy) \n');
    % vel / pos = m/s / m = 1/s
    st.controller.MPC_XY_P             = 0.3333*14;
    st.controller.MPC_XY_FF            = 0.500 * 0.0;
    
    % fprintf('d position (z) \n');
    % vel / pos = m/s / m = 1/s
    st.controller.MPC_Z_P              = 0.200;
    st.controller.MPC_Z_FF             = 0.500 * 0.0;    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initial condition
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Position of the cm wrt ned expressed in ned coord
    r_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    yaw0    = deg2rad(0);  
    pitch0  = deg2rad(0); 
    roll0   = deg2rad(0);
    q0      = angle2quat(yaw0, pitch0, roll0);
    q_frd_ned = transpose(q0);          % 4 x 1
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    v_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Angular Velocity of frd wrt ned expressed in frd coord
    w_frd_frd_ned = [0; 0; 0];          % 3 x 1
    % Initial condition
    st.x0 = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned];  
    
%    % AngVel of rotor ricm wrt frd, expressed in frdi coord (local body coord)
%    % w_frdi_roti_frd = zeros(24, 1);     % 24 x 1
%    omega = ones(8, 1);                % 8 x 1
%    omega(1) = +1;% -1;
%    omega(2) = +1;
%    omega(3) = +1;% -1;
%    omega(4) = +1;
%    omega(5) = +1;% -1;
%    omega(6) = +1;
%    omega(7) = +1;% -1;
%    omega(8) = +1;
%    
%    omega0 = 0;
%    % omega0 = 278;
%    % omega0 = 56;
%    wrel = omega * omega0;
%    st.motors_x0 = [wrel];
%    
%    % omegadot = ones(8, 1);             % 8 x 1
%    % st.motors_x0 = [wrel; wreldot];  
    
end

