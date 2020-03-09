function y  = controller_PID_ang(t, err, controller_st)
    
    persistent R_pid_st
    persistent P_pid_st
    persistent Y_pid_st
    if isempty(R_pid_st)
        
        R_pid_st.Kp = controller_st.MC_ROLL_P;
        R_pid_st.Ki = 0;
        R_pid_st.tp = 0;
        R_pid_st.err_tp = 0;
        R_pid_st.interr_tp = 0;
        R_pid_st.y_max = +controller_st.MC_ROLLRATE_MAX;
        R_pid_st.y_min = -controller_st.MC_ROLLRATE_MAX;
        
        P_pid_st.Kp = controller_st.MC_PITCH_P;
        P_pid_st.Ki = 0;
        P_pid_st.tp = 0;
        P_pid_st.err_tp = 0;
        P_pid_st.interr_tp = 0;
        P_pid_st.y_max = +controller_st.MC_PITCHRATE_MAX;
        P_pid_st.y_min = -controller_st.MC_PITCHRATE_MAX;
        
        Y_pid_st.Kp = controller_st.MC_YAW_P;
        Y_pid_st.Ki = 0;
        Y_pid_st.tp = 0;
        Y_pid_st.err_tp = 0;
        Y_pid_st.interr_tp = 0;
        Y_pid_st.y_max = +controller_st.MC_YAWRATE_MAX;
        Y_pid_st.y_min = -controller_st.MC_YAWRATE_MAX;
    end
    
    [R_pid_st, yR] = controller_PID_update(t, err(1), R_pid_st);
    [P_pid_st, yP] = controller_PID_update(t, err(2), P_pid_st);
    [Y_pid_st, yY] = controller_PID_update(t, err(3), Y_pid_st);
    y = [yR; yP; yY];
end
