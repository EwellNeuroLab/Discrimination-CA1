%% Function to get peaks on map. 

function [peakN, peakRate, peakLoc] = GetFieldPeaks(I, prom_thresh)

%% create a frame around the map
framed_I  = zeros(size(I) + [2 2]);
framed_I(2:end-1, 2:end-1) = I;

%% get peaks with thresholded prominence
[TF, ~] = islocalmax2(framed_I, MinProminence=prom_thresh);

%% find peaks where prominence is higher than cut off - use this for number of clusters
[pkX, pkY] = find(TF == 1);
peakN = length(pkX);

%% get actual peak rate
peakLoc = [pkX pkY] - [1 1]; % to shift back from framed to original map
peakRate = zeros(peakN,1);
for i = 1:peakN
    peakRate(i) = I(peakLoc(i,1), peakLoc(i,2));
end

end