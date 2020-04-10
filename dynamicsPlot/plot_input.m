function fig = plot_input(sim_st)

    fpath = sim_st.fpath;
    
    % Unpack input
    ninputs = sim_st.input_st.ninputs;
    
    % u = [Fnet_frd_bcm; Mnet_frd_bcm; Mrot_frd_bcm];
    if ninputs == 9    
        plot_input_9(sim_st, fpath);
        return
    end         

    % u = [Vcmd; yawcmd];
    if ninputs == 4    
        plot_input_4(sim_st, fpath);
        return
    end
    
%    % u = [Trotor];
%    if ninputs == 4     
%        plot_input_4(sim_st, fpath);
%        return
%    end   
    
%    % u = [omega; omegadot];
%    if ninputs == 16    
%        plot_input_16(sim_st, fpath);
%    end   
    
    fprintf('[plot_input] ninputs %d does not match any known value\n', ninputs);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function plot_input_9(sim_st, fpath)
        time_arr = sim_st.time_arr;
        
        % Unpack input
        Fnet_arr = sim_st.input_st.Fnet_arr;
        Mnet_arr = sim_st.input_st.Mnet_arr;
        Mrot_arr = sim_st.input_st.Mrot_arr;
           
        fig = figure;
                
        ls = 'LineStyle';   lsa = '-';
        mk = 'Marker';      mka = 'none';    
        lw = 'LineWidth';
        cl = 'Color';
        gcl = [0.5 0.5 0.5];
        
        subplot(3, 1, 1)
        hold on;
        grid on;                
        plot(time_arr, Fnet_arr(1,:), '-r', 'LineWidth', 2);
        plot(time_arr, Fnet_arr(2,:), '-g', 'LineWidth', 2);
        plot(time_arr, Fnet_arr(3,:), '-b', 'LineWidth', 2);        
        title('Net force acting on the vehicle');
        xlabel('Time s');
        ylabel('Force N');
        legend('show', 'front', 'right', 'down');

        subplot(3, 1, 2)
        hold on;
        grid on;                
        plot(time_arr, Mnet_arr(1,:), '-r', 'LineWidth', 2);
        plot(time_arr, Mnet_arr(2,:), '-g', 'LineWidth', 2);
        plot(time_arr, Mnet_arr(3,:), '-b', 'LineWidth', 2);        
        title('Net moment acting on the vehicle');
        xlabel('Time s');
        ylabel('Moment Nm');
        legend('show', 'front', 'right', 'down');
        
        subplot(3, 1, 3)
        hold on;
        grid on;                
        plot(time_arr, Mrot_arr(1,:), '-r', 'LineWidth', 2);
        plot(time_arr, Mrot_arr(2,:), '-g', 'LineWidth', 2);
        plot(time_arr, Mrot_arr(3,:), '-b', 'LineWidth', 2);        
        title('Rotor moment acting on the vehicle (Mrot)');
        xlabel('Time s');
        ylabel('Moment Nm');
        legend('show', 'front', 'right', 'down');        
        
        set(fig, 'Position', get(0, 'Screensize'));
        filename = [fpath 'plot_input'];
        fprintf('[plot_input] filename %s \n', filename);
        print(fig, [filename '.jpeg'], '-djpeg');
        savefig(fig, filename);   
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function plot_input_4(sim_st, fpath)
        time_arr = sim_st.time_arr;
        
        % Unpack input
        Vcmd_arr = sim_st.input_st.Vcmd_arr;
        yawcmd_arr = sim_st.input_st.yawcmd_arr;
           
        fig = figure;

        ls = 'LineStyle';   lsa = '-';
        mk = 'Marker';      mka = 'none';    
        lw = 'LineWidth';
        cl = 'Color';
        gcl = [0.5 0.5 0.5];
        hold on;


        plot(time_arr, Vcmd_arr(1,:), '-r', 'LineWidth', 2); hold on;
        plot(time_arr, Vcmd_arr(2,:), '-g', 'LineWidth', 2); hold on;
        plot(time_arr, Vcmd_arr(3,:), '-b', 'LineWidth', 2); hold on;
        plot(time_arr, yawcmd_arr(1,:), '-k', 'LineWidth', 2); hold on;

        grid on;
        % title('Angular velocity of rotors (relative to the body)');
        xlabel('Time s');
        ylabel('Cmd velocity m/s and yaw deg'); % ylim([230 240])
        legend('show', 'north', 'east', 'down', 'yaw');    % north best

        set(fig, 'Position', get(0, 'Screensize'));
        filename = [fpath 'plot_input'];
        fprintf('[plot_input] filename %s \n', filename);
        print(fig, [filename '.jpeg'], '-djpeg');        
        savefig(fig, filename);   
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    function plot_input_4(sim_st, fpath)
%        time_arr = sim_st.time_arr;
%        % Unpack input
%        Tarm_arr = sim_st.input_st.Tarm_arr;
%           
%        fig = figure;

%        ls = 'LineStyle';   lsa = '-';
%        mk = 'Marker';      mka = 'none';    
%        lw = 'LineWidth';
%        cl = 'Color';
%        gcl = [0.5 0.5 0.5];
%        hold on;

%        ntraces = 1;
%        leg = strings(ntraces*ninputs, 1);
%        for i = 1:ninputs
%            l = ntraces*(i - 1) + 1;

%            plot(time_arr, Tarm_arr(i, :), ls, lsa, mk, mka, lw, 2);
%            % leg(i) = ['wreldot\_' num2str(i)];
%            leg(i) = ['Tarm\_' num2str(i)];
%        end

%        grid on;
%        % title('Angular velocity of rotors (relative to the body)');
%        xlabel('Time s');
%        ylabel('Thrust N'); % ylim([230 240])
%        legend('show', 'Location', 'eastoutside', leg);    % north best
%        hold off;

%        set(fig, 'Position', get(0, 'Screensize'));
%        filename = [fpath 'plot_input'];
%        fprintf('[plot_input] filename %s \n', filename);
%        print(fig, [filename '.jpeg'], '-djpeg');        
%        savefig(fig, filename);   
%        
%    end
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    function plot_input_16(sim_st, fpath)
%        time_arr = sim_st.time_arr;
%        % Unpack input
%        omega_arr = sim_st.input_st.omega_arr;
%        omegadot_arr = sim_st.input_st.omegadot_arr;
%           
%        fig = figure;
%                
%        ls = 'LineStyle';   lsa = '-';
%        mk = 'Marker';      mka = 'none';    
%        lw = 'LineWidth';
%        cl = 'Color';
%        gcl = [0.5 0.5 0.5];
%        
%        subplot(2, 1, 1)
%%        hold on;
%%        plot(time_arr, omega_arr(1, :), ls, lsa, mk, mka, cl, 'r', lw, 2);
%%        plot(time_arr, omega_arr(2, :), ls, lsa, mk, mka, cl, 'g', lw, 2);
%%        plot(time_arr, omega_arr(3, :), ls, lsa, mk, mka, cl, 'b', lw, 2);
%%        plot(time_arr, omega_arr(4, :), ls, lsa, mk, mka, cl, 'k', lw, 2);
%%        plot(time_arr, omega_arr(5, :), ls, lsa, mk, mka, cl, 'c', lw, 2);
%%        plot(time_arr, omega_arr(6, :), ls, lsa, mk, mka, cl, 'm', lw, 2);
%%        plot(time_arr, omega_arr(7, :), ls, lsa, mk, mka, cl, 'y', lw, 2);
%%        plot(time_arr, omega_arr(8, :), ls, lsa, mk, mka, cl, gcl, lw, 2);
%%        grid on;        
%        plot(time_arr, omega_arr(1,:), '-r', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(2,:), '-g', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(3,:), '-b', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(4,:), '-k', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(5,:), '--g', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(6,:), '--r', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(7,:), '--k', 'LineWidth', 2); hold on;
%        plot(time_arr, omega_arr(8,:), '--b', 'LineWidth', 2); hold on;  
%        omeganet_arr = ...
%            omega_arr(1, :) + omega_arr(2, :) + ...
%            omega_arr(3, :) + omega_arr(4, :) + ...
%            omega_arr(5, :) + omega_arr(6, :) + ...
%            omega_arr(7, :) + omega_arr(8, :) ;
%        plot(time_arr, omeganet_arr(1, :), '-.k', 'LineWidth', 2); hold on;
%        grid on;           
%        
%        title('Angular velocity of rotors (relative to the body)');
%        xlabel('Time s');
%        ylabel('AngVel rad/s');
%        legend('show', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8', 'net');

%        
%        subplot(2, 1, 2)
%%        hold on;
%%        plot(time_arr, omegadot_arr(1, :), ls, lsa, mk, mka, cl, 'r', lw, 2);
%%        plot(time_arr, omegadot_arr(2, :), ls, lsa, mk, mka, cl, 'g', lw, 2);
%%        plot(time_arr, omegadot_arr(3, :), ls, lsa, mk, mka, cl, 'b', lw, 2);
%%        plot(time_arr, omegadot_arr(4, :), ls, lsa, mk, mka, cl, 'k', lw, 2);
%%        plot(time_arr, omegadot_arr(5, :), ls, lsa, mk, mka, cl, 'c', lw, 2);
%%        plot(time_arr, omegadot_arr(6, :), ls, lsa, mk, mka, cl, 'm', lw, 2);
%%        plot(time_arr, omegadot_arr(7, :), ls, lsa, mk, mka, cl, 'y', lw, 2);
%%        plot(time_arr, omegadot_arr(8, :), ls, lsa, mk, mka, cl, gcl, lw, 2);
%%        grid on;
%        plot(time_arr, omegadot_arr(1,:), '-r', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(2,:), '-g', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(3,:), '-b', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(4,:), '-k', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(5,:), '--g', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(6,:), '--r', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(7,:), '--k', 'LineWidth', 2); hold on;
%        plot(time_arr, omegadot_arr(8,:), '--b', 'LineWidth', 2); hold on;  
%        grid on;
%        title('Angular accel of rotors (relative to the body)');
%        xlabel('Time s');
%        ylabel('AngAccel rad/s2');
%        legend('show', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8');
%        
%        set(fig, 'Position', get(0, 'Screensize'));
%        filename = [fpath 'plot_input'];
%        fprintf('[plot_input] filename %s \n', filename);
%        print(fig, [filename '.jpeg'], '-djpeg');        
%        savefig(fig, filename);   
%    end    
end
