%% function to get bin where HDC tuned to

function TunedBin = GetTuningBin(HD_list, HD_table)

TunedBin = zeros(length(HD_list),2);

for i = 1:length(HD_list)
    idx = find(HD_table.cellID == HD_list(i));
    TunedBin(i,:) = HD_table.IsPC_HDC(idx,2:3).*HD_table.RVMeanBin(idx,:); 

end
TunedBin(TunedBin == 0) = NaN;

end