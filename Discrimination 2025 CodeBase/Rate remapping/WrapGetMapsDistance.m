%% function to get maps of fields at different distances


% wrapping function analyze rate overlap
workdir = "D:\Grouping First\M314\Training_Separation_D5\";

load(strcat(workdir,"\processedData\FieldTbl.mat"))
load(strcat(workdir,"\processedData\FieldClustering.mat"))
load(strcat(workdir,"\processedData\PlaceMaps.mat"))
load(strcat(workdir,"\processedData\CaActivity.mat"), "BinnedXY")
event = readtable(strcat(workdir,"EventFile.csv"));


edges = 0:2.50000001:22.50000001; % from 0 to 40 cm
MapsDistance = cell(length(edges)-1,1);

%% get smallest distance
RewDist =min(Field_tbl.RewDist,[],2);


%% calculate rank of fields
diffs = [1; diff(Field_tbl.cell_ID)];
Rank = zeros(length(RewDist),1);
counter = 1;
for j = 1:length(diffs)
    if diffs(j) == 0
        counter = counter+1;
        Rank(j) = counter;
    else
        counter =1;
        Rank(j) = 1;
    end
        

end

%% get reward location for visualization
[TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
[Correct, ~, ~, ~, ~, ~, ~] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);


%% get goal-direction
RZ_XY  = GetRewardLocation(BinnedXY, event, Correct, context);


for i = 1:length(edges)-1

    idx = find(RewDist>= edges(i) & edges(i+1) > RewDist);
    
    idx_cellID = Field_tbl.cell_ID(idx);
    idx_mapID = zeros(length(idx_cellID),1); % the actual id for the place map
    idx_Rank  =  Rank(idx);
    MapsDistance{i} = zeros(20,20,length(idx_cellID));
    for j = 1:length(idx_cellID)
        [~, idx_mapID(j)] = intersect(cell_ID, idx_cellID(j));
        MapsDistance{i}(:,:,j) = ActivityRate_full{idx_mapID(j)}.*mask{idx_mapID(j)}(:,:,idx_Rank(j));
    end
end


%% now save maps for the different cases
for i = 1:length(edges)-1
    if ~isempty(MapsDistance)
        out = strcat(workdir, "\processedData\FieldDistance_", num2str(round(edges(i)*2)),".pdf");
        if exist(out,"file")
            delete(out)
        end
        [~,~,Nmap] = size(MapsDistance{i});
        for m = 1: Nmap
        figure("Visible","off")
            f=imagesc(MapsDistance{i}(:,:,m));
            hold on
            for j = 1:length(RZ_XY(:,1))
                plot(RZ_XY(j,1), RZ_XY(j,2), "mp", "MarkerSize",15, "MarkerFaceColor","m")
            end
            box off
            axis square
            axis off
            colormap jet
            set(f, "AlphaData", ~isnan(MapsDistance{i}(:,:,m)))

            exportgraphics(gcf, out, "Append", true );
            close(gcf)
        end
    end

end

