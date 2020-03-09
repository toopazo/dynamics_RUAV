function st = plot_trajectory(time_arr)
    % ECI to ECEF
    x_arr(1:3, :) = R_ecef_eci*x_arr(1:3, :);
    
    plot_earthSphere(50,'m')
    hold on;
    plot3(x_arr(1, 1), x_arr(2, 1), x_arr(3, 1),'blue','MarkerSize', 6, 'Marker', '*')
    plot3(x_arr(1, :), x_arr(2, :), x_arr(3, :),'red','LineWidth',3)
    grid on;
    title('ECEF coord system, all units in SI [kg, m, s]')
    xlabel('x-axis (0° lon => Greenwich, UK)')
    ylabel('y-axis (90°E lon => Dhaka, Bangladesh)')
    zlabel('z-axis (North Pole)')
end

