function [fig1, fig2] = plot_output_yForMom(sim_st) 
    fpath = sim_st.fpath;
    time_arr = sim_st.time_arr;   

    yForMom         = sim_st.output_st.yForMom;
    Frotor_frd_bcm  = yForMom.Frotor_frd_bcm;
    Mrotor_frd_bcm  = yForMom.Mrotor_frd_bcm;
    Fgrav_frd_bcm   = yForMom.Fgrav_frd_bcm;
    Mgrav_frd_bcm   = yForMom.Mgrav_frd_bcm;
    Faero_frd_bcm   = yForMom.Faero_frd_bcm;
    Maero_frd_bcm   = yForMom.Maero_frd_bcm;
    Fnet_frd_bcm    = yForMom.Fnet_frd_bcm;
    Mnet_frd_bcm    = yForMom.Mnet_frd_bcm;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig1 = figure;
    % suptitle('Control Allocation (Mixer)');     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 1);
    hold on;
            
    plot(time_arr, Frotor_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Frotor_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Frotor_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Frotor N');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 2);
    hold on;

    plot(time_arr, Faero_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Faero_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Faero_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Faero N');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 3);
    hold on;

    plot(time_arr, Fgrav_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Fgrav_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Fgrav_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Fgrav N');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 4);
    hold on;

    plot(time_arr, Fnet_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Fnet_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Fnet_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Fnet N');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    set(fig1, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yForMom_1'];
    fprintf('[plot_output_yForMom] filename %s \n', filename);
    print(fig1, [filename '.jpeg'], '-djpeg');
    savefig(fig1, filename);       
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    fig2 = figure;
    % suptitle('Control Allocation (Mixer)');     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 1);
    hold on;
            
    plot(time_arr, Mrotor_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Mrotor_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Mrotor_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Mrotor Nm');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 2);
    hold on;

    plot(time_arr, Maero_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Maero_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Maero_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Maero Nm');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 3);
    hold on;

    plot(time_arr, Mgrav_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Mgrav_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Mgrav_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Mgrav Nm');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(4, 1, 4);
    hold on;

    plot(time_arr, Mnet_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
    plot(time_arr, Mnet_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
    plot(time_arr, Mnet_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

    grid on;
    % title('Angular velocity of rotors (relative to the body)');
    xlabel('Time s');
    ylabel('Mnet Nm');
    cellarr = {'front', 'right', 'down'};
    legend(cellarr, 'Location', 'eastoutside');  % best
    hold off;
    
%    %%%%%%%%%%%%%%%%%%%%%%%%%
%    subplot(4, 1, 5);
%    hold on;

%    plot(time_arr, Mgyro_frd_bcm(1, :), '-r', 'LineWidth', 2); hold on;
%    plot(time_arr, Mgyro_frd_bcm(2, :), '-g', 'LineWidth', 2); hold on;
%    plot(time_arr, Mgyro_frd_bcm(3, :), '-b', 'LineWidth', 2); hold on;

%    grid on;
%    % title('Angular velocity of rotors (relative to the body)');
%    xlabel('Time s');
%    ylabel('Mgyro Nm');
%    legend('show', 'Location', 'eastoutside', ...
%        'Mgyro\_f', 'Mgyro\_r', 'Mgyro\_d' ...
%        );  % best
%    hold off;              
    
    set(fig2, 'Position', get(0, 'Screensize'));
    filename = [fpath 'plot_output_yForMom_2'];
    fprintf('[plot_output_yForMom] filename %s \n', filename);
    print(fig2, [filename '.jpeg'], '-djpeg');
    savefig(fig2, filename);   
                   
end
