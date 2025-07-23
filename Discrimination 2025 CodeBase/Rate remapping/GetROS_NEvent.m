%% function to get # of events and ROS relationship

function [MedianROS, counts,edges] = GetROS_NEvent(Nevent,RateOverlapScore, step)
    edges = 0:step:ceil(max(Nevent)+4);
    
    Nbins = length(edges);
    BinnedN = discretize(Nevent, edges);
    
    MedianROS = zeros(Nbins,1);
    counts = zeros(Nbins,1);
    
    for i = 1:Nbins
        idx = find(BinnedN == i);
        MedianROS(i) = prctile(RateOverlapScore(idx),50);
        counts(i) = length(idx);
    end
end