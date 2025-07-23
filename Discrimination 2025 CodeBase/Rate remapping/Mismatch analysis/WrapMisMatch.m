%% wrap mismatch 
function [FiringPref, RZ_ID, MeanRate] = WrapMisMatch(workdir)

FiringPref = [];
RZ_ID = [];
MeanRate = [];
for f = 1:length(workdir)

    load(strcat(workdir(f),"\processedData\MisMatchTbl.mat"));
    rfield_idx = find(Mismatch_tbl.IsActive == 1 & Mismatch_tbl.RewZone > 0);

    RZ_ID = [RZ_ID ; Mismatch_tbl.RewZone(rfield_idx)];
    FiringPref= [FiringPref; Mismatch_tbl.FiringPrefMean(rfield_idx)];
    MeanRate = [MeanRate; Mismatch_tbl.MeanRate(rfield_idx,:)];
    

end


end