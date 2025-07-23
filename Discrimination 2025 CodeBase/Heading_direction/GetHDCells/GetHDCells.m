%% function to get heading-direction cells and create table


function HD_table = GetHDCells(RV,RVL_distribution_events,RVL_distribution_HDir, CaMatrix, cellID, VectorRemap, Pearsons_stability, thresh)


IsActive = sum(CaMatrix, 2) > thresh.event;

IsSignificant = TestSignificantRV(RVL_distribution_events, RV, thresh.pctile);
IsSignificant_HDir = TestSignificantRV(RVL_distribution_HDir, RV, thresh.pctile);

HD_table = table();

HD_table.cellID  = cellID';

%get whether cell has heading-direction tuning
IsHDC = nan(length(cellID),3);
for i = 2:3
    IsHDC(:, i) = Pearsons_stability(:,i-1) > thresh.stability & IsSignificant(:,i) == 1  & IsActive == 1;
end
IsHDC(:,1) =sum(IsHDC(:,2:3),2)>0; % HDC at least in one context

% apply stricter criteria - only to be applied to cells that are place
% cells too
IsPC_HDC = nan(length(cellID),3);
for i = 2:3
    IsPC_HDC(:, i) = Pearsons_stability(:,i-1) > thresh.stability & IsSignificant(:,i) == 1 & IsSignificant_HDir(:,i) == 1  & IsActive == 1;
end
IsPC_HDC(:,1) =sum(IsPC_HDC(:,2:3),2)>0; % HDC at least in one context

HD_table.IsHDC = IsHDC;
HD_table.IsPC_HDC = IsPC_HDC;
HD_table.IsActive = IsActive;
HD_table.IsSignificant = IsSignificant;
HD_table.IsSignificant_HDShuff = IsSignificant_HDir;
HD_table.RemapValue = VectorRemap;
HD_table.Stability = Pearsons_stability;
HD_table.RVL = RV.L;
HD_table.RVMean = RV.Dir;
HD_table.RVMeanBin = RV.BinnedDir;
end