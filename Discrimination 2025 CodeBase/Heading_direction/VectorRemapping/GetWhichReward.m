%% function to get to which reward the HDC is tuned to

function [NReward, WhichReward] = GetWhichReward(TunedBin,RewBin)
    
WhichReward = nan(length(TunedBin(:,1)),1);

for i = 1:length(TunedBin(:,1))
    for r = 1:length(RewBin)
       if ~isempty(intersect(TunedBin(i,:), RewBin(r)))
           WhichReward(i) = r;
       end
    end


end

NReward = [sum(WhichReward == 1) sum(WhichReward == 2)];
end