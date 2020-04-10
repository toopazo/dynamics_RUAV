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
    % Geometry properties of vehicle and rotors
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
    st.geometry.nrotors = 8;    
        
    % Create array of rotor location
    % distance of rot1 wrt Center of Geometry
    rx = 0.33;
    ry = 0.60;
    rz = 0.12;
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
        
    % Create array of rotor DCM        
    % angle2dcm(yaw, pitch, roll) = Rotation matrix of Rotor-i wrt (f, r, d)
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
    
    % Create array of rotor MOI
%              x-axis
%                 |
%                 |
%    <========= (z-axis) =========>  --- y-axis
%                            
%    cm2m = 1.0 / 100;
%    g2kg = 1.0 / 1000;    
%    mass =  110 * g2kg;;
%    radius = 1.0 * cm2m;
%    height = 62.0 * cm2m;
%    height_axis = 2;            % rotors lives along f-r plane             
%    % MOI wrt local ricm
%    Jrot1_frd1_r1cm = math_MOI_solid_cylinder(...
%        mass, radius, height, height_axis);
%    Jrot1_frd1_r1cm =
%        0.0035         0         0
%             0    0.0000         0
%             0         0    0.0035

    Jrot1_frd1_r1cm = [...
        [0.003526416666667, 0                ,  0                   ] ; ...
        [0                , 0.000005500000000,  0                   ] ; ...
        [0                , 0                ,  0.003526416666667   ]   ...
    ];
    
    % Assume all rotor to have the same MOI
    Jroti_frdi_ricm = zeros(3, 3, st.geometry.nrotors);
    for i = 1:st.geometry.nrotors
        Jroti_frdi_ricm(:, :, i) = Jrot1_frd1_r1cm;
    end
        
    st.geometry.Jroti_frdi_ricm = Jroti_frdi_ricm;
    
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
    st.controller.MC_ROLLRATE_P        = 1.0000/7; % 2.5
    st.controller.MC_ROLLRATE_I        = 0.2000/6; % 0.5    
    st.controller.MC_ROLLRATE_D        = 0.0;
    st.controller.MC_ROLLRATE_FF       = 000.000;
        
    % fprintf('Pitch rate <==> Q \n');
    % anglAccel / anglVel = rad/s^2 / rad/s = 1 / s
    st.controller.MC_PITCHRATE_P       = 1.0000/7;  % 2.8065   
    st.controller.MC_PITCHRATE_I       = 0.2000/5; %0.5        
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
    st.controller.MC_ROLL_P            = 0.500; %0.8
    st.controller.MC_ROLL_TC           = 000.200;
    
    % fprintf('Pitch angle <==> phi = P \n');
    % angleVel / angle = rad/s / rad = 1 / s         
    st.controller.MC_PITCH_P           = 0.500;    % 0.5
    st.controller.MC_PITCH_TC          = 000.200;
    
    % fprintf('Yaw angle <==> psi = Y \n');
    % angleVel / angle = rad/s / rad = 1 / s
    st.controller.MC_YAW_P             = 0.8;
    st.controller.MC_YAW_FF            = 000.000; % 000.500
    
    % fprintf('ne velocity (xy) \n');
    % accel / vel = m/s^2 / m/s = 1 / s
    st.controller.MPC_XY_VEL_P         = 0.80; % 1.00*0.9546/6.0 % = 0.1767 %0.0636*10  
    st.controller.MPC_XY_VEL_I         = 0.015;% 0.05*0.9546/6.0 = 0.0079   %0.0014*10
    st.controller.MPC_XY_VEL_D         = 0.0;
    
    % fprintf('d velocity (z) \n');
    % accel / vel = m/s^2 / m/s = 1 / s
    st.controller.MPC_Z_VEL_P          = 1.0;% 1.00*1.350/2.0; % = 0.6750
    st.controller.MPC_Z_VEL_I          = 0.15;% 0.10*1.350/1.0; % = 0.0675
    st.controller.MPC_Z_VEL_D          = 0.0;

    % fprintf('ne position (xy) \n');
    % vel / pos = m/s / m = 1/s
    st.controller.MPC_XY_P             = 0.3333*14;
    st.controller.MPC_XY_FF            = 0.500 * 0.0;
    
    % fprintf('d position (z) \n');
    % vel / pos = m/s / m = 1/s
    st.controller.MPC_Z_P              = 0.200;
    st.controller.MPC_Z_FF             = 0.500 * 0.0;    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ESC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    st.esc.zoh              = 1/100;            % Update frequency, in Hz
    st.esc.throttle_P       = 650;              % Gain in rad/s  / 1 = rad/s
    st.esc.angVel_P         = 0.9;              % Gain in V / rad/s
    st.esc.current_P        = 0.9;              % Gain in A / A = 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Motor constants
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    https://www.kdedirect.com/products/kde6213xf-185
    %        Kv (Motor Velocity Constant) 	185 RPM/V
    %        Kt (Motor Torque Constant) 	0.0516 Nm/A
    %        Km (Motor Constant) 	        0.1924 Nm/√(W)
    %        Maximum Continuous Current* 	62+ A (180 s)
    %        Maximum Continuous Power* 	    2755+ W (180 s)
    %        Maximum Efficiency 	        > 93%
    %        Voltage Range 	                22.2 V (6S LiPo) - 52.2 V (12S LiHV)
    %        Io (@10V) 	                    0.6 A
    %        Rm (Wind Resistance) 	        0.072 Ω
    %        Stator Poles 	                24 (24S28P, HE)
    %        Magnetic Poles 	            28 (24S28P, HE)
    %        Bearings 	                    Triple, 698-2RS/608-2RS
    %        Mount Pattern 	                M4 x ф30 mm, M5/M4 x ф40 mm
    %        Stator Class 	                6213, 0.2 mm Japanese
    %        Shaft Diameter 	            ф4 mm (ф8 mm Internal)
    %        Shaft Length 	                5.5 mm
    %        Motor Diameter 	            ф70 mm
    %        Motor Length 	                39 mm
    %        Motor Weight 	                360 g (415 g with Wires/Bullets)
    %        Propeller propeller Size 	        Up to 24.5"-TP (24.5"-DP Maximum on 12S)
    %        Motor Timing 	                22° - 30°
    %        ESC PWM Rate 	                16 - 32 kHz (600 Hz)

    motor_Kt = 0.0516;
    motor_Km = 0.1924;
    motor_Kv = 1 / motor_Kt; % 60 / (2 * pi * x [rpm / V]);
    motor_R = 0.072 * 2;
    motor_I0 = 0.6;
    motor_V = 0.9*(2*4*4.2);
    motor_Imax = 37.5;    % 300 A for Dragonfly in total (300/8 = 37.5 A)
    motor_Vmax  = (2*4*4.2);
    
    st.motor.motor_Kt   = motor_Kt;             % Kt constant in N m / A
    st.motor.motor_Km   = motor_Km;             % Km constant in N m / sqrt(W)
    st.motor.motor_Kv   = motor_Kv;             % Kv constant in rpm / V
    st.motor.motor_R    = motor_R;              % Widing resistance in ohm
    st.motor.motor_I0   = motor_I0;             % Idle current in A
    st.motor.motor_Vmax = motor_Vmax;           % Voltage in V
    st.motor.motor_Imax = motor_Imax;           % Max current in A
    st.motor.constants  = [...
        st.motor.motor_Km   , ...
        st.motor.motor_Kv   , ...
        st.motor.motor_Kt   , ...
        st.motor.motor_R    , ...
        st.motor.motor_I0   , ...
        st.motor.motor_Vmax , ...
        st.motor.motor_Imax   ...        
        ];          
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initial condition
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Position of the cm wrt ned expressed in ned coord
    r_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    yaw0    = deg2rad(1*10);  
    pitch0  = deg2rad(1*20); 
    roll0   = deg2rad(1*30);
    q0      = angle2quat(yaw0, pitch0, roll0);
    q_frd_ned = transpose(q0);          % 4 x 1
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    v_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Angular Velocity of frd wrt ned expressed in frd coord
    w_frd_frd_ned = [0; 0; 0];          % 3 x 1
    % Initial condition
    st.x0 = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned];  
    
    % AngVel of rotor ricm wrt frd, expressed in frdi coord (local body coord)
    % w_frdi_roti_frd = zeros(24, 1);     % 24 x 1
    omega = ones(st.geometry.nrotors, 1);              % 8 x 1
    % omega0 = 0;
    % omega0 = 278;
    omega0 = 56;
    for roti = 1:st.geometry.nrotors
        omega(roti) = firefly_rotor_spin_direction(roti) * omega0;
    end
    st.omega0 = omega;
    
    % omegadot = ones(8, 1);             % 8 x 1
    % st.motors_x0 = [wrel; wreldot];  
    
end

