%% clustering place fields v2
close all;
rng(1);
for n =100:100%154
%% detect local peaks on map
I = ActivityMap_full{n};

framed_I  = zeros(size(I) + [2 2]);
framed_I(2:end-1, 2:end-1) = I;



[TF, P] = islocalmax2(framed_I, MinProminence=2);

%% find peaks where prominence is higher than cut off - use this for number of clusters
[pkX, pkY] = find(TF == 1);
k = length(pkX);

%% get actual peak rate
pks = [pkX pkY] - [1 1]; % to shift back from framed to original map
peakRate = zeros(k,1);
for i = 1:k
    peakRate(i) = I(pks(i,1), pks(i,2));
end


%% select bins that are above a threshold
[FieldX, FieldY] = find(I > 0.2);
upsample_map = I./max(I,[],"all").*100;

FieldX_upsampled = [];
FieldY_upsampled = [];
for i = 1:length(FieldX)
    N_repeat = round(upsample_map(FieldX(i), FieldY(i)))+1;
    FieldX_upsampled = [FieldX_upsampled; repmat(FieldX(i), N_repeat,1)];
    FieldY_upsampled = [FieldY_upsampled; repmat(FieldY(i), N_repeat,1)];
end


%% fit gaussian mixture model to field bins
gm = fitgmdist([FieldY_upsampled FieldX_upsampled], k);

%% cluster w/ kmeans
[cInd,~] = kmeans([FieldY FieldX], k);


%% get clusters
idx = cluster(gm, [FieldY_upsampled FieldX_upsampled]);



%% get maps from clusters
cluster_map = zeros(size(I));
cluster_map2 = zeros(size(I));
for i  =1:k

    %GMM
    clust_idx = find(idx == i);
    for j= 1:length(clust_idx)
        cluster_map(FieldX_upsampled(clust_idx(j)), FieldY_upsampled(clust_idx(j))) = i;
    end

    %k-means
    clust_idx2 = find(cInd == i);
    for j = 1:length(clust_idx2)
        cluster_map2(FieldX(clust_idx2(j)), FieldY(clust_idx2(j))) = i;
    end

end

%% get contours & plot results
x= 1:20;
y = 1:20;

gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0 y0]),x,y);


figure
tiledlayout(1,3)
nexttile;
h= imagesc(I);
axis square
set(gca,"YDir", "normal")
hold on
fcontour(gmPDF, "LineColor","w")
set(h, "AlphaData", ~isnan(I))
box off

nexttile;
axis square
hh = imagesc(cluster_map);
axis square
set(gca,"YDir", "normal")
hold on
fcontour(gmPDF, "LineColor","w")
set(hh, "AlphaData", ~isnan(I))
box off

nexttile;
axis square
hhh = imagesc(cluster_map2);
axis square
set(gca,"YDir", "normal")
hold on
set(hhh, "AlphaData", ~isnan(I))
box off
%close gcf
end