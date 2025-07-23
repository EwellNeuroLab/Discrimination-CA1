%% function to generate place field table by applying the masks.


%% main function to create a table with the most important field informations
MaxRZRadius = 5; % measured in bins


%% load GUI output & onset file
rootdir = strings(2,1);
folders = strings(9,2);
rootdir(1) = "F:\Included miniscope Mice\";
folders(:,1) = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];

rootdir(2) = "D:\Grouping First\";
folders(:,2) = ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ""];

Nfiles= [9 8];
for r = 1:2
    for f = 1:Nfiles(r)

        clearvars -except rootdir folders Nfiles r f MaxRZRadius
        workdir = strcat(rootdir(r),folders(f,r));
        disp(workdir)
        fields  = load(strcat(workdir, "processedData\FieldClustering.mat"));
        onset = load(strcat(workdir, "processedData\PCAnalysis.mat"));
        maps = load(strcat(workdir,"processedData\PlaceMaps.mat"));
        event = readtable(strcat(workdir,"EventFile.csv"));
        caActivity = load(strcat(workdir, "processedData\CaActivity.mat"));


        [Field_tbl, FieldMap_full, FieldMap_sess] = ApplyMask(maps, fields);

        %% get number of events

        [EventCounter, EventTime, EventPercentage] = CountFieldEvents(FieldMap_full, onset, Field_tbl, 25);
        Field_tbl.("N_events") = EventCounter;
        Field_tbl.("T_events") = EventTime;
        Field_tbl.("Perc_events") =  EventPercentage;


        %% get distance from reward ports
        [RewDistance, RewLoc] = GetRewDistance(event, Field_tbl, caActivity.BinnedXY);
        Field_tbl.("RewDist") = RewDistance;

        %% classify fields as reward field or out-of-field

        IsRZ = zeros(length(Field_tbl.field_ID),1);

        for i = 1:length(RewLoc(1,:))
            IsRZ(Field_tbl.RewDist(:,i) <= MaxRZRadius) = i;
        end
        Field_tbl.("RewZone") = IsRZ;


        %% get rate overlap (RoL) for peak and mean
        Field_tbl.("ROLMean") = GetRateOverlap(Field_tbl.MeanRate(:,1), Field_tbl.MeanRate(:,2));
        Field_tbl.("ROLPeak") = GetRateOverlap(Field_tbl.PeakRate(:,1), Field_tbl.PeakRate(:,2));


        %% get firing preference of RZ fields - in which context they like to fire?
        Field_tbl.("FiringPrefMean") = GetFiringPref(Field_tbl.MeanRate(:,1),Field_tbl.MeanRate(:,2),Field_tbl.RewZone);
        Field_tbl.("FiringPrefPeak") = GetFiringPref(Field_tbl.PeakRate(:,1),Field_tbl.PeakRate(:,2),Field_tbl.RewZone);


        %% now select fields that has at leasn two events and 1 event/min at least in one context
        Field_tbl.IsActive(Field_tbl.PeakRate_All >= 1 & Field_tbl.N_events > 1) = 1;

        if exist(strcat(workdir,"\processedData\FieldTbl.mat"), 'file')
            delete(strcat(workdir,"\processedData\FieldTbl.mat"));
        end

        save(strcat(workdir,"\processedData\FieldTbl.mat"), "Field_tbl")
    end
end