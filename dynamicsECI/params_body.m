function st = params_body()

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

    deg2rad = pi / 180;
    rad2deg = 180 / pi;
    rpm2rads = (2*pi) / 60;
    rads2rpm = 60 / (2*pi);

    r_frd_CM_CM = [0; 0; 0];
    r_frd_bcm_cg = [0; 0; 0];
    r_frd_CG_CM = -r_frd_bcm_cg;

    cm2m = 1.0 / 100;
    g2kg = 1.0 / 1000;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mass = 1.0;     % mass kg
    S = 0.1;        % cross section area m^2
        
    Jbdy_frd_bcm = [...
        [ 2.3497,    0,      0       ]; ...
        [ 0,         1.3518, 0       ]; ...
        [ 0,         0,      3.4830  ]  ...
    ];
    Jbdyinv_frd_bcm  = Jbdy_frd_bcm^(-1);

    st.bdy.mass             = mass;        % Mass in kg
    st.bdy.S                = S;           % m^2
    st.bdy.Jbdy_frd_bcm     = Jbdy_frd_bcm;     % MOI matrix in kg m^2
    st.bdy.Jbdyinv_frd_bcm  = Jbdyinv_frd_bcm;  % MOI matrix in kg m^2
    
end

