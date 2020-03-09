function fig = plot_trajectory(time_arr, pos_arr)

    deg2rad = pi / 180;
    rad2deg = 180 / pi;
    rpm2rads = (2*pi) / 60;
    rads2rpm = 60 / (2*pi);
    
    % Default settings
    lineColor = '[0.7 0.7 0.7]';
    dtime   = time_arr(2) - time_arr(1);
    dtmarks = dtime*3; % 1;   % add a mark every dtmarks s
    addtext = 0;    % append legendstr yes or no
    legendstr = "";
    
    xlabelstr = 'North m';
    ylabelstr = 'East m';
    zlabelstr = 'Down m';

    fig = figure;
    
    % 1) Plot trayectory
    h = plot_vect_ned(...
        pos_arr   , ...
        ... % settings
        dtime       , ...
        dtmarks     , ...
        lineColor   , ...
        legendstr   , ...
        addtext     , ...
        xlabelstr   , ...
        ylabelstr   , ...
        zlabelstr     ...
        );
        
    % 5) Plot settings
    textstr = ['Marks every' num2str(dtmarks) 's'];
    text(50, 0, 5, textstr, ...
    ...% text(0.1, 0, 0.1, textstr, ...
        'FontSize', 10, ...
        'HorizontalAlignment','left', ...
        'BackgroundColor', 'w', ...
        'EdgeColor', 'black');
    % xlim([-100 1500])
    % zlim([-0.2 0.2])
    % xlim([-100 1600])
    % zlim([-100 500])
    
    % view(0, 90)  % XY
    % view(0, 0);   % XZ
    % view(90, 0)  % YZ   
end
