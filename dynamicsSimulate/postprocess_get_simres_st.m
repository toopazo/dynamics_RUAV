function simres_st = postprocess_get_simres_st(...
    time_arr    , ...
    x_arr       , ...
    u_arr       , ...
    cmd_st        ...
    )
    
    % simres_st = postprocess_get_simres_st(time_arr, x_arr, u_arr)
    
    fprintf('[postprocess_get_simres_st] size(time_arr) \n');
    disp(size(time_arr));
    
    % fprintf('[simPx4_pack_st] postprocess_input .. \n');
    input_st = simPx4.postprocess_input(u_arr);
    
    % fprintf('[simPx4_pack_st] postprocess_state .. \n');
    state_st = simPx4.postprocess_state(x_arr);
    
    % fprintf('[simPx4_pack_st] postprocess_output .. \n');
    output_st = simPx4.postprocess_output(time_arr, input_st, state_st);
   
    simres_st.time_arr = time_arr;
    simres_st.input_st = input_st;
    simres_st.state_st = state_st;
    simres_st.output_st = output_st;
    simres_st.body_x0 = x_arr(:, 1);
    simres_st.cmd_st = cmd_st;
    
%    % Save results
%    variable = 'simres_st';
%    filename = [fpath variable '.mat'];
%    save(filename, variable);
%    fprintf('[postprocess_get_simres_st] saving %s as %s \n', variable, filename);
end
