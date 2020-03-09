function dcm = math_quat2dcm(q)
    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
    
    diag1 = (q0^2 + q1^2 - q2^2 - q3^2);
    diag2 = (q0^2 - q1^2 + q2^2 - q3^2);
    diag3 = (q0^2 - q1^2 - q2^2 + q3^2);
    
    dcm = [...
        [ (diag1)           , 2*(q1*q2 + q0*q3) , 2*(q1*q3 - q0*q2) ]   ; ...
        [ 2*(q1*q2 - q0*q3) , diag2             , 2*(q2*q3 + q0*q1) ]   ; ...
        [ 2*(q1*q3 + q0*q2) , 2*(q2*q3 - q0*q1) , diag3             ]     ...
        ];
end
