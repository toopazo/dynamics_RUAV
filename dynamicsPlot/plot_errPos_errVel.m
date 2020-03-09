function fig = plot_errPos_errVel(...
    time_arr, cmd_pos_arr, pos_arr, cmd_vel_arr, vel_arr)

    %Plot init
    fig = figure;
    % suptitle('errPos errVel');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2, 1, 1);
    hold on;
    
    % cmd_pos_arr
    plot(time_arr, cmd_pos_arr(1,:), '--r', 'LineWidth', 2);
    plot(time_arr, cmd_pos_arr(2,:), '--g', 'LineWidth', 2);
    plot(time_arr, cmd_pos_arr(3,:), '--b', 'LineWidth', 2);
    
    % pos_arr
    plot(time_arr, pos_arr(1,:), 'red', 'LineWidth', 2);
    plot(time_arr, pos_arr(2,:), 'green', 'LineWidth', 2);
    plot(time_arr, pos_arr(3,:), 'blue', 'LineWidth', 2);
    
%     pos_arr = zeros(3,size(x_arr,2));
%     for i = 1:size(x_arr,2)
%         q_frd_tp = [x_arr(4,i); x_arr(5,i); x_arr(6,i); x_arr(7,i)];
%         pos_arr(:,i) = gnrl_quat2angles(q_frd_tp);
%     end
%     plot(pos_arr(1,:),'LineWidth', 2);
%     plot(pos_arr(2,:),'LineWidth', 2);
%     plot(pos_arr(3,:),'LineWidth', 2);
    
    grid on;
    title('pos and cmd\_pos vs time');
    %xlabel('Time s');
    ylabel('Position m');
    cellarr = {...
        'cmd\_pos\_n'   , 'cmd\_pos\_e' , 'cmd\_pos\_d' , ...
        'pos\_n'        , 'pos\_e'      , 'pos\_d'        ...
        };
    legend(cellarr, 'Location', 'eastoutside');           
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    subplot(2, 1, 2);
    hold on;   
    
    % cmd_vel_arr
    plot(time_arr, cmd_vel_arr(1,:), '--r', 'LineWidth', 2);
    plot(time_arr, cmd_vel_arr(2,:), '--g', 'LineWidth', 2);
    plot(time_arr, cmd_vel_arr(3,:), '--b', 'LineWidth', 2);
    
    % vel_arr
    plot(time_arr, vel_arr(1,:), 'red', 'LineWidth', 2);
    plot(time_arr, vel_arr(2,:), 'green', 'LineWidth', 2);
    plot(time_arr, vel_arr(3,:), 'blue', 'LineWidth', 2);
    
%     vel_arr = zeros(3,size(x_arr,2));
%     for i = 1:size(x_arr,2)
%         q_frd_tp = [x_arr(4,i); x_arr(5,i); x_arr(6,i); x_arr(7,i)];
%         vel_arr(:,i) = gnrl_quat2angles(q_frd_tp);
%     end
%     plot(vel_arr(1,:),'LineWidth', 2);
%     plot(vel_arr(2,:),'LineWidth', 2);
%     plot(vel_arr(3,:),'LineWidth', 2);
    
    grid on;
    title('vel and cmd\_vel vs time');
    xlabel('Time s');
    ylabel('Velocity m/s');
    cellarr = {...
        'cmd\_vel\_n'   , 'cmd\_vel\_e' , 'cmd\_vel\_d' , ...
        'vel\_n'        , 'vel\_e'      , 'vel\_d'        ...
        };
    legend(cellarr, 'Location', 'eastoutside');   
    hold off;
    
end
