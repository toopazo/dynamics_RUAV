function plot_ned_pos_att(pos, RPY)

    % set(gca,'ZDir','reverse');

    % Translation vector
    r_ned_frd_orig = pos;

    % Euler Angles and Rotation matrix for NED coord frame
    roll    = RPY(1);
    pitch   = RPY(2);
    yaw     = RPY(3);
    dcm = angle2dcm(yaw, pitch, roll);
    R_frd_ned = dcm;
    R_ned_frd = R_frd_ned^(-1);

    % Plot a plane along n-e axis
    x = -1:1:1;
    [X,Y] = meshgrid(x);
    % Evaluate and plot the function over the 2-D grid.
    F = X.*0;
    surf(X,Y,F)
    hold on;

    %Plot vectors ned_n, ned_e, ned_d in NED coord frame
    ned_n = [1; 0; 0];
    ned_e = [0; 1; 0];
    ned_d = [0; 0; 1];
    r_ned_orig_orig = [0; 0; 0];
    plot_ned_vect(r_ned_orig_orig, ned_n, ...
        'red', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    plot_ned_vect(r_ned_orig_orig, ned_e, ...
        'green', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    plot_ned_vect(r_ned_orig_orig, ned_d, ...
        'blue', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    hold on;

    %Plot FRD vectors frd_f, frd_r, frd_d in NED coord frame
    frd_f = [1; 0; 0];
    frd_r = [0; 1; 0];
    frd_d = [0; 0; 1];
    ned_frd_f = R_ned_frd*frd_f;
    ned_frd_r = R_ned_frd*frd_r;
    ned_frd_d = R_ned_frd*frd_d;
%    plot_ned_vect(r_ned_orig_orig, r_ned_frd_orig, ...
%        'black', 'ShowArrowHead', 'off', 'AutoScale', 'off', 'LineWidth', 1)
    plot_ned_vect(r_ned_frd_orig, ned_frd_f, ...
        'red', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    plot_ned_vect(r_ned_frd_orig, ned_frd_r, ...
        'green', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    plot_ned_vect(r_ned_frd_orig, ned_frd_d, ...
        'blue', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
    hold on;

    % plot_ned_vector_settings()
    title('NED and FRD coord frames: translation + rotation)');
    grid on;
    axis equal;
    xlabel('x-axis (North)');
    ylabel('y-axis (East)');
    zlabel('z-axis (Up)');
    %view(0, 0, -30)    
    %set(gca,'YDir','reverse');
    %set(gca,'XDir','reverse');
    %set(gca,'ZDir','reverse');
    % xlim([-1.1 1.1]);
    % ylim([-1.1 1.1]);
    % zlim([-1.1 1.1]);

end
