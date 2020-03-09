function arr = postprocess_state_get_arr(x_arr, name)

%    xdot = [...
%        ned_rdot_ned_CM_ned     ; ...   % 3 x 1     => 1 : 3 
%        qdot_frd_ned            ; ...   % 4 x 1     => 4 : 7 
%        frd_vdot_ned_CM_ned     ; ...   % 3 x 1     => 8 : 10 
%        frd_wdot_frd_CM_ned       ...   % 3 x 1     => 11 : 13 
%        ];

    nsize = size(x_arr);
    nstates = nsize(1);
    nsamples = nsize(2);
    
    switch name
        % x = [r_ned_bcm_ned; q_frd_ned; v_ned_bcm_ned; w_frd_bcm_ned];
        case 'pos'
            arr = x_arr(1:3, :);
        case 'quat'
            arr = x_arr(4:7, :);
        case 'vel'
            arr = x_arr(8:10, :);
        case 'angvel'
            arr = x_arr(11:13, :);
        case 'rpy'
            arr = x_arr(4:7, :);
            RPY_arr = zeros(3, size(arr, 2));
            for i = 1:size(arr, 2)
                RPY_arr(:, i) = math_quat2angles(arr(:, i));
            end
            arr = RPY_arr;
%        case 'wrel'
%            % arr = x_arr(14:37, :);
%            if nstates >= 21
%                arr = x_arr(14:21, :);
%            else
%                arr = zeros(8, nsamples);
%            end
        otherwise
            arr = [];
            fprintf('Unrecognized name %s \n', name)
    end
end

