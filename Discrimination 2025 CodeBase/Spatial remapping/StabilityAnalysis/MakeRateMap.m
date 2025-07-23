%% function to create event map for every cell

function [RateMap, EventXY, EventTime, OccupancyMap] = MakeRateMap(BinnedXY, CaMatrix, XYedges, frames, framerate, filterSize)

[N_cell,~] = size(CaMatrix);
BinEdges = length(XYedges(:,1));
%% make occupancy map
[OccupancyMap, ~,~] = histcounts2(BinnedXY(frames,2), BinnedXY(frames,1), 1:BinEdges, 1:BinEdges); % get occupancy map
OccupancyMap=OccupancyMap./framerate./60; % convert it to min
N_NonOccupiedBins = sum(OccupancyMap == 0, "all"); % get # of non-occupied bins

%% make rate map for every cell
EventXY = cell(N_cell,1);
EventTime = cell(N_cell,1);
RateMap = nan(BinEdges-1, BinEdges-1, N_cell);
for i = 1:N_cell
    QueryEvents = intersect(find(CaMatrix(i,:)==1),frames); % activity in query frames
    EventTime{i} = QueryEvents; % save event time
    EventXY{i} = BinnedXY(EventTime{i},:); % save event position
    if ~isempty(EventTime{i})
        [TempRate, ~, ~] = histcounts2(EventXY{i}(:,2), EventXY{i}(:,1), 1:BinEdges, 1:BinEdges); % create map
        TempRate = TempRate./OccupancyMap; % event/min
        TempRate(TempRate == 0) = abs(randn(length(find(TempRate==0)),1)./1e9);% replace 0s with small numbers
        TempRate(OccupancyMap == 0) = abs(randn(N_NonOccupiedBins,1)./1e9); % replace non-occupied bins with small numbers
        TempRate = imgaussfilt(TempRate, filterSize);    % now apply filter on the map
    else
        TempRate =abs(randn(BinEdges-1,BinEdges-1)./1e9);
    end
        TempRate(OccupancyMap == 0) = NaN; % now set non-occupied bins to nan (for visualization)
        RateMap(:,:,i) = TempRate ;
end

end







