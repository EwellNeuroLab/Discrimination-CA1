%% function to cluster fields with Gaussian-mixture model

function [clusters, gm] = GetClusterGMM(I,fieldBins, k, max_iter)
    
    %% GMM clustering
    options = statset('MaxIter',max_iter);
    gm = fitgmdist(fieldBins, k, "Options", options);
    idx = cluster(gm, fieldBins);

    %% create maps for individual fields
    clusters = zeros([size(I) k]);
   
    for i  =1:k
        clust_idx = find(idx == i);
        for j= 1:length(clust_idx)
            clusters(fieldBins(clust_idx(j),2), fieldBins(clust_idx(j),1),i) = 1;
        end

    end
    

end