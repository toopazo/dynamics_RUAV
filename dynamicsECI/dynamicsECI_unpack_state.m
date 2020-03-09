function [...
    r_eci_bcm_eci   , ...
    q_frd_eci       , ...
    v_frd_bcm_ecef  , ...
    w_frd_frd_eci   , ...
    temp              ...
    ] = dynamicsECI_unpack_state(x)    
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % State vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Position of the bcm (frd origin) wrt ned, expressed in ned coord
    r_eci_bcm_eci = [x(1, :); x(2, :); x(3, :)];        % 3 x 1
    % Quaternion for R_frd_eci rotation ( Euler Angles Phi = [phi; thta; psi] )
    q_frd_eci = [x(4, :); x(5, :); x(6, :); x(7, :)];   % 4 x 1
    % Linear Velocity of the bcm (frd origin) wrt ned, expressed in ned coord
    v_frd_bcm_ecef = [x(8, :); x(9, :); x(10, :)];      % 3 x 1
    % Angular Velocity of the bcm (frd origin) wrt ned, expressed in frd coord
    w_frd_frd_eci = [x(11, :); x(12, :); x(13, :)];     % 3 x 1
    % Temperature
    temp = [x(14, :)];                                  % 1 x 1
    
    % x = [r_eci_bcm_eci; q_frd_eci; v_frd_bcm_ecef; w_frd_frd_eci];

end






