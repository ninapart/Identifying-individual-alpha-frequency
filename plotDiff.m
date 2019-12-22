function IAF = plotDiff(EC, EO, freq, type)
% Plot the difference spectrum and the IAF
%
% IAF = plotDiff(EC, EO, freq, type)
%         Find the IAF by substracting the EC,EO and checking the maximum.
%         Plot the difference and add a vertical line marking the IAF
    diff_title = " Difference Spectrum";
    % percentage of the graph range to add the ylim
    axis_scale = 0.05;
    IAF_legend = "IAF = %.2f";
    diff_legend = "EC - EO";
    
    % Calculate the difference and get the maximum value's frequency=IAF
    diff = EC - EO;
    [max_diff , index] = max(diff);
    IAF = freq(index);
    
    % Plot the difference spectrum
    plot(freq, diff, 'red'); hold on
    title(type + diff_title);
    
    % Just set a nicer ylim
    min_y = min(EC); max_y = max(EC);
    range = max_y-min_y;
    y = [min_y - axis_scale*range, max_y + axis_scale*range];
    ylim(y);
    
    % Add the IAF to the plot
    x=[IAF,IAF];
    plot(x,y, '--k');
    legend(diff_legend, sprintf(IAF_legend, IAF));
    
end