%% function to get GD occupancy in each context

function HDirOccupancy = HDir_Occupancy(framesToUse, binned_HDir, Nbins, framerate)
N_ctxt = length(framesToUse);
HDirOccupancy = zeros(Nbins,N_ctxt); % dimensions: angular bins, ctxts, rewards
for c =  1:N_ctxt
    HDirOccupancy(:,c)  = histcounts(binned_HDir(framesToUse{c}), 1:Nbins+1)./framerate./60; % measured in minute
end

end