%% function to get LED tuning

function [IsLightTuned, WhichLight, IsMatch] = GetLightTuning(TunedBin, LightBin, RewBin)

IsLightTuned = nan(length(TunedBin(:,1)),2);
WhichLight = nan(length(TunedBin(:,1)),2);
IsMatch = nan(length(TunedBin(:,1)),2);

%% remove light bin that overlaps with rewbin
 [~, ia,~] =  intersect(LightBin,RewBin);
 LightBin(ia) = NaN;

for i = 1:length(TunedBin(:,1))
    for j = 1:2
        if ~isnan(TunedBin(i,j))
            for k = 1:2
                ia = ismember(LightBin(k,:), TunedBin(i,j));

                if nnz(ia) > 0
                    IsLightTuned(i,j) =1;
                    WhichLight(i,j) =  LightBin(k,ia);

                    if j == k
                        IsMatch(i,j) = 1;
                    else
                        IsMatch(i,j) = 0;
                    end
                    break;
                end
                IsLightTuned(i,j) = 0;

            end
            

        end
    end


end


end