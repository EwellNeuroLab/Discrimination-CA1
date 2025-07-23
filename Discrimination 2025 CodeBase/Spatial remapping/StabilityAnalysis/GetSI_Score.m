%% function to calculate spatial information of place maps

function SI_score = GetSI_Score(maps, occupancy)


%% calculate occuancy probability
p_occupancy = occupancy./sum(occupancy,"all");


%% calculate mean rate as sum(p_occupancy * rate)
lambda_mean = squeeze(sum(maps.*p_occupancy, [1 2], "omitnan"));

%% now calculate spatial information score for each cell
[~,~, N_cell] = size(maps);
SI_score = zeros(N_cell,1);
for c = 1:N_cell
    SI_score(c) = sum(p_occupancy.*maps(:,:,c)./lambda_mean(c).*log2(maps(:,:,c)./lambda_mean(c)),"all", "omitnan");
end


end
