function [...
    Fnet_frd_bcm    , ...
    Mnet_frd_bcm      ...
    ] = dynamicsECI_unpack_input(u)
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    % Force of rotor cm (local abc) wrt frd, expressed in frd coord   
    Fnet_frd_bcm      = [ u(1:3, :) ];                   % 3 x 1
    Mnet_frd_bcm      = [ u(4:6, :) ];                   % 3 x 1
    
    % u = [Fnet_frd_bcm, Mnet_frd_bcm];

end






