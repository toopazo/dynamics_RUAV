function input_st = postprocess_input(u_arr)

    % u_arr = transpose(u_arr);
    fprintf('[postprocess_input] size(u_arr) \n');
    disp(size(u_arr));
    
    u_arr_size = size(u_arr);    
    input_st.ninputs = u_arr_size(1);
    input_st.nsamples = u_arr_size(2);
    
    % u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
    if input_st.ninputs == 9
    
        Fnet_arr = postprocess_input_get_arr(u_arr, 'Fnet');
        fprintf('[postprocess_input] size(Fnet_arr) \n');
        disp(size(Fnet_arr));   
        
        Mnet_arr = postprocess_input_get_arr(u_arr, 'Mnet');
        fprintf('[postprocess_input] size(Mnet_arr) \n');
        disp(size(Mnet_arr));

        Mrot_arr = postprocess_input_get_arr(u_arr, 'Mrot');
        fprintf('[postprocess_input] size(Mrot_arr) \n');
        disp(size(Mrot_arr));

        input_st.Fnet_arr = Fnet_arr;
        input_st.Mnet_arr = Mnet_arr;
        input_st.Mrot_arr = Mrot_arr;
    end
    
    % u = [Vcmd; yawcmd];
    if input_st.ninputs == 4  

        Vcmd_arr = postprocess_input_get_arr(u_arr, 'Vcmd');
        fprintf('[postprocess_input] size(Vcmd_arr) \n');
        disp(size(Vcmd_arr));
        
        yawcmd_arr = postprocess_input_get_arr(u_arr, 'yawcmd');
        fprintf('[postprocess_input] size(yawcmd_arr) \n');
        disp(size(yawcmd_arr));        

        input_st.Vcmd_arr = Vcmd_arr;  
        input_st.yawcmd_arr = yawcmd_arr;  
    end     
 
%    % u = [Tarm];
%    if input_st.ninputs == 4     

%        Tarm_arr = postprocess_input_get_arr(u_arr, 'Tarm');
%        fprintf('[postprocess_input] size(Tarm_arr) \n');
%        disp(size(Tarm_arr));

%        input_st.Tarm_arr = Tarm_arr;  
%    end  
    
%    % u = [omega; omegadot];
%    if input_st.ninputs == 16
%    
%        omega_arr = postprocess_input_get_arr(u_arr, 'omega');
%        fprintf('[postprocess_input] size(omega_arr) \n');
%        disp(size(omega_arr));   
%        
%        omegadot_arr = postprocess_input_get_arr(u_arr, 'omegadot');
%        fprintf('[postprocess_input] size(omegadot_arr) \n');
%        disp(size(omegadot_arr));

%        input_st.omega_arr = omega_arr;
%        input_st.omegadot_arr = omegadot_arr;
%    end          
        
end

