function fig = plot_ned_vel_angvel_arr(quat_arr, vel_arr, angvel_arr)
    fig = figure;
    for i = 1:size(quat_arr, 2)
        
        % x = [r_ned_cm_e; q_frd_ned; v_frd_cm_e; w_frd_b_e];
        
        q_frd_ned = quat_arr(:, i);
        RPY = math_quat2angles(q_frd_ned);
        roll    = RPY(1);
        pitch   = RPY(2);
        yaw     = RPY(3);
        
        frd_vel = vel_arr(:, i);
        
        frd_angvel = angvel_arr(:, i);
        
        %%%%%%%%%%%%%%%%%%%%%
        
        % Euler Angles and Rotation matrix for NED coord frame
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
        ned_ned_orig = [0; 0; 0];
        plot_ned_vect(ned_ned_orig, ned_n, ...
            'red', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
        plot_ned_vect(ned_ned_orig, ned_e, ...
            'green', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
        plot_ned_vect(ned_ned_orig, ned_d, ...
            'blue', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
        hold on;

        %Plot frd_vel in NED coord frame
        ned_vel = R_ned_frd*frd_vel;
        ned_angvel = R_ned_frd*frd_angvel;
        plot_ned_vect(ned_ned_orig, ned_vel, ...
            'cyan', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
        plot_ned_vect(ned_ned_orig, ned_angvel, ...
            'magenta', 'ShowArrowHead', 'on', 'AutoScale', 'off', 'LineWidth', 2)
        hold on;

        % plot_ned_vector_settings()
        xlabel('x-axis (North)');
        ylabel('y-axis (West)');
        zlabel('z-axis (Up)');
        %view(0, 0, -30)            
        title('NED and FRD coord frames: vel (cyan) + angvel (magenta)');
        grid on;
        axis equal;
        %set(gca,'YDir','reverse');
        %set(gca,'XDir','reverse');
        % xlim([-1.1 1.1]);
        % ylim([-1.1 1.1]);
        % zlim([-1.1 1.1]);

        %%%%%%%%%%%%%%%%%%%%%

            drawnow;
            %pause(0.01);
    end
end
