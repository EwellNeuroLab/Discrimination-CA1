%% main function to cluster place fields with GMM or k-mean

function [clusters, peakRate, peakLoc, gm] = WrapFieldClustering(I, prom_thresh,rate_thresh, max_iter, cluster_Method)

[peakN, peakRate, peakLoc] = GetFieldPeaks(I, prom_thresh);

if peakN > 0
    
[fieldBins, fieldBinsUpsampled] = GetFieldBins(I, rate_thresh, peakRate);

switch cluster_Method

    case "GMM"
        [clusters, gm] = GetClusterGMM(I, fieldBinsUpsampled, peakN, max_iter);


    case "K-means"

        clusters  = GetClusterKMeans(I, fieldBins, peakN, max_iter);
        gm = [];
end

clusters = CheckConnectivity(I, clusters);


else
    clusters = [];
    gm = [];
end

end