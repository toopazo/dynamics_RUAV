function fig = plot_flight_angles(...
    time_arr        , ...
    RPY_arr         , ...
    q_frd_ned_arr   , ...
    vel_arr           ...
    )

    [...
        pitch_arr       , ...
        aoa_arr         , ...
        fpang_arr         ...
    ] = postprocess_flight_angles(...
        RPY_arr         , ...
        q_frd_ned_arr   , ...
        vel_arr           ...
        );

    deg2rad = pi / 180;
    rad2deg = 180 / pi;    
     
    fig = figure;
    % suptitle('Rotor (motor)');
    %subplot(4, 1, 1);

    hold on;
    plot(time_arr, pitch_arr * rad2deg, 'LineWidth', 2);
    plot(time_arr, aoa_arr * rad2deg, 'LineWidth', 2);
    plot(time_arr, fpang_arr * rad2deg, 'LineWidth', 2);
    % plot(time_arr, ssa_arr * rad2deg, 'LineWidth', 2);

    grid on;
    title('Flight angles');
    % xlabel('Time s');
    ylabel('Angles deg');
    legend('show', ...
        'pitch'             , ...
        'AoA'               , ...
        'flight path angle'   ...
        );
    %         'side slip angle'     ...        
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [...
        pitch_arr       , ...
        aoa_arr         , ...
        fpang_arr         ...
        ] = postprocess_flight_angles(...
            RPY_arr         , ...
            q_frd_ned_arr   , ...
            vel_arr           ...
            )
            
%        deg2rad = pi / 180;
%        rad2deg = 180 / pi;
        
        nsamples = size(RPY_arr, 2);    
        pitch_arr = zeros(1, nsamples);
        aoa_arr = zeros(1, nsamples);
        fpang_arr = zeros(1, nsamples);
        for i=1:nsamples            
            veli_ned = vel_arr(:, i);
            % convert from ned to frd
            q_frd_ned = q_frd_ned_arr(:, i);
            veli_frd = math_quatrotate(q_frd_ned, veli_ned);
            
            Va = norm(veli_frd);
            % pitch = alpha + fpang
            pitchi = RPY_arr(2, i);
            vx = veli_ned(1);
            vz = veli_ned(3);
            fpangi = atan2(-vz, vx);       
            alphai = pitchi - fpangi;
            
    %        pitch_deg = pitchi * rad2deg;
    %        fpang_deg = fpangi * rad2deg;
    %        alpha_deg = alphai * rad2deg;
            
            % save results 
            pitch_arr(:, i) = pitchi;
            aoa_arr(:, i) = alphai;
            fpang_arr(:, i) = fpangi;       
        end
    end    
end


