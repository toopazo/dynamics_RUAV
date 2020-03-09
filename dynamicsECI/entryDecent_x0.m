function [x0] = entryDecent_x0()    

    rx_ned = 0;
    rz_ned = 6371*1000 + 400*1000;
    % 26000 Kilometers Per Hour = 7222.228 Meters Per Second 
    vx_ned = 7222;
    vz_ned = 0;
    T      = 283.15; % 273.15 K = 0 Celius
    
    x0 = [...
        rx_ned  ; ...
        rz_ned  ; ...
        vx_ned  ; ...
        vz_ned  ; ...
        T         ...
    ];  
end






