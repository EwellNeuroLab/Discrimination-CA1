%% function to save examples of drifting and non-drifting cells



type = ["Non-drift", "Drift"];
for i  = 0:1
    file_name = strcat(out, type(i+1), ".pdf");
    delete file_name
    idx = find(IsDrifting == i);
    if N_example < length(idx)
        y = datasample(idx, N_example);
    else
        y = idx; % if there are less cells than the requested # of examples, plot all the cells
    end

    for j = 1:length(y)
        figure("Visible","off")
        plot(c(:,y(j)), "k-")
        hold on
        plot(s(:,y(j)), "r-")
        box off
        title(strcat("ID ", num2str(y(j))))
        exportgraphics(gca, file_name, "Append", true )
        close(gcf)
    end

end


