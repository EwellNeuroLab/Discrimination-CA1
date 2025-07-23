%% function subsample population and recalculate 1) difference between median and 25th pctile of two pops 2) ranksum

function [DistDifference, p_val] = SubSamplePopulation(popToSubSamp, popToMatch, repeat)

DistDifference = zeros(repeat,2);
p_val = zeros(repeat,1);

NsubSize = length(popToMatch);
for r = 1:repeat
    sub = randsample(popToSubSamp, NsubSize);
    for i = 1:2
        DistDifference(r,i) = prctile(sub,25*i)-prctile(popToMatch,25*i);
        p_val(r) = ranksum(sub, popToMatch);
    end
end

end




