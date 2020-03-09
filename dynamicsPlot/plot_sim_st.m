function plot_sim_st(sim_st, fpath)   
    
    % fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    % fprintf('plot_input .. \n');
    fig = plot_input(sim_st, fpath);

    % fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    % fprintf('plot_state .. \n');
    [fig1, fig2, fig3, fig4] = plot_state(sim_st, fpath);   

    % fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    % fprintf('plot_output .. \n');
    [fig1, fig2] = plot_output(sim_st, fpath);

    % fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    % fprintf('plot_final_state .. \n');
    % [fig] = plot_final_state(sim_st, fpath);
    
end
