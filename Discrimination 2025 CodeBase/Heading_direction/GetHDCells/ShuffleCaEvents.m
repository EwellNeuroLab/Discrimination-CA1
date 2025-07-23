%% function to shuffle events and recalculate RVL
function RVL_distribution = ShuffleCaEvents(CaMatrix,repeat, minShift, framesToUse, binned_HDir, HDirOccupancy, Nbins, binCenter, edges)
[N_cell,Nframes] = size(CaMatrix); 
maxShift = Nframes-minShift;
K  = randi([minShift maxShift], repeat,1);
RVL_distribution=zeros(N_cell,2,repeat);
for i = 1:repeat
    CaMatrix_shuffled = circshift(CaMatrix,K(i),2);
    EventTime_shuffled = cell(N_cell,2);
    for ctxt = 1:2
        EventTime_shuffled(:,ctxt)=GetEventTime(CaMatrix_shuffled, framesToUse{ctxt});
    end

    [RV_shuffled, ~, ~] = Get_HDirTuning(EventTime_shuffled, binned_HDir, HDirOccupancy,Nbins, binCenter,edges);
    RVL_distribution(:,:,i) = RV_shuffled.L;
end
end