%% Wrapping function for spatial remap analysis

function [All, Cohort, Individual] =  Wrap_Remap_Spatial(workdir,discrimination)

All.Remap = [];
All.Rate = [];
All.Stability = [];
All.StackedMap = {[]; []};
All.ID = [];


Cohort.Remap = {[]; []};
Cohort.Stability = {[]; []};
Cohort.StackedMap = {[] []; [] []};
Cohort.PV = zeros(2,1);


Individual.Remap = cell(length(workdir),1);
Individual.Stability = cell(length(workdir),1);
Individual.PV = zeros(length(workdir),1);
Individual.RateMaps = cell(length(workdir),2);



for f = 1:length(workdir)

    clearvars -except f workdir Individual Cohort All discrimination
    disp(workdir(f))
    load(strcat(workdir(f), "\processedData\PCAnalysis.mat"))

    % get remapping coefficient of every place cells
    non_drifting = find(PC_tbl.IsDrifting ~= 1); % non-drifting or threshold needeed cells have map
    pc = find(PC_tbl.IsPC(:,1) == 1);
    map_id = find(PC_tbl.IsPC(non_drifting,1) == 1 ); % id of place cells 
   

    % get individuals
    Individual.Remap{f} = PC_tbl.Remap(pc);
    Individual.Stability{f} = max(PC_tbl.IsPC(pc,2:3).*PC_tbl.Stability(pc,:),[],2);
    Individual.Percentage(f,1) = length(Individual.Remap{f})/sum(PC_tbl.IsDrifting == 0); % percentage
    Individual.Percentage(f,2) =length(Individual.Remap{f}) ; % # pc
    Individual.Percentage(f,3) = sum(PC_tbl.IsDrifting == 0) ; % # all cell


    % get cohorts
    Cohort.Remap{discrimination(f)} = [Cohort.Remap{discrimination(f)}; Individual.Remap{f}];
    Cohort.Stability{discrimination(f)} = [Cohort.Stability{discrimination(f)}; Individual.Stability{f}];
    for ii = 1:2
        Cohort.StackedMap{discrimination(f),ii} = cat(3,Cohort.StackedMap{discrimination(f),ii}, RateMap{ii}(:,:,map_id));
    end
    % get pooled data
    All.Remap = [All.Remap;Individual.Remap{f}];
    All.Stability = [All.Stability; Individual.Stability{f}];
    All.Rate = [All.Rate; PC_tbl.TotalRate(pc)];

    for ii = 1:2
        All.StackedMap{ii} = cat(3,All.StackedMap{ii}, RateMap{ii}(:,:,map_id));
    end

    % get PV
    Individual.PV(f) = GetPV(RateMap{1}(:,:,map_id), RateMap{2}(:,:,map_id));
    Individual.RateMaps{f,1} = RateMap{1}(:,:,map_id);
    Individual.RateMaps{f,2} = RateMap{2}(:,:,map_id);

end

%% now calculate PV
All.PV = GetPV(All.StackedMap{1}, All.StackedMap{2});
for ii = 1:2
    [Cohort.PV(ii), ~]= GetPV(Cohort.StackedMap{ii,1}, Cohort.StackedMap{ii,2});
end

end