function [fig1, fig2] = plot_output(sim_st)   

    if isfield(sim_st.output_st, 'yPID')
        plot_output_yPID(sim_st);
    end
    if isfield(sim_st.output_st, 'yForMom')
        plot_output_yForMom(sim_st);
    end
    if isfield(sim_st.output_st, 'y')
        plot_output_y(sim_st);
    end        
    
end
