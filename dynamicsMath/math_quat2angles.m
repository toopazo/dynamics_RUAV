function [RPY] = math_quat2angles(q)

%    persistent simulate_st
%    if isempty(simulate_st)
%        [body_st, medium_st, simulate_st] = load_st_from_file();
%        
%        if (simulate_st.casadi == false)
%            disp('[math_quat2angles] simulate_st.casadi is false')
%        else
%            disp('[math_quat2angles] simulate_st.casadi is true')
%        end        
%    end

    % Matlab built-in
%    coder.extrinsic('quat2angle');
%    [yaw, pitch, roll] = quat2angle( [q(1), q(2), q(3), q(4)] );
%    RPY = [0; 0; 0];            % simulink 
%    RPY = [roll; pitch; yaw];
    
    % Explicit implementation
    RPY = toEulerAngle(q);
    
    % Taken from:
    % en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    % Based on:
    % Blanco, Jose-Luis (2010). "A tutorial on se (3) transformation 
    % parameterizations and on-manifold optimization". 
    % University of Malaga, Tech. Rep.
    function RPY = toEulerAngle(q)
        qw = q(1);
        qx = q(2);
        qy = q(3);
        qz = q(4);
    
	    % roll (x-axis rotation)
	    sinr_cosp = +2.0 * (qw * qx + qy * qz);
	    cosr_cosp = +1.0 - 2.0 * (qx * qx + qy * qy);
	    roll = atan2(sinr_cosp, cosr_cosp);

	    % pitch (y-axis rotation)
	    sinp = +2.0 * (qw * qy - qz * qx);
	    % if (simulate_st.casadi == false) && (abs(sinp) >= 1)
	    if ( abs(sinp) >= 1 )
		    pitch = (pi/2) * sign(sinp); % use 90 degrees if out of range
	    else
		    pitch = asin(sinp);
	    end

	    % yaw (z-axis rotation)
	    siny_cosp = +2.0 * (qw * qz + qx * qy);
	    cosy_cosp = +1.0 - 2.0 * (qy * qy + qz * qz);  
	    yaw = atan2(siny_cosp, cosy_cosp);
	    
	    RPY = [roll; pitch; yaw];
    end
end
