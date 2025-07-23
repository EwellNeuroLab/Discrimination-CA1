%% function to get splitted heading tuning curve
function [Pearsons_stability, Pearsons, HDir_Rate_splitted, HDirOccupancy_splitted] = GetSplittedTuningCurve(EventTime, framesSplitted, binned_HDir, Nbins, framerate, CaMatrix, binCenter,edges)
HDir_Rate_splitted = cell(4,1);
for s =1:4 % loop on splitted dataset: 1st, 2nd, odd, even
    EventTime_splitted = cell(size(EventTime));
    HDirOccupancy_splitted = HDir_Occupancy(framesSplitted(s,:)', binned_HDir, Nbins, framerate);
    for ctxt = 1:2
        EventTime_splitted(:,ctxt) = GetEventTime(CaMatrix, framesSplitted{s,ctxt});
    end
    [~, HDir_Rate_splitted{s}, ~] = Get_HDirTuning(EventTime_splitted, binned_HDir, HDirOccupancy_splitted,Nbins,binCenter,edges);
end

%% now calculate pearson's starting with 1st and 2nd half, each cell each context
[N_cell,~] = size(CaMatrix);
Pearsons = zeros(N_cell,2,2); % 2nd dim: 2 splitting case, 3rd: contexts

for s = 1:2
    for c = 1:N_cell

        for ctxt = 1:2
            Curve1 = HDir_Rate_splitted{2*(s-1)+1}(c,:,ctxt) ; 
            Curve1(Curve1 == 0) = randn(length(find(Curve1 == 0)),1)./1e9; % replace 0s with small noise
            Curve2 = HDir_Rate_splitted{2*s}(c,:,ctxt) ; 
            Curve2(Curve2 == 0) = randn(length(find(Curve2 == 0)),1)./1e9;
            Pearsons(c,s,ctxt) = nancorr(Curve1,Curve2);
        end
    end
end

% take the mean of the two splitting
Pearsons_stability = squeeze(mean(Pearsons,2));
end