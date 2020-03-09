function ...
    [...
        Va      , ... % airpseed
        aoa     , ... % angle of attack
        ssa       ... % side slip angle
    ] = math_vel2angles(...
        v_frd     ... % Relative velocity of the bcm wrt the wind
    )  
    
    % Flight angles
    U = v_frd(1);
    V = v_frd(2);
    W = v_frd(3);  
    Va = norm(v_frd);

    % For airspeed components [U; V; W]
    tinynum = 10^-10;
    Va = Va + tinynum;
    
    % alpha = aoa = atan2(w,u)
    % beta = ssa = asin(v/V)
    aoa = atan2(W, U);
    ssa = asin(V / Va);
%    if (Va == 0)
%        aoa = 0;
%        ssa = 0;
%    end
    
end
