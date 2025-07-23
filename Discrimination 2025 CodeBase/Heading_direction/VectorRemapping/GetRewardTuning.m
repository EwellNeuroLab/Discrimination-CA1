%% function to get reward tuning

function [IsRewardTuned, WhichReward, IsMatch] = GetRewardTuning(TunedBin,RewBin, LightBin)

IsRewardTuned = zeros(length(TunedBin(:,1)),2);
WhichReward = nan(length(TunedBin(:,1)),2);
IsMatch = nan(length(TunedBin(:,1)),2);

[~,ia,~] = intersect(RewBin,LightBin); % dont use reward location that overlaps with the light
RewBin(ia) = [];

for i = 1:length(TunedBin(:,1))

    for j = 1:2
        if ~isnan(TunedBin(i,j))
            for k = 1:length(RewBin)

                if TunedBin(i,j) == RewBin(k)
                    IsRewardTuned(i,j) = 1;
                    if j == k
                        IsMatch(i,j) = 1;
                    else
                        IsMatch(i,j) = 0;
                    end
                    WhichReward(i,j) = k;
                    break;
                else
                    IsRewardTuned(i,j) = 0;
                end
            end
        end
    end
end



end