%% function to cluster with k-means

function clusters  = GetClusterKMeans(I, fieldBins, k, max_iter)

    [idx,~] = kmeans(fieldBins, k, "MaxIter",max_iter);

    %% create maps for individual fields
    clusters = zeros([size(I) k]);

    for i =1:k

        clust_idx = find(idx == i);
        for j = 1:length(clust_idx)
            clusters(fieldBins(clust_idx(j),2), fieldBins(clust_idx(j),1),i) = 1;
        end

    end

end