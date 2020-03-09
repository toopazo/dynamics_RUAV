function G_ecef = model_Gravitation(r_ecef)
% function G_ecef = model_Fgrav(lat, lon, alt)

    % Convert geodetic coordinates to Earth-centered Earth-fixed (ECEF) coordinates
    % r_ecef = lla2ecef([lat, lon, alt])
    % geodetic coordinates (latitude, longitude and altitude), lla, to ECEF coordinates, p.
    % lla is in [degrees degrees meters]. 
    % p is in meters.
       
    r = norm(r_ecef);           % m
    sin_psi = r_ecef(3)/r;      % 1
    
    a = 6378137.0;              % m
    b = 6356752.0;              % m
    excen =  0.08181919;        % 1 
    GM = 3986004.418 * 10^8;    % m^3 / s^2
    J2 = 1.0826267*10^-3;       % 1
    we = 7.2921150 * 10^-5;     % rad / s
    
    G_ecef = (-GM/r^2)*[...                  
        ( 1 + ( 1.5*J2*(a/r)^2 )*( 1 - 5*sin_psi^2 ) )*r_ecef(1)/r ; ...
        ( 1 + ( 1.5*J2*(a/r)^2 )*( 1 - 5*sin_psi^2 ) )*r_ecef(2)/r ; ...
        ( 1 + ( 1.5*J2*(a/r)^2 )*( 3 - 5*sin_psi^2 ) )*r_ecef(3)/r   ...
    ];
    
    return
        
    % Equator
    a = 6378137.0;              % m    
    r_ecef = [a; 0; 0];
    G_ecef = model_Gravitation(r_ecef);
    w_ecef_earth_eci = [0; 0; we];        
    g = G_ecef - cross(w_ecef_earth_eci, cross(w_ecef_earth_eci, r_ecef) )
    
    % Poles
    b = 6356752.0;              % m    
    r_ecef = [0; 0; b];
    G_ecef = model_Gravitation(r_ecef);
    w_ecef_earth_eci = [0; 0; we];        
    g = G_ecef - cross(w_ecef_earth_eci, cross(w_ecef_earth_eci, r_ecef) )
end






