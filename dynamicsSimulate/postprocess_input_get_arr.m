function [arr] = postprocess_input_get_arr(u_arr, name)

    nsize = size(u_arr);
    ninputs = nsize(1);
    nsamples = nsize(2);

    switch name
        % u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
        case 'Fnet'
            arr = u_arr(1:3, :);
        case 'Mnet'
            arr = u_arr(4:6, :);
        case 'Mrot'
            arr = u_arr(7:9, :);

        % u = [Vcmd; yawcmd];
        case 'Vcmd'
            arr = u_arr(1:3, :);
        case 'yawcmd'
            arr = u_arr(4:4, :);            

        % u = [Tarm];            
        case 'Tarm'
            arr = u_arr(1:4, :);

        % u = [omega; omegadot];                           
        case 'omega'
            arr = u_arr(1:8, :);
        case 'omegadot'
            arr = u_arr(9:16, :);            
            
        otherwise
            arr = [];
            fprintf('Unrecognized name %s \n', name)
    end
end

