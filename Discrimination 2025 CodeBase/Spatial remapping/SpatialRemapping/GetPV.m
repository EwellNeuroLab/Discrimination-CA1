%% function to calculate PVC

function [mean_PVC, PVcorr]= GetPV(popfiringI, popfiringII)
    [r,c,~] = size(popfiringI);
    PVcorr = nan(r,c);
    for i = 1:r
        for j = 1:c
            pI = squeeze(popfiringI(i,j,:));
            pII = squeeze(popfiringII(i,j,:));
            PVcorr(i,j) = nancorr(pI, pII);
        end
    end

    mean_PVC = mean(PVcorr, "all", "omitnan");
end