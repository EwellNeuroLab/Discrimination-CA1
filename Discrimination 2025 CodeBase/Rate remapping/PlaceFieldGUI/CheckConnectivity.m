%% function to remove pixels that are not connected to the peak of the cluster

function clusters = CheckConnectivity(I, clusters)

[~,~,NClust] = size(clusters);

for clust = 1:NClust

    % get peak of current field
    [~, peak_idx] =max(I.*clusters(:,:,clust),[],"all");

    [r,c] = size(I);
    CC = bwconncomp(clusters(:,:,clust));
    mask = zeros(r*c,1);
    if CC.NumObjects > 1
      
        for i= 1:CC.NumObjects
            if ismember(peak_idx, CC.PixelIdxList{i})
                mask(CC.PixelIdxList{i}) = 1;
            end
        end
        mask = reshape(mask, size(I));
        clusters(:,:,clust) = clusters(:,:,clust).*mask;
    end
    


end



