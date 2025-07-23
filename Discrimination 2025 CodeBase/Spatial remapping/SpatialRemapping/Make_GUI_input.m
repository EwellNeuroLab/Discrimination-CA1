%% function to make gui input - naming and variable type what the gui looks for


ActivityRate_full = squeeze(num2cell(RateMap_full,[1 2]));

for i = 1:2
ActivityRate_sess(:,i) = squeeze(num2cell(RateMap{i},[1 2]));
end