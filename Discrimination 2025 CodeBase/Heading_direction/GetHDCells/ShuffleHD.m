%% function to shuffle heading-direction and calculate RVL distribution

function RVL_distribution = ShuffleHD(HDir, minShift, repeat, edges, framesToUse, Nbins, framerate, EventTime, binCenter)
    N_cell = length(EventTime(:,1));
    Nframes = length(HDir); 
    maxShift = Nframes-minShift;
    K  = randi([minShift maxShift], repeat,1);
    RVL_distribution=zeros(N_cell,2,repeat);
    for i = 1:repeat
        HDir_shuffled = circshift(HDir,K(i));   
        [binned_HDir_shuffled, binCenter] = BinHDir(HDir_shuffled, edges);
        HDirOccupancy_shuffled = HDir_Occupancy(framesToUse, binned_HDir_shuffled, Nbins, framerate); 
        [RV_shuffled, ~, ~] = Get_HDirTuning(EventTime, binned_HDir_shuffled, HDirOccupancy_shuffled,Nbins, binCenter,edges);
        RVL_distribution(:,:,i) = RV_shuffled.L;
    end
end