function R_ecef_eci = math_R_ecef_eci(t)    
   
%    seconds = mod(t, 60);
%    minutes = floor(t/60);
%    hours = floor(minutes/60);
%    % return
%    % timestamp = [2019 8 30 hours minutes seconds];
%    timestamp = [2000 1 1 hours minutes seconds];
%    dtime = datetime([2000 1 1 0 0 0])
%    dnum = dtime + second(1)
%    % timestamp = datevec( datetime(dnum/(60*60*24),'ConvertFrom','datenum'))
%    % timestamp = datevec( datetime(dnum/(60*60*24),'ConvertFrom','datenum'))
    
    basedt = datetime(2000, 1, 1, 0, 0, 0);
    timestamp = datevec( basedt  + t/(60*60*24));
    % timestamp = [2000 1 1 0 0 0];
    % Convert Earth-centered inertial (ECI) to Earth-centered Earth-fixed (ECEF) coordinates    
    % position direction cosine matrix (ECI to ECEF)         
    dcm = dcmeci2ecef('IAU-2000/2006', timestamp);
%    dcm =
%       -0.9316   -0.3635    0.0017
%        0.3635   -0.9316   -0.0007
%        0.0019   -0.0000    1.0000
    R_ecef_eci = dcm;

end
