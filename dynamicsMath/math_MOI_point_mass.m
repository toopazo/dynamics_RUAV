function J_frd = math_MOI_point_mass(mass, r_frd_rot_CM)
    m = mass;
    x = r_frd_rot_CM(1);
    y = r_frd_rot_CM(2);
    z = r_frd_rot_CM(3);
    J_frd = [...
        [ +m*(y^2 + z^2)    , -m*x*y            , -m*z*x            ];...
        [ -m*x*y            , +m*(z^2 + x^2)    , -m*y*z            ];...
        [ -m*z*x            , -m*y*z            , +m*(x^2 + y^2)    ]...
        ];


%    function [Jf, Jr, Jd] = parallel_axis_MOI(Jf, Jr, Jd, r_frd_rot_CM)
%        % r_frd_rot_CM = position in frd coord, of the cm of the element wrt 
%        % the CM of the whole body
%        proj_n0 = [[0, 0, 0]; [0, 1, 0]; [0, 0, 1]];
%        proj_e0 = [[1, 0, 0]; [0, 0, 0]; [0, 0, 1]];
%        proj_d0 = [[1, 0, 0]; [0, 1, 0]; [0, 0, 0]];
%        
%        parallel_axis_n = norm( proj_n0 * r_frd_rot_CM );
%        parallel_axis_e = norm( proj_e0 * r_frd_rot_CM );
%        parallel_axis_d = norm( proj_d0 * r_frd_rot_CM );

%        Jf = Jf + mass * parallel_axis_n^2;
%        Jr = Jr + mass * parallel_axis_e^2;
%        Jd = Jd + mass * parallel_axis_d^2;
%    end
end


