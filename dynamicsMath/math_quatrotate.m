function vr = math_quatrotate(q, v)

    % Matlab built-in
%    coder.extrinsic('quatrotate');
%    r = [0, 0, 0];              % simulink 
%    r = quatrotate( [q(1), q(2), q(3), q(4)], [v(1), v(2), v(3)] );
%    vr = [0; 0; 0];             % simulink 
%    vr = [r(1); r(2); r(3)];    % simulink 

    % Explicit implementation
    qscalar = q(1);
    qvector = [q(2); q(3); q(4)];
    uvector = v; % [v(2); v(3); v(4)];
    qrscalar = 0;
    qrvector = (...
        2 * (transpose(qvector) * uvector) * qvector             + ...
        ( qscalar^2 - (transpose(qvector) * qvector) ) * uvector   - ...
        2 * qscalar * cross(qvector, uvector)             ...
        );
    qr = [qrscalar; qrvector];
    vr = [qrvector];   
    
    % Rq = math_quat2dcm(q)
    % vr = Rq*v
    
    % test it with 
    function test()
        v = [1; 0; 0]
        eul = [rand*2*pi rand*2*pi rand*2*pi];
        eul_deg = eul*180/pi
        qZYX = eul2quat(eul)
        vr1 = quatrotate(qZYX, transpose(v))
        vr2 = math_quatrotate(qZYX, v)
        err = transpose(vr1) - vr2
    end
end
