%% function to measure whether vector length is significant

function IsSignificant = TestSignificantRV(RVL_distribution_events, RV, pctile_thresh)

PercentileThreshold =prctile(RVL_distribution_events, pctile_thresh, 3);
[n_cells, ~] = size(PercentileThreshold); 
IsSignificant=nan(n_cells,3);
IsSignificant(:,2:3)= gt(RV.L, PercentileThreshold);
IsSignificant(:,1) =sum(IsSignificant(:,2:3),2)>0;
end






