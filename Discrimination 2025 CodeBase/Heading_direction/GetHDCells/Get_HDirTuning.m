%% function to calculate tuning curves for each cell in both context and to calculate Rayleigh's vector
function [RV, HDir_Rate, EventHDir] = Get_HDirTuning(EventTime, binned_HDir, HDirOccupancy,Nbins,binCenter,edges)

[Ncells, ~] = size(EventTime);
EventHDir = cell(Ncells,2); % heading direction during event for each cell for each contexts
HDir_Rate = zeros(Ncells,Nbins,2);
RV.L = zeros(Ncells,2); % Rayleigh vector length
RV.Dir = zeros(Ncells,2); % Rayleigh vector direction
RV.NonUniformity = zeros(Ncells,2); %Rayleigh test for non-uniformity
for c =  1:Ncells
    for ctxt = 1:2
        EventHDir{c,ctxt} = binned_HDir(EventTime{c,ctxt},:);
        HDir_Rate(c,:,ctxt) = histcounts(EventHDir{c,ctxt}, 1:Nbins+1)./HDirOccupancy(:,ctxt)'; 
        RV.L(c,ctxt) = circ_r(deg2rad(binCenter), HDir_Rate(c,:,ctxt)'); % RV length
        if isnan(RV.L(c,ctxt))
            RV.L(c,ctxt) = 0;
        end
        RV.Dir(c,ctxt) = rad2deg(circ_mean(deg2rad(binCenter), HDir_Rate(c,:,ctxt)')); % RV angle

        for e = 1:length(edges)-1
            if RV.Dir(c,ctxt) >=edges(e) && RV.Dir(c,ctxt) < edges(e+1)
              RV.BinnedDir(c,ctxt) = e; 
            end
        end
        RV.NonUniformity(c,ctxt) = circ_rtest(deg2rad(binCenter), HDir_Rate(c,:,ctxt)'); % testing for non-uniformity
    end

end

