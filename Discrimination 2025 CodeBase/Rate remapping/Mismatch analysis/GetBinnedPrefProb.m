%function to get firing pref - heading prob relationship (binned)
function [edges, MedianProbRew, ProbRew] =  GetBinnedPrefProb(step, Firing_Pref, ProbReward)
edges = -1:step:1;
binned_pref = discretize(Firing_Pref,edges);

MedianProbRew = nan(length(edges)-1,3);
ProbRew = cell(length(edges)-1,1);
for b = 1:length(edges)-1
    idx = find(binned_pref == b);
    MedianProbRew(b,:)  = prctile(ProbReward(idx,:),75);
    ProbRew{b} = ProbReward(idx,:);

end
end