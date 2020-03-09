function ext_st = postprocess_add_arr_to_st(y_arr, ext_st)
    y_arr_size = size(y_arr);    
    noutputs = y_arr_size(1);
    nsamples = y_arr_size(2);       
        
    % Get fieldnames from first element in array and assume they never change
    y_st = repmat(y_arr(1), 1)  
    
    % Get fieldnames from first element in array and assume they never change
    key_arr = fieldnames(y_arr(1));
    nkey    = size(key_arr, 1);
    
    % Start from second sample, since y_st already contains the first one
    for j = 2:nsamples
        for i = 1:nkey
            key = string( key_arr(i) );
            val = getfield(y_arr(j), key);
            
            y_st_val = getfield(y_st, key);
            new_val = [y_st_val val];
            y_st = setfield(y_st, key, new_val);
        
%            if j <= 2
%                disp('postprocess_arr_to_st')
%                key
%                val
%            end
        end
    end    
    
    % Add struct elements into ext_st
    key_arr = fieldnames(y_st);    
    nkey    = size(key_arr, 1);
    for i = 1:nkey
        key = string( key_arr(i) );
        val = getfield(y_st, key);
        
        ext_st = setfield(ext_st, key, val);
    end
    
    % Check for sub struct
    disp('Check for sub struct')
    key_arr = fieldnames(y_st)
    nkey    = size(key_arr, 1);
    for i = 1:nkey
        key = string( key_arr(i) );
        val = getfield(y_st, key);
        
        if isstruct(val)
            disp('isstruct')
            
            % For each field, convert to struct
            sy_st = val;
            skey_arr = fieldnames(sy_st)
            nskey    = size(skey_arr, 1);
            
            for i = 1:nskey
                skey = string( skey_arr(i) );
                sval = getfield(sy_st, skey);

                % sy_st = postprocess_add_arr_to_st(y_arr, sy_st);                 
            end
        end
    end
    
end
