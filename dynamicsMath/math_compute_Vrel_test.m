function math_compute_Vrel_test(vehicle_st)
    
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
    x0 = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned]; 
    
    % Vehicle state
    x = x0;

    % Wind velocity in NED
    v_ned_wind_ned = [-10*sqrt(2); 0; +10*sqrt(2)];
    
    [...
        Vrel_bcm    , ... % Relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    );
    fprintf('Vehicle pointing straight and wind coming 45deg from below \n');
    fprintf('Va %.4f, aoa %.4f, ssa %.4f  \n', Vrel_bcm(1), rad2deg(Vrel_bcm(2)), rad2deg(Vrel_bcm(3)));
    v = 1;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 6;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 2;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 5;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 3;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 8;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 4;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 7;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));        

    
    % Position of the cm wrt ned expressed in ned coord
    r_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    yaw0    = deg2rad(-45);  
    pitch0  = deg2rad(0); 
    roll0   = deg2rad(0);
    q0      = angle2quat(yaw0, pitch0, roll0);
    q_frd_ned = transpose(q0);          % 4 x 1
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    v_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Angular Velocity of frd wrt ned expressed in frd coord
    w_frd_frd_ned = [0; 0; 0];          % 3 x 1
    % Initial condition
    x0 = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned]; 
    
    % Vehicle state
    x = x0;

    % Wind velocity in NED
    v_ned_wind_ned = [-10*sqrt(2); 0; +10*sqrt(2)];
    
    [...
        Vrel_bcm    , ... % Relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    );
    fprintf('Vehicle pointing 45deg left and wind coming 45deg from below \n');
    fprintf('Va %.4f, aoa %.4f, ssa %.4f  \n', Vrel_bcm(1), rad2deg(Vrel_bcm(2)), rad2deg(Vrel_bcm(3)));
    v = 1;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 6;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 2;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 5;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 3;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 8;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 4;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 7;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));   
    
    % Position of the cm wrt ned expressed in ned coord
    r_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Quaternion for R_frd_ned rotation ( Euler Angles Phi = [phi; thta; psi] )
    yaw0    = deg2rad(-45);  
    pitch0  = deg2rad(0); 
    roll0   = deg2rad(0);
    q0      = angle2quat(yaw0, pitch0, roll0);
    q_frd_ned = transpose(q0);          % 4 x 1
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    v_ned_CM_ned = [0; 0; 0];           % 3 x 1
    % Angular Velocity of frd wrt ned expressed in frd coord
    w_frd_frd_ned = [0; 0; 0];          % 3 x 1
    % Initial condition
    x0 = [r_ned_CM_ned; q_frd_ned; v_ned_CM_ned; w_frd_frd_ned]; 
    
    % Vehicle state
    x = x0;

    % Wind velocity in NED
    v_ned_wind_ned = [-20; 0; 0];
    
    [...
        Vrel_bcm    , ... % Relative [Va, aoa, ssa] of the bcm wrt the wind
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    ] = math_compute_Vrel(...
        x               , ...   % vehicle state
        v_ned_wind_ned  , ...   % wind velocity in NED
        vehicle_st        ...   % vehicle parameters        
    );
    fprintf('Vehicle pointing 45deg left and wind coming straight \n');
    fprintf('Va %.4f, aoa %.4f, ssa %.4f  \n', Vrel_bcm(1), rad2deg(Vrel_bcm(2)), rad2deg(Vrel_bcm(3)));
    v = 1;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 6;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 2;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 5;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 3;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 8;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 4;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));
    v = 7;
    fprintf('    rot%d: Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        v, Vrel_ricm(1, v), rad2deg(Vrel_ricm(2, v)), rad2deg(Vrel_ricm(3, v)));   
    
end
