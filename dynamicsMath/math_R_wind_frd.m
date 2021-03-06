function R_wind_frd = math_R_wind_frd(aoa, ssa)    
   
    % From Steven & Lewis book. Equation 2.3-2 (page 77 third edition)        
    R_wind_frd = [...
        [ cos(aoa)*cos(ssa) ,  sin(ssa) ,  sin(aoa)*cos(ssa)   ]; ...
        [-cos(aoa)*sin(ssa) ,  cos(ssa) , -sin(aoa)*sin(ssa)   ]; ...
        [-sin(aoa)          , +0        ,  cos(ssa)            ]  ...
    ];

end
