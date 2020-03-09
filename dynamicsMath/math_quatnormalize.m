function qr = math_quatnormalize(q)

    % Matlab built-in
%    coder.extrinsic('quatnormalize');    
%    r = [0, 0, 0, 0];               % simulink 
%    r = quatnormalize( [q(1), q(2), q(3), q(4)] );
%    qr = [0; 0; 0; 0];              % simulink 
%    qr = [r(1); r(2); r(3); r(4)];  % simulink     
    
    % Explicit implementation
    qnorm = sqrt( q(1)^2 + q(2)^2 + q(3)^2 + q(4)^2 );
    qr = q./qnorm;
end
