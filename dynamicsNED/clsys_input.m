function [u] = clsys_input(t, vehicle_st, medium_st)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Input vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rpm2rads = (2*pi) / 60;
    rads2rpm = 60 / (2*pi);        
    
    % Linear Velocity of the CM (frd origin) wrt ned, expressed in ned coord
    vcmd_ned    = [3; 0; 0];            % 3 x 1
    yawcmd      = deg2rad(0);           % 1 x 1
    
    
    u = [vcmd_ned; yawcmd];
end
