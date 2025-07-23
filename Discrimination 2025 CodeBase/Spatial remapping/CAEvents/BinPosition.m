%% function to bin position data of mouse

function [BinnedXY, edges] = BinPosition(XY, ArenaSizeCm, binSizeCm)
    Nbins = ArenaSizeCm/binSizeCm;
    edges = zeros(Nbins+1,2);
    BinnedXY  =zeros(size(XY));
    
    for i  =1:2
        edges(:,i) = min(XY(:,i)):(max(XY(:,i))- min(XY(:,i)))/Nbins:max(XY(:,i));
        BinnedXY(:,i) = discretize(XY(:,i), edges(:,i));
        
    end
end


