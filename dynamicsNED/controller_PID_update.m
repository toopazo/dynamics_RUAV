function [pid_st, y] = controller_PID_update(t, err, pid_st)
    
    % Update int(0, t, err)
    % err_arr = pid_st.err_arr;
    % err_arr = circshift(err_arr, -1);
    % err_arr(end) = err;
    % interr = sum(err_arr);
    % pid_st.err_arr = err_arr;

    % Previous time
    tp = pid_st.tp;
    % Previous error
    err_tp = pid_st.err_tp;
    % Previous integral error
    interr_tp = pid_st.interr_tp;

    % Delta time
    dt = t - tp;
    
    % Calculate integral(0, t, err)
    interr = interr_tp + 0.5*(err_tp + err)*dt;
    
    % Calculate PID output   
    y = pid_st.Kp * err + pid_st.Ki * interr;
    
    % Saturation
    if y > pid_st.y_max
        y = pid_st.y_max;
    end
    if y < pid_st.y_min
        y = pid_st.y_min;
    end
        
    % Anti-windup
%    if err_tp > 999 % pid_st.interr_max
%        y = 999; % pid_st.interr_max;
%    end
%    if err_tp < -999 % pid_st.interr_max
%        y = -999; % pid_st.interr_max;
%    end    

    % Prepare for next iteration
    pid_st.tp = t;
    pid_st.err_tp = err;
    pid_st.interr_tp = interr;

end


