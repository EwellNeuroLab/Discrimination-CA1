%% main script for mismatch analysis - use only correct trials

framerate = 30;
filterSize = 1.5;
MaxRZRadius = 5;

rootdir = strings(2,1);
folders = strings(9,2);
rootdir(1) = "F:\Included miniscope Mice\";
folders(:,1) = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];
rootdir(2) = "D:\Grouping First\";
folders(:,2) = ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ""];

Nfiles =  [9 8];
for r = 1:2
    for f = 1:Nfiles(r)

        workdir = strcat(rootdir(r),folders(f,r));
disp(workdir)
load(strcat(workdir, "processedData\CaActivity.mat"), "States", "CaMatrix", "BinnedXY", "XYedges")
load(strcat(workdir, "processedData\PCAnalysis.mat"), "PC_tbl")
load(strcat(workdir, "processedData\FieldClustering.mat"), "mask")
load(strcat(workdir, "processedData\PlaceMaps.mat"), "ActivityRate_full")
event = readtable(strcat(workdir,"EventFile.csv"));

%% keep only traces of PCs
PC_id = PC_tbl.cellID(PC_tbl.IsPC(:,1) == 1);
CaMatrix_PC = CaMatrix(PC_id,:);

%% get frames to use - foraging, running, ctxt 1 and 2
framesToUse = cell(2,1);
RateMap_sess = cell(length(PC_id),2);
EventTime = cell(length(PC_id),2);
EventXY = cell(length(PC_id),2);
for ctxt = 1:2
    framesToUse{ctxt} = intersect(intersect(intersect(find(States.TrialPhase==1),find(States.Context == ctxt)),find(States.Run == 1)), find(States.TrialType == 2));

    InCorrectFrames = find(States.Outcome(framesToUse{ctxt})~=1);
    framesToUse{ctxt}(InCorrectFrames) = []; % keep only correct trials
    % get rate map
    [RateMap, EventXY(:,ctxt), EventTime(:,ctxt), ~] = MakeRateMap(BinnedXY, CaMatrix_PC, XYedges, framesToUse{ctxt}, framerate, filterSize);
    RateMap_sess(:,ctxt) = num2cell(RateMap, [1 2]);
end

%% now create map for full session
framesAll= intersect(intersect(intersect(find(States.TrialPhase==1),find(States.Context  >0)),find(States.Run == 1)),find(States.TrialType == 2)) ;
[RateMap_full, ~, ~, ~] = MakeRateMap(BinnedXY, CaMatrix_PC, XYedges, framesAll, framerate, filterSize);


%% apply field masks on the place maps
maps.ActivityRate_full = squeeze(num2cell(RateMap_full, [1 2]));
maps.ActivityRate_sess = RateMap_sess;
fields.mask = mask;
fields.cellID = PC_id;
[Mismatch_tbl, FieldMap_full, ~] = ApplyMask(maps, fields);

%% count number of events in each field
onset.PC_tbl = PC_tbl;
onset.EventXY = EventXY;
onset.EventTime = EventTime;
[EventCounter, EventTime, EventPercentage] = CountFieldEvents_MisMatch(FieldMap_full, onset, 25);
Mismatch_tbl.("N_events") = EventCounter;
Mismatch_tbl.("T_events") = EventTime;
Mismatch_tbl.("Perc_events") =  EventPercentage;


%% get distance from reward ports
[RewDistance, RewLoc] = GetRewDistance(event, Mismatch_tbl, BinnedXY);
Mismatch_tbl.("RewDist") = RewDistance;

%% classify fields as reward field or out-of-field

IsRZ = zeros(length(Mismatch_tbl.field_ID),1);

for i = 1:length(RewLoc(1,:))
    IsRZ(Mismatch_tbl.RewDist(:,i) <= MaxRZRadius) = i;
end
Mismatch_tbl.("RewZone") = IsRZ;

% get firing preference
Mismatch_tbl.("FiringPrefMean") = GetFiringPref(Mismatch_tbl.MeanRate(:,1),Mismatch_tbl.MeanRate(:,2),Mismatch_tbl.RewZone);
Mismatch_tbl.IsActive(Mismatch_tbl.PeakRate_All >= 1 & Mismatch_tbl.N_events > 1) = 1;


if exist(strcat(workdir,"\processedData\MismatchTbl.mat"), 'file')
    delete(strcat(workdir,"\processedData\MismatchTbl.mat"));
end

save(strcat(workdir,"\processedData\MismatchTbl.mat"), "Mismatch_tbl")

    end
end






