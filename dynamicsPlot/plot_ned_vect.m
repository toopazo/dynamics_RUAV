function plot_ned_vect(orig, vect, varargin)

    % disp("Number of input arguments: " + nargin)
    % celldisp(varargin)
    % return
    % rigidBodyDyn_plot_ned_vect([0;0;0], [1;1;1], ...
    % 'red', 'ShowArrowHead', 'off', 'AutoScale', 'off', 'LineWidth', 2)

    % Euler Angles and Rotation matrix for NED coord frame
    roll = 180*pi/180;
    pitch = 00*pi/180;
    yaw = 00*pi/180;
    dcm = angle2dcm(yaw, pitch, roll);
    R_ned_nwu = dcm;
    R_nwu_ned = R_ned_nwu^(-1);

    % rotate from NED to NWU
    orig = R_nwu_ned*orig;
    vect = R_nwu_ned*vect;
    
    %Plot vector vect in NED coord frame
    x = orig(1); y = orig(2); z = orig(3);
    u = vect(1); v = vect(2); w = vect(3);
    quiver3(x, y, z, u, v, w, varargin{:})
    hold on;
end
