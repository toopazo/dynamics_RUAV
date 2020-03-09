function qr = math_quatinv(q)

    % Matlab built-in
%    coder.extrinsic('quatinv');    
%    r = [0, 0, 0, 0];               % simulink 
%    r = quatinv( [q(1), q(2), q(3), q(4)] );
%    qr = [0; 0; 0; 0];              % simulink 
%    qr = [r(1); r(2); r(3); r(4)];  % simulink     
    
    % Explicit implementation
    qscalar = q(1);
    qvector = [q(2); q(3); q(4)];
    qr = [qscalar; -qvector] / math_quatnorm(q);
end
