function plotPS(EC, EO, freq, type)
% Plot both EC,EO power spectra, without axis lables
%
% plotPS(EC, EO, freq, type)
%       Plot both EC and EO signals on a single plot,
%       with "Magnitude" and "Frequency (Hz)" labels.
    % percentage of the graph range to add the ylim
    axis_scale = 0.05;

    plot (freq, EC, freq, EO);
    title(type);
    legend("EC", "EO");
    min_val = min(EC); max_val = max(EC);
    range = max_val-min_val;
    ylim([min_val-axis_scale*range, max_val+axis_scale*range]);
    
end