function fig = plot_ned_pos_att_arr(pos_arr, RPY_arr, dtime)

    % Plot every xsec only
    % dtime * dindex = xsec
    xsec = 1;
    dindex = round(xsec / dtime);

    fig = figure;
    for i = 1:dindex:size(pos_arr, 2)
        pos = pos_arr(:, i);        
        RPY = RPY_arr(:, i);        
        plot_ned_pos_att(pos, RPY)
        %axis normal
        axis equal;
        
        drawnow;
        %pause(0.01);
    end
end
