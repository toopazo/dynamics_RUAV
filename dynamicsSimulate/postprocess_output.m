function output_st = postprocess_output(y_arr)

    fprintf('[postprocess_output] y_arr \n');
    disp(y_arr);
    output_st = y_arr;
            
%    % y_arr = transpose(y_arr);
%    fprintf('[postprocess_output] size(y_arr) \n');
%    disp(size(y_arr));
%    
%    y_arr_size = size(y_arr);    
%    output_st.noutputs = y_arr_size(1);
%    output_st.nsamples = y_arr_size(2);
    
    % output_st = postprocess_add_arr_to_st(y_arr, output_st);
        
%    disp('sample 1')
%    y_arr(1).Vrel_bcm
%    y_arr(1).wdot
%    
%    y_st.Vrel_bcm(:, 1)
%    y_st.wdot(:, 1)
%    
%    disp('sample 2')    
%    y_arr(2).Vrel_bcm
%    y_arr(2).wdot
%    
%    y_st.Vrel_bcm(:, 2)
%    y_st.wdot(:, 2)
    
%    % Get fieldnames from first element in array
%    key_arr = fieldnames(y_arr(1))
%    size(key_arr)
%    
%    output_st.y_st = repmat(y_arr(1), 1)
%    
%    for j = 1:size(key_arr, 1)
%        
%    end
%    
%    for i = 1:output_st.nsamples
%        
%    end   
    
%    % y = [Vrel_bcm; frd_wdot_frd_bcm_ned]
%    if output_st.noutputs == 6
%    
%        Vrel_arr = postprocess_output_get_arr(y_arr, 'Vrel');
%        fprintf('[postprocess_output] size(Vrel_arr) \n');
%        disp(size(Vrel_arr));   
%        
%        wdot_arr = postprocess_output_get_arr(y_arr, 'wdot');
%        fprintf('[postprocess_output] size(wdot_arr) \n');
%        disp(size(wdot_arr));

%        output_st.Vrel_arr = Vrel_arr;
%        output_st.wdot_arr = wdot_arr;
%    end    
end    

