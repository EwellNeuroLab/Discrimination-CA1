%% function to do mismatch statistics

MisMatchRate  = [rate_ordered{1}(:,1); rate_ordered{2}(:,2)];
UniFormRate = unifrnd(0,1, size(MisMatchRate));