%function to get reward location
function RZ_Loc = GetRewLocation(trials, Correct, event, BinnedXY)
[~, ~, idxI] = intersect(trials,Correct(:,1));
RZ_frames = event{Correct(idxI,2),2}+1;
RZ_xy = BinnedXY(RZ_frames,:);

rewI_map = zeros(max(BinnedXY));
for i = 1:length(RZ_xy)
    rewI_map(RZ_xy(i,2), RZ_xy(i,1)) = rewI_map(RZ_xy(i,2), RZ_xy(i,1)) +1;
end

[~,max_idx] = max(rewI_map(:));
[X, Y]=ind2sub(size(rewI_map),max_idx);
RZ_Loc = [X Y]; 

end