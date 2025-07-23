%% function to get mean event rate of HDC cells
function MeanRate = GetMeanRateHDC(HD_list, HD_table, HDir_Rate)
    MeanRate = nan(length(HD_list),1);
    for i = 1:length(HD_list)
        idx = find(HD_table.cellID == HD_list(i));
        MeanRate(i) = mean(HDir_Rate(idx,:,:),"all");
    end
end

