function out_st = postprocess_append_to_st(in_st, ref_st)
    % disp('postprocess_append_to_st')

    % Get fieldnames from first element in array and assume they never change
    key_arr = fieldnames(in_st);
    nkey    = size(key_arr, 1);
    
    % in_st
    % ref_st
    
    for i = 1:nkey
        in_key = string( key_arr(i) );
        % in_key = cellstr(in_key)  % matlab2017
        in_key = char(in_key);      % matlab2017
        % class(in_st)
        % class(in_key)
        in_val = getfield(in_st, in_key);

        ref_key = in_key;
        ref_val = getfield(ref_st, ref_key);

        if isstruct(ref_val)
            % disp('isstruct(in_val) true')
            new_val = postprocess_append_to_st(in_val, ref_val);
            ref_st = setfield(ref_st, ref_key, new_val); 
        else        
            % disp('isstruct(in_val) false')
            % Append in_val to ref_val
            new_val = [ref_val in_val];
            ref_st = setfield(ref_st, ref_key, new_val); 
        end
           
%            if j <= 2
%                disp('postprocess_arr_to_st')
%                key
%                val
%            end
    end
    
    out_st = ref_st;
    
end
