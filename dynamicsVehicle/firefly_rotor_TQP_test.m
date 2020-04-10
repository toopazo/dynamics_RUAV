function firefly_rotor_TQP_test()

    rpm2rads = (2*pi) / 60;
    rads2rpm = 60 / (2*pi); 

    omega   = 4000 * rpm2rads;    % RPM to rad/s
    Vrel    = [0; deg2rad(0); deg2rad(0)];
    
    nrotors = 8;
    Trotor = zeros(nrotors, 1);
    Qrotor = zeros(nrotors, 1);
    Protor = zeros(nrotors, 1);
    for roti = 1:nrotors
        % omega = delta(i);  
        % Vrel = Vrel_ricm(:, i);
        signi = firefly_rotor_spin_direction(roti);
        
        [...
            T  , ... % rotor thrust  
            Q  , ... % rotor torque (due to drag)
            P    ... % rotor power
        ] = firefly_rotor_TQP_model(...
            omega   , ... % AngVel of frdi wrt frd, expressed in frdi coord
            Vrel      ... % Relative [Va, aoa, ssa] of the rotor wrt the wind
        );
        Trotor(roti) = T;
        Qrotor(roti) = -1 * signi * Q; % Qrotor = Qaero oposses the spin direction
        Protor(roti) = P;
    end  
    Qrotor
    sum(Qrotor)      

    fprintf('Va %.4f, aoa %.4f, ssa %.4f  \n', ...
        Vrel(1), rad2deg(Vrel(2)), rad2deg(Vrel(3)));
        
    v = 1;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 6;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 2;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 5;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 3;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 8;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 4;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));
    v = 7;
    fprintf('    rot%d: T %.4f, Q %.4f, P %.4f  \n', ...
        v, Trotor(v), Qrotor(v), Trotor(v));                
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Test the replacement of interp1 by a quadratic fit
    omega_arr = [0  201.0619  261.7994  339.2920  416.7846  473.3333  550.8259  615.7521];
    
    [T, Q, P] = firefly_rotor_TQP_interp1(omega_arr, NaN);
    interp1_Trotor_arr = T;
    interp1_Qrotor_arr = Q;
    interp1_Protor_arr = P;
    % interp1_Trotor_arr = [0  4.12      7.26      11.57     16.48     22.36     30.11     38.34];

    x = omega_arr;
    y = interp1_Trotor_arr;
    n = 2;
    p = polyfit(x,y,n)   
    
    x = omega_arr;
    y = interp1_Qrotor_arr;
    n = 2;
    p = polyfit(x,y,n)  
    
    x = omega_arr;
    y = interp1_Protor_arr;
    n = 2;
    p = polyfit(x,y,n)      

    [T, Q, P] = firefly_rotor_TQP_model(omega_arr, NaN);
    quadratic_Trotor_arr = T;
    quadratic_Qrotor_arr = Q;
    quadratic_Protor_arr = P;

    fig = figure;
    subplot(3, 1, 1)
    hold on;
    grid on;
    plot(omega_arr, interp1_Trotor_arr, 'r-*');
    plot(omega_arr, quadratic_Trotor_arr, 'b-*');
    xlabel('omega')
    ylabel('Trotor')
    subplot(3, 1, 2)
    hold on;
    grid on;
    plot(omega_arr, interp1_Qrotor_arr, 'r-*');
    plot(omega_arr, quadratic_Qrotor_arr, 'b-*');
    xlabel('omega')
    ylabel('Qrotor')
    subplot(3, 1, 3)
    hold on;
    grid on;
    plot(omega_arr, interp1_Protor_arr, 'r-*');
    plot(omega_arr, quadratic_Protor_arr, 'b-*');
    xlabel('omega')
    ylabel('Protor')
end

