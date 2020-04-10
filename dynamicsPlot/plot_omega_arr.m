function [fig] = plot_omega_arr(time_arr, omega_arr) 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig = figure;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on;        
    plot(time_arr, omega_arr(1, :), '-r', 'LineWidth', 2);
    plot(time_arr, omega_arr(6, :), '-.r', 'LineWidth', 2);
    plot(time_arr, omega_arr(2, :), '-g', 'LineWidth', 2);
    plot(time_arr, omega_arr(5, :), '-.g', 'LineWidth', 2);
    plot(time_arr, omega_arr(3, :), '-b', 'LineWidth', 2);
    plot(time_arr, omega_arr(8, :), '-.b', 'LineWidth', 2);
    plot(time_arr, omega_arr(4, :), '-k', 'LineWidth', 2);
    plot(time_arr, omega_arr(7, :), '-.k', 'LineWidth', 2);        

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('omega rad/s');
    cellarr = {'m1', 'm6', 'm2', 'm5', 'm3', 'm8', 'm4', 'm7'};
    legend(cellarr, 'Location', 'eastoutside');  % best    
                   
end
