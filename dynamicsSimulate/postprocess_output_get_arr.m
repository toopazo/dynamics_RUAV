function arr = postprocess_output_get_arr(y_arr, name)

    nsize = size(y_arr);
    noutputs = nsize(1);
    nsamples = nsize(2);
    
    switch name
        % y = [Vrel_bcm; frd_wdot_frd_bcm_ned]
        case 'Vrel'
            arr = y_arr(1:3, :);
        case 'wdot'
            arr = y_arr(4:6, :);
        otherwise
            arr = [];
            fprintf('Unrecognized name %s \n', name)
    end
end

