%% function to calculate vector remapping (Pearson's between tuning curves in A and B)

function VectorRemap = GetVectorRemap(HDir_Rate)
[Ncell,~,~] = size(HDir_Rate);
VectorRemap = zeros(Ncell,1);
for c = 1:Ncell
    Curve1 = HDir_Rate(c,:,1);
    Curve1(Curve1 == 0) = randn(length(find(Curve1 == 0)),1)./1e9; % replace 0s with small noise
    Curve2 = HDir_Rate(c,:,2);
    Curve2(Curve2 == 0) = randn(length(find(Curve2 == 0)),1)./1e9;
    VectorRemap (c) = nancorr(Curve1,Curve2);
end
end