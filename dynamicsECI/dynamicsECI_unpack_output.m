function [...
    latlonalt   , ...
    g_frd         ...
    ] = dynamicsECI_unpack_output(y)    
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Output vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    latlonalt   = y(1:3, :);    % 3 x 1
    g_frd       = y(1:3, :);    % 1 x 1    
    % y = [latlonalt; g_frd];

end






