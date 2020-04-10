function ...
    [...
        xcldot      , ... % state derivative of the closed loop system
        ycl           ... % output of the closed loop system
    ] = clsys_xdot(...
        t           , ... % time
        xcl         , ... % state of the closed loop system
        ucl         , ... % input of the closed loop system
        vehicle_st  , ... % vehicle parameters
        medium_st     ... % medium parameters
    )    
    
    % [xcldot, ycl] = clsys_xdot_v1(t, xcl, ucl, vehicle_st, medium_st);    
    [xcldot, ycl] = clsys_xdot_v2(t, xcl, ucl, vehicle_st, medium_st);
end
