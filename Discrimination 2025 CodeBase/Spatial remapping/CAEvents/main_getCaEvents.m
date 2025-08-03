%% main script to detect onsets and split them based on rest/run and ctxt. Gergely Tarcsay, 2025. To run this properly, make sure that the main_path is set.
%% input data: output of minian (.nc file containing spatial and temporal information for each unit); dlc processed position that contains miniscope frame timestamps as well;
%% and finally, IsDrifting mat file that is the output of the Drift GUI (DetectDrift) to exclude units with unstable Ca dynamics
%% 0. Set folders and directory and params

main_path = "G:\"; % change this according to your path
rootdir = strcat(main_path, "\CA1 miniscope data"); 
addpath(strcat(main_path, "Discrimination 2025 CodeBase\Spatial remapping\CaEvents"))

folders = cell(2,1); % folder struct for D1 and G1 cohorts

% D1 cohort
folders{1} = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];

% G1 cohort
folders{2}= ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ];

% set parameters here
XYfilter = 5; % filter for speed calculation; measured in frames
binSizeCm = 2; % bin size
ArenaSizeCm = 40; % size of the arena
v_thresh = 2;  % speed threshold

RandomForagingExperiment = 0; % 0 for discrimination/grouping; 1 for random food foraging control experiments

%% 1. Load calcium data, drifting labels
for coh = 1:2
    for f = 1:length(folders{coh})
        
        clearvars -except rootdir folders XYfilter binSizeCm ArenaSizeCm v_thresh f nFiles coh RandomForagingExperiment
        workdir = strcat(rootdir,folders{coh}(f));
        disp(workdir)
        disp("Loading calcium data...")
        out  = strcat(workdir, "processedData\");
        [c,s,a,unit_id] = ReadNCData(workdir);
    
        if exist(strcat(out, "\DriftDetection.mat"), "file")
            load(strcat(out, "\DriftDetection.mat"));
        else
            IsDrifting = zeros(length(unit_id),1); % otherwise no drifting
        end
    
        %% 2. Load position data and calculate speed and event file
        disp("Loading position data...")
        dlc_file = dir(fullfile(out, '\ProcessedPosition*.mat'));
        dlc= load(strcat(dlc_file.folder,'\', dlc_file.name));
        XY = dlc.XYT.Position;
        ts = dlc.XYT.Timestamp(:,2:3);
        framerate = dlc.Info.camFrameRate;
    
        % filter position and recalculate speed - speed measured on body not on
        % head
        tailbase_xy = dlc.XYT.TailBase;
        filtX = movmean(tailbase_xy(:,1), XYfilter);
        filtY = movmean(tailbase_xy(:,2), XYfilter);
        vX = gradient(filtX)*framerate;
        vY = gradient(filtY)*framerate;
        v = sqrt(vX.^2+vY.^2);
    
        %% 3. Detect onsets - returns as an N_cell x N_camera frame matrix
        disp("Detecting Ca activity...")
        [CaMatrix, IsNormalDist] = GetCaActivity(s,ts,IsDrifting);
    
        %% 4. Assign camera frames to different behaviorally relevant states (run/rest, context 1/2, foraging/reward, training/testing, correct/incorrect)
        disp("Classifying behavioral states...")
        event = readtable(strcat(workdir, "EventFile.csv")); %load event file
    
        if RandomForagingExperiment == 0
            [States, TrialFrames]  = AssignFramesToStates(event, v, v_thresh);
        else
            [States, TrialFrames] = AssignFramesToStates_RF(event, v, v_thresh);
        end
    
        %% 5. Bin position data
        disp("Binning position...")
        [BinnedXY, XYedges] = BinPosition(XY, ArenaSizeCm, binSizeCm);
    
        %% 6. Save data for downstream analysis
        if exist(strcat(out, "CaActivity.mat"),"file")
            delete(strcat(out, "CaActivity.mat"))
        end
        disp("Saving data...")
        save(strcat(out, "CaActivity.mat"), "IsDrifting", "v", "XY", "BinnedXY", "XYedges", "States", "TrialFrames", "CaMatrix", "IsNormalDist")
    
    end

end


