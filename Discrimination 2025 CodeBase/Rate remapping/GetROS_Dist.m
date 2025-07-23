%% function to bin distance from reward and calculate mean and std of ros in each bin

function [ROS_dist, counts, edges] = GetROS_Dist(RewDist, RateOverlapScore)
edges = 0:2.50000001:ceil(max(RewDist))+2.50000001;
Nbins = length(edges);
BinnedDist = discretize(RewDist, edges);

ROS_dist = zeros(Nbins,3);
counts = zeros(Nbins,1);

for i = 1:Nbins
    idx = find(BinnedDist == i);
    for j = 1:3
        ROS_dist(i,j) = prctile(RateOverlapScore(idx),25*j);
    end
    counts(i) = length(idx);
end
end