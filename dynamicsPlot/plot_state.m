function [fig1, fig2, fig3, fig4] = plot_state(sim_st)   
    
    fpath = sim_st.fpath;
    
    time_arr = sim_st.time_arr;
    
    % Unpack state
    pos_arr         = sim_st.state_st.pos_arr;
    vel_arr         = sim_st.state_st.vel_arr;
    q_frd_ned_arr   = sim_st.state_st.q_frd_ned_arr;
    RPY_arr         = sim_st.state_st.RPY_arr;
    PQR_arr         = sim_st.state_st.PQR_arr;
    omega_arr       = sim_st.state_st.omega_arr;
    
    if isfield(sim_st, 'cmd_st')
        cmd_pos_arr = sim_st.cmd_st.cmd_pos_arr;
        cmd_vel_arr = sim_st.cmd_st.cmd_vel_arr;
        cmd_RPY_arr = sim_st.cmd_st.cmd_RPY_arr;
        cmd_PQR_arr = sim_st.cmd_st.cmd_PQR_arr;
    else
        cmd_pos_arr = zeros(size(pos_arr));
        cmd_vel_arr = zeros(size(vel_arr));
        cmd_RPY_arr = zeros(size(RPY_arr));
        cmd_PQR_arr = zeros(size(PQR_arr)); 
    end   
   
    fig1 = plot_errPos_errVel(...
        time_arr, cmd_pos_arr, pos_arr, cmd_vel_arr, vel_arr);

    set(fig1, 'Position', get(0, 'Screensize'));
    filename1 = [fpath 'plot_state1'];
    fprintf('[plot_state] filename1 %s \n', filename1);
    print(fig1, [filename1 '.jpeg'], '-djpeg');
    savefig(fig1, filename1);  

    fig2 = plot_errRPY_errPQR(...
        time_arr, cmd_RPY_arr, RPY_arr, cmd_PQR_arr, PQR_arr);
        
    set(fig2, 'Position', get(0, 'Screensize'));
    filename2 = [fpath 'plot_state2'];
    fprintf('[plot_state] filename2 %s \n', filename2);
    print(fig2, [filename2 '.jpeg'], '-djpeg');
    savefig(fig2, filename2);  
    
    fig3 = plot_omega_arr(time_arr, omega_arr);

    set(fig3, 'Position', get(0, 'Screensize'));
    filename3 = [fpath 'plot_state3'];
    fprintf('[plot_state] filename3 %s \n', filename3);
    print(fig3, [filename3 '.jpeg'], '-djpeg');
    savefig(fig3, filename3);      
    
    fig3 = 0;
%    dtime = time_arr(2) - time_arr(1);
%    fig3 = plot_ned_pos_att_arr(pos_arr, RPY_arr, dtime);

%    set(fig3, 'Position', get(0, 'Screensize'));
%    filename3 = [fpath 'plot_state3'];
%    fprintf('[plot_state] filename3 %s \n', filename3);
%    print(fig3, [filename3 '.jpeg'], '-djpeg');
%    savefig(fig3, filename3);  
    
    fig4 = 0;
%    fig4 = plot_trajectory(time_arr, pos_arr);

%    set(fig4, 'Position', get(0, 'Screensize'));
%    view(0, 0);   % XZ
%    filename4 = [fpath 'plot_state4'];
%    fprintf('[plot_state] filename4 %s \n', filename4);
%    print(fig4, [filename4 '.jpeg'], '-djpeg');  
%     savefig(fig4, filename4);       

    fig5 = 0;
%    fig5 = plot_flight_angles(...
%        time_arr, RPY_arr, q_frd_ned_arr, vel_arr);
%        
%    set(fig5, 'Position', get(0, 'Screensize'));        
%    filename5 = [fpath 'plot_state5'];
%    fprintf('[plot_state] filename5 %s \n', filename5);
%    print(fig5, [filename5 '.jpeg'], '-djpeg');  
%    savefig(fig5, filename5);     

end
