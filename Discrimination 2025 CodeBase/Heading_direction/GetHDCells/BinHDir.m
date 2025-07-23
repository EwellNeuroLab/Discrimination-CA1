%% function to bin goal-direction with from -pi to +pi
function [binned_GD, binCenter] = BinHDir(HDir, edges)

binned_GD = discretize(HDir, edges);
Nbins = length(edges)-1;
binCenter = zeros(Nbins,1);
bw = (edges(2)-edges(1))/2;

for i = 1:Nbins
    binCenter(i) = bw+edges(i);
end

end