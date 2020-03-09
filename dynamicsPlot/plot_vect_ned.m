function h1 = plot_vect_ned(...
    vect_arr    , ...
    ... % settings
    dtime       , ...
    dtmarks     , ...
    lineColor   , ...
    legendstr   , ...
    addtext     , ...
    xlabelstr   , ...
    ylabelstr   , ...
    zlabelstr     ...
    )
    
    lineStyle = '-';
    marker = 'o';
    lineWidth = 1;
    
    % plot trajectory
    h1 = plot3(vect_arr(1, :), vect_arr(2, :), vect_arr(3, :), ...
        'Color', lineColor, ...
        'LineStyle', lineStyle, ...
        'LineWidth', lineWidth, ...
        'DisplayName', legendstr);
    % legend('-DynamicLegend');
    % legend(h1, legendstr);
    % legend('show', 'Location','southeast')
    
    grid on;
    % title('NED coord frame: Position of CM every 2 s');
    xlabel(xlabelstr);
    ylabel(ylabelstr);
    zlabel(zlabelstr);
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    % set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
    set(gca,'XAxisLocation','top');

    hold on;
    
    % plot marks every x [s]
    num_samples = size(vect_arr, 2);
    marks_arr = get_marks_arr(dtmarks, dtime, num_samples);
        
    for i = marks_arr
        h2 = plot3(vect_arr(1, i), vect_arr(2, i), vect_arr(3, i), ...
            'Color', lineColor, ...
            'LineStyle', lineStyle, ...
            'Marker', marker, ...
            'LineWidth', lineWidth);
    end
    % legend('-DynamicLegend');
    % legend('show');

    % plot text    
    xp_end = vect_arr(1, end); % - 10;
    yp_end = vect_arr(2, end);
    zp_end = vect_arr(3, end) + 0.2; %0.1; % + 40;    
    
    % textstr = sprintf('V_a %.0f \\gamma %.0f', Va, fpang);
    % textstr = ['\leftarrow ' legendstr];
    if addtext == 1
        % textstr = ['\leftarrow ' legendstr];
        textstr = legendstr;
        text(xp_end, yp_end, zp_end, textstr, 'FontSize', 10, ...
            'HorizontalAlignment','left') % , 'BackgroundColor', 'w')
    end
    %legend(h, 'off')
    
    function marks_arr = get_marks_arr(dtmarks, dtime, num_samples)
        num_Xs_samples = dtmarks * (1 / dtime);
        
        % integ = floor(num_Xs_samples);
        % fract = num_Xs_samples - integ;
        % if fract ~= 0
        %     num_Xs_samples = 3;
        % end
        
        marks_arr = 1:num_Xs_samples:num_samples;
        marks_arr = floor(marks_arr);
        % size(marks_arr, 2)
    end
    
end

