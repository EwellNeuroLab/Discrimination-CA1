%% function to assess whether true Pearson's is statistically significant


function PlaceCell_tbl = GetPlaceCells(all_cell, cellID, Fishers_shuffled, Fishers_true, Pearsons_true, Pearsons, CaMatrix, IsDrifting, thresh, framerate)
IsSignificant = nan(all_cell,4);
IsSignificant(cellID,:) = 0;


%% Calculate %ile threshold for each cell for both contexts and compare it to true value [yes/no ctxt 1 ctxt 2 both]
PercentileThreshold =prctile(Fishers_shuffled, thresh.pctile, 3);
IsExceed= gt(Fishers_true, PercentileThreshold);

IsSignificant(cellID,2:3) = IsExceed; % significant, context specific
IsSignificant(sum(IsSignificant(:,2:3),2) > 0 ,1) = 1; % significant at least in one context
IsSignificant(sum(IsSignificant(:,2:3),2) == 2 ,4) = 1; % significant  in both contexts


%% Now check whether cell is stable (r > thresh) [yes/no ctxt1 ctxt2 both]
IsStable = nan(all_cell,4);
IsStable(cellID,:) = 0;
IsStable(cellID,2:3) = Pearsons_true>thresh.r;
IsStable(sum(IsStable(:,2:3),2) > 0 ,1) = 1; % significant at least in one context
IsStable(sum(IsStable(:,2:3),2) == 2 ,4) = 1; % significant  in both contexts


%% Now check whether cell is active at least N times
IsActive = nan(all_cell,1);
IsActive(cellID) = sum(CaMatrix, 2) > thresh.event;
all_cell_ID = nan(all_cell,1);
all_cell_ID(cellID) = cellID;
PlaceCell_tbl = table();
PlaceCell_tbl.("IsDrifting") = IsDrifting;
PlaceCell_tbl.("cellID") = all_cell_ID;
PlaceCell_tbl.("IsActive") = IsActive;
PlaceCell_tbl.("IsStable") = IsStable;
PlaceCell_tbl.("IsSignificant") = IsSignificant;

%% place cell criteria - not drifting, active, significantly stable at least in one context [yes/no ctxt1 ctxt2 both]

IsPC = nan(all_cell,4);
IsPC(cellID,:) = 0;

%% place cell in contexts
for i =2:3
    IsPC(PlaceCell_tbl.IsStable(:,i) == 1 & PlaceCell_tbl.IsSignificant(:,i) ==1 & PlaceCell_tbl.IsActive == 1 & PlaceCell_tbl.IsDrifting == 0 ,i) = 1;
end
IsPC(sum(IsPC(:,2:3),2) > 0,1) = 1; % PC at least in one ctxt
IsPC(sum(IsPC(:,2:3),2) > 0,4) = 1; % PC in both contexts



%% add pearsons to table
Stability_r = nan(all_cell,2);
Stability_r(cellID,:) = Pearsons_true;

Remap_r =  nan(all_cell,1);
Remap_r(cellID,:) = Pearsons;

%% add event rate for each cell
TotalRate =  nan(all_cell,1);
[~,session_L] = size(CaMatrix);
TotalRate(cellID) = sum(CaMatrix, 2)./session_L.*framerate.*60;


PlaceCell_tbl.("IsPC") = IsPC;
PlaceCell_tbl.("Stability") = Stability_r;
PlaceCell_tbl.("Remap") = Remap_r;
PlaceCell_tbl.("TotalRate") = TotalRate;

end