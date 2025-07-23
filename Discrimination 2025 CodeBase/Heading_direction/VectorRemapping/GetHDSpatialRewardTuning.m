%% function to decide whether cell's HD and spatial tuning is at the same reward location
function IsMisMatchTuning = GetHDSpatialRewardTuning(All_d)

IsMisMatchTuning = nan(length(All_d.HasRewardField),2);

for i = 1:length(All_d.HasRewardField)

    if ~isnan(All_d.HasRewardField(i))
        HD_rew = All_d.RewardLoc{1}(i,~isnan(All_d.RewardLoc{1}(i,:)));
        PF_rew = All_d.HasRewardField(i);
    
        if PF_rew == 1 && HD_rew(1) == 2 % dont use cells that have fields at both reward location
            IsMisMatchTuning(i,1)= 1;
        elseif PF_rew == 2 && HD_rew(1) == 1
            IsMisMatchTuning(i,2)= 1;
        elseif PF_rew == HD_rew(1)
                IsMisMatchTuning(i,:) = 0;
        end
    end

end
end