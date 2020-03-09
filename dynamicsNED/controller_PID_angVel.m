function y  = controller_PID_angVel(t, err, controller_st)
    
    persistent P_pid_st
    persistent Q_pid_st
    persistent R_pid_st
    if isempty(P_pid_st)
        
        P_pid_st.Kp = controller_st.MC_ROLLRATE_P;
        P_pid_st.Ki = controller_st.MC_ROLLRATE_I;
        P_pid_st.tp = 0;
        P_pid_st.err_tp = 0;
        P_pid_st.interr_tp = 0;
        P_pid_st.y_max = +controller_st.MPC_ANGACC_MAX;
        P_pid_st.y_min = -controller_st.MPC_ANGACC_MAX;
        
        Q_pid_st.Kp = controller_st.MC_PITCHRATE_P;
        Q_pid_st.Ki = controller_st.MC_PITCHRATE_I;
        Q_pid_st.tp = 0;
        Q_pid_st.err_tp = 0;
        Q_pid_st.interr_tp = 0;
        Q_pid_st.y_max = +controller_st.MPC_ANGACC_MAX;
        Q_pid_st.y_min = -controller_st.MPC_ANGACC_MAX;
        
        R_pid_st.Kp = controller_st.MC_YAWRATE_P;
        R_pid_st.Ki = controller_st.MC_YAWRATE_I;
        R_pid_st.tp = 0;
        R_pid_st.err_tp = 0;
        R_pid_st.interr_tp = 0;
        R_pid_st.y_max = +controller_st.MPC_ANGACC_MAX;
        R_pid_st.y_min = -controller_st.MPC_ANGACC_MAX;
    end
    
    [P_pid_st, yP] = controller_PID_update(t, err(1), P_pid_st);
    [Q_pid_st, yQ] = controller_PID_update(t, err(2), Q_pid_st);
    [R_pid_st, yR] = controller_PID_update(t, err(3), R_pid_st);
    y = [yP; yQ; yR];
end
