function math_sanitycheck(vector)
    % sanity check
    isnan_arr = isnan(vector);
    for i = 1:length(isnan_arr)
        var = isnan_arr(i);
        if var
            fprintf('math_sanitycheck() NaN detected \n');
            vector
            stop
        end
    end
end

