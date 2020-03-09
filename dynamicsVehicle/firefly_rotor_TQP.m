function ...
    [...
        Trotor  , ... % rotor thrust  
        Qrotor  , ... % rotor torque (due to drag)
        Protor    ... % rotor power
    ] = firefly_rotor_TQP(...
        omega       , ... % AngVel of frdi wrt frd, expressed in frdi coord
        Vrel_ricm     ... % Relative [Va, aoa, ssa] of the ricm wrt the wind
    )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Qaero Trotor Model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Based on polyfit ran on firefly_rotor_TQP_interp1 results
    % See firefly_rotor_TQP_test for more details
    
    omega = abs(omega);  
    omega2 = omega.*omega; 
    
    abc = [0.000102258577452  -0.001580896261557   0.171712506745142];
    a = abc(1);
    b = abc(2);
    c = abc(3);
    Tpolyfit = a*omega2 + b*omega + c;
    
    abc = [0.000001378559411   0.000316845052952   0.003388349346153];
    a = abc(1);
    b = abc(2);
    c = abc(3);
    Qpolyfit = a*omega2 + b*omega + c;
    
    abc = [0.001681981096440  -0.303655181276143   6.766535273376869];
    a = abc(1);
    b = abc(2);
    c = abc(3);
    Ppolyfit = a*omega2 + b*omega + c;   
    
    Trotor = Tpolyfit;
    Qrotor = Qpolyfit;
    Protor = Ppolyfit;

end
