function fig = plot_errRPY_errPQR(...
    time_arr, cmd_RPY_arr, RPY_arr, cmd_PQR_arr, PQR_arr)

    %Plot init
    fig = figure;
    % suptitle('errRPY errPQR');
    
    subplot(2, 1, 1);
    hold on;
    
    % cmd_RPY_arr
    plot(time_arr, cmd_RPY_arr(1,:).*180/pi, '--r', 'LineWidth', 2);
    plot(time_arr, cmd_RPY_arr(2,:).*180/pi, '--g', 'LineWidth', 2);
    plot(time_arr, cmd_RPY_arr(3,:).*180/pi, '--b', 'LineWidth', 2);
    
    % RPY_arr
    plot(time_arr, RPY_arr(1,:).*180/pi, 'red', 'LineWidth', 2);
    plot(time_arr, RPY_arr(2,:).*180/pi, 'green', 'LineWidth', 2);
    plot(time_arr, RPY_arr(3,:).*180/pi, 'blue', 'LineWidth', 2);
    
%     RPY_arr = zeros(3,size(x_arr,2));
%     for i = 1:size(x_arr,2)
%         q_frd_tp = [x_arr(4,i); x_arr(5,i); x_arr(6,i); x_arr(7,i)];
%         RPY_arr(:,i) = gnrl_quat2angles(q_frd_tp);
%     end
%     plot(RPY_arr(1,:), 'LineWidth', 2);
%     plot(RPY_arr(2,:), 'LineWidth', 2);
%     plot(RPY_arr(3,:), 'LineWidth', 2);
    
    grid on;
    title('RPY and cmd\_RPY vs time');
    %xlabel('Time s');
    ylabel('RPY angles deg');
    cellarr = {...
        'cmd\_roll' , 'cmd\_pitch'  , 'cmd\_yaw'    , ...
        'roll'      , 'pitch'       , 'yaw'           ...  
        };
    legend(cellarr, 'Location', 'eastoutside');          
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot init
    % fig = figure;   
    subplot(2, 1, 2);
    hold on;
    
    % cmd_PQR_arr
    plot(time_arr, cmd_PQR_arr(1,:).*180/pi, '--r', 'LineWidth', 2);
    plot(time_arr, cmd_PQR_arr(2,:).*180/pi, '--g', 'LineWidth', 2);
    plot(time_arr, cmd_PQR_arr(3,:).*180/pi, '--b', 'LineWidth', 2);
    
    % PQR_arr
    plot(time_arr, PQR_arr(1,:).*180/pi, 'red', 'LineWidth', 2);
    plot(time_arr, PQR_arr(2,:).*180/pi, 'green', 'LineWidth', 2);
    plot(time_arr, PQR_arr(3,:).*180/pi, 'blue', 'LineWidth', 2);
    
%     Phi_arr = zeros(3,size(x_arr,2));
%     for i = 1:size(x_arr,2)
%         q_frd_tp = [x_arr(4,i); x_arr(5,i); x_arr(6,i); x_arr(7,i)];
%         Phi_arr(:,i) = gnrl_quat2angles(q_frd_tp);
%     end
%     plot(Phi_arr(1,:), 'LineWidth', 2);
%     plot(Phi_arr(2,:), 'LineWidth', 2);
%     plot(Phi_arr(3,:), 'LineWidth', 2);
    
    grid on;
    title('PQR and cmd\_PQR vs time');
    xlabel('Time s');
    ylabel('PQR ang rate deg/s');
    cellarr = {...
        'cmd\_P'    , 'cmd\_Q'  , 'cmd\_R'  , ...
        'P'         , 'Q'       , 'R'         ... 
        };
    legend(cellarr, 'Location', 'eastoutside');                  
    hold off;
    
    % saveas(fig, 'flatEarth_plot_errPQR_evol.jpg');
end
