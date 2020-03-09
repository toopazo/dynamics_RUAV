function qr = math_quatmultiply(q1, q2)

    % Matlab built-in
    coder.extrinsic('quatmultiply');
    r = [0, 0, 0, 0];               % simulink 
    r = quatmultiply( [q1(1), q1(2), q1(3), q1(4)], ...
        [q2(1), q2(2), q2(3), q2(4)] );
    qr = [0; 0; 0; 0];              % simulink 
    qr = [r(1); r(2); r(3); r(4)];  % simulink     
end
