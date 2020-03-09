function fig = plot_vehicle_st(vehicle_st, fpath)

    %Plot init
    fig = figure;
    h1 = axes;
    hold on;
    
    % Plot frd axis
    v = 0.5;
    xuvect = v * [1; 0; 0];
    yuvect = v * [0; 1; 0];
    zuvect = v * [0; 0; 1];
    plot3([0 xuvect(1)], [0 xuvect(2)], [0 xuvect(3)], '-r', 'LineWidth', 4);   % f-axis
    plot3([0 yuvect(1)], [0 yuvect(2)], [0 yuvect(3)], '-g', 'LineWidth', 4);   % r-axis
    plot3([0 zuvect(1)], [0 zuvect(2)], [0 zuvect(3)], '-b', 'LineWidth', 4);   % d-axis    

    grid on;
    view(40, 35);
    title('vehicle\_st.geometry');
    xlabel('front m');
    ylabel('right m');
    zlabel('down m');
    
    set(h1, 'Ydir', 'reverse')
    % set(h1, 'YAxisLocation', 'Right')
    set(h1, 'Zdir', 'reverse')
    % set(h1, 'ZAxisLocation', 'Down') 
    
%    plot(time_arr, pos_arr(1,:), 'red', 'LineWidth', 2);
%    plot(time_arr, pos_arr(2,:), 'green', 'LineWidth', 2);
%    plot(time_arr, pos_arr(3,:), 'blue', 'LineWidth', 2);   

    nrotors = vehicle_st.geometry.nrotors;
    r_frd_roti_cg = vehicle_st.geometry.r_frd_roti_cg;    
    R_frd_frdi = vehicle_st.geometry.R_frd_frdi;           % Rotation matrix array          
    for i= 1:nrotors
        rot_frd = r_frd_roti_cg(:, i);
        DCM_frd_frdi = R_frd_frdi(:, :, i);
        
        % Plot rotor location
        plot3([0 rot_frd(1)], [0 rot_frd(2)], [0 rot_frd(3)], '-k', 'LineWidth', 2);

        % Plot rotor orientation
        v = 0.1;
        xuvect = rot_frd + DCM_frd_frdi * v * [1; 0; 0];
        yuvect = rot_frd + DCM_frd_frdi * v * [0; 1; 0];
        zuvect = rot_frd + DCM_frd_frdi * v * [0; 0; 1];
        plot3([rot_frd(1) xuvect(1)], [rot_frd(2) xuvect(2)], [rot_frd(3) xuvect(3)], '-r', 'LineWidth', 4);   % f-axis
        plot3([rot_frd(1) yuvect(1)], [rot_frd(2) yuvect(2)], [rot_frd(3) yuvect(3)], '-g', 'LineWidth', 4);   % r-axis
        plot3([rot_frd(1) zuvect(1)], [rot_frd(2) zuvect(2)], [rot_frd(3) zuvect(3)], '-b', 'LineWidth', 4);   % d-axis   
        
        % add label
        txt = ['rot' num2str(i)];
        v = 0.1;
        text(rot_frd(1), rot_frd(2), rot_frd(3) + v, txt)       
        pause(1);
    end        
      
%    legend('show', 'Location', 'eastoutside', ...
%        'cmd\_pos\_n', 'cmd\_pos\_e', 'cmd\_pos\_d' , ...
%        'pos\_n', 'pos\_e', 'pos\_d'                  ...
%        );
    saveas(fig, [fpath 'plot_vehicle_st.jpg']);
end
