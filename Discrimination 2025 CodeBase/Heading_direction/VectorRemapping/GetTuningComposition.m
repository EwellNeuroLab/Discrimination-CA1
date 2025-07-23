%% function to assign heading-direction tuned cells to reward/light or other category

function CategoricalTuning = GetTuningComposition(TunedBin, RewBin, LightBin)


% get "other" bins
OtherBin= 1:8;
[~, ia,~] =  intersect(OtherBin,RewBin);
OtherBin(ia) = []; 
[~, ia,~] =  intersect(OtherBin,LightBin);
OtherBin(ia) = []; 

%% nan out light bin that overlaps w/ reward bin
[~, ia,ib] =  intersect(LightBin,RewBin);
LightBin(ia) = NaN;
RewBin(ib) = -1;



CategoricalTuning = nan(length(TunedBin(:,1)),2); % 1=reward, 2=light, 3=other

for i = 1:length(TunedBin(:,1))
    for j = 1:2
        if ~isnan(TunedBin(i,j))
            if ismember(TunedBin(i,j), RewBin)
                CategoricalTuning(i,j) = 1;
            elseif ismember(TunedBin(i,j), LightBin)
                CategoricalTuning(i,j) = 2;
            elseif ismember(TunedBin(i,j), OtherBin)
                CategoricalTuning(i,j) = 3;
            else
                CategoricalTuning(i,j) = 0;
            end
        end
    end


end

end