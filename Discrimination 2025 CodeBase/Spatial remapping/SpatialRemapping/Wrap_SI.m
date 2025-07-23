%% wrapping function for gui input and spatial info score

function SpatialInfo = Wrap_SI(workdir,discrimination)
SpatialInfo.Individual = cell(length(workdir),1);
SpatialInfo.Cohort = {[]; []};
SpatialInfo.All = [];
filterSize = 1.5;
framerate =30;

for f = 1:length(workdir)
    clearvars -except SpatialInfo framerate filterSize workdir discrimination f
    disp(workdir(f))
    load(strcat(workdir(f),"\processedData\PCAnalysis.mat"))
    load(strcat(workdir(f),"\processedData\CaActivity.mat"))

    %% calculate rate map for ctxt 1 + ctxt 2 (foraging phase and runnning only)
    framesToUse  = intersect(intersect(find(States.TrialPhase==1),find(States.Context  >0)),find(States.Run == 1)); % only running & foraging!
    [RateMap_full, ~, ~, Occupancy_full] = MakeRateMap(BinnedXY, CaMatrix, XYedges, framesToUse, framerate, filterSize);
    RateMap_full(:,:,PC_tbl.IsPC(:,1) ~=1) = []; %keep only place cell maps

    %% calculate spatial information score
    SpatialInfo.Individual{f} = GetSI_Score(RateMap_full, Occupancy_full);
    SpatialInfo.Cohort{discrimination(f)} = [SpatialInfo.Cohort{discrimination(f)}; SpatialInfo.Individual{f}];
    SpatialInfo.All = [SpatialInfo.All ; SpatialInfo.Individual{f} ];

    %% prepare gui input - remove context-wise map from cells that are not labelled as non-drifting (but labelled as threshold needed)
    non_drifting = find(PC_tbl.IsDrifting ~= 1); % non-drifting or threshold needeed cells have map
    pc = find(PC_tbl.IsPC(:,1) == 1);
    rmv_id = find(PC_tbl.IsPC(non_drifting,1) ==0 ); % id of non-place cells
    RateMap{1}(:,:,rmv_id) = [];
    RateMap{2}(:,:,rmv_id) = [];

    %% convert matrices into cell format that the gui expects and save it
    ActivityRate_full = squeeze(num2cell(RateMap_full,[1 2]));
    for i = 1:2
        ActivityRate_sess(:,i) = squeeze(num2cell(RateMap{i},[1 2]));
    end
    cell_ID = pc;
    save(strcat(workdir(f), "\processedData\PlaceMaps.mat"), "ActivityRate_sess", "ActivityRate_full", "cell_ID")

end
end