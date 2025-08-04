%% main script to identify cells that are tuned to heading-direction

main_path = "C:\Users\ewell\Desktop\TestCodeGitHub\"; % change this only

addpath(strcat(main_path, "Discrimination 2025 CodeBase\Heading_direction\GetHDCells"))
addpath(strcat(main_path, "Discrimination 2025 CodeBase\Heading_direction\GetHDCells"))
% define folders
rootdir = strings(2,1);
folders = strings(9,2);
rootdir(1) = strcat(main_path, "\Discrimination 2025 data\CA1 miniscope data\");
folders(:,1) = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];


rootdir(2) = rootdir(1);
folders(:,2) = ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ""];
nFiles  = [9 8]; %
%set parameters
filtSize = 5; % position data is filtered for heading direction calculation, measured in frames
binwidth = 45; % binwidth of heading direction in degree
framerate= 30; % camera sampling rate
repeat  = 2; % repeat shuffling
minShift = 1*framerate*60; % circular shifting cannot happen +/- this frame interval (change the first number that stands for minutes)
thresh.pctile = 95; % significance for shuffling
thresh.stability = 0.4; % cut-off for temporal stability of tuning
thresh.event = 10; % minimum number of events

%% loop on each session
for r= 1:2
    for f = 1:nFiles(r)
        workdir = strcat(rootdir(r), folders(f,r));
        disp(workdir)
        %% load files
        dlc_file = dir(fullfile(workdir, '\processedData\ProcessedPosition*.mat'));
        dlc= load(strcat(dlc_file.folder,'\', dlc_file.name));
        XY = dlc.XYT.Position;
        event = readtable(strcat(workdir, "EventFile.csv"));
        load(strcat(workdir, "\processedData\CaActivity.mat"), "IsDrifting", "States", "CaMatrix", "TrialFrames");
        load(strcat(workdir, "\processedData\PCAnalysis.mat"), "EventTime", "EventXY");
        [all_cell,~]=size(CaMatrix);
        CaMatrix(IsDrifting == 1,:) = []; % get rid of drifting traces
        
        cellID = 1:all_cell;
        cellID(IsDrifting == 1) = []; % to keep track of cell IDs

        %% get heading-direction with respect to a reference point
        warning("off", "all")
        [HDir, Rew, RefPoint, rotXY, theta] = GetHeadingDirection(XY, event, filtSize);
        warning("on", "all")
        %% bin heading-direction
        edges = -180:binwidth:180;
        [binned_HDir, binCenter] = BinHDir(HDir, edges);
        
        %% assign reward to bins
        Rew.Bin = zeros(length(Rew.Loc(:,1)),1);
        for i = 1:length(Rew.Loc(:,1))
            [~,Rew.Bin(i)] = min(abs(binCenter-Rew.Alpha(i)));
        end

        %% get HDir occupancy 
        framesToUse = cell(2,1); % frames to be used for each context
        for ctxt = 1:2
            framesToUse{ctxt}  = intersect(intersect(find(States.TrialPhase==1),find(States.Context == ctxt)),find(States.Run == 1)); %running (run = 1) & foraging (trial phase = 1)
        end
        Nbins = length(binCenter);
        HDirOccupancy = HDir_Occupancy(framesToUse, binned_HDir, Nbins, framerate); % 3 columns: ctxt 1, ctxt 2, full session

        %% get tuning curve and Rayleigh vector for each cell & calculate Pearsons between context
        [RV, HDir_Rate, EventHDir] = Get_HDirTuning(EventTime, binned_HDir, HDirOccupancy,Nbins, binCenter,edges);
        VectorRemap = GetVectorRemap(HDir_Rate);
        %% split session and calculate Pearson's between tuning curves: avg of 1st vs 2nd and even vs odd
        [framesSplitted, Splitted_labels] = SplitSession(TrialFrames, States);

        %% measure temporal stability of tuning curves by splitting data
        [Pearsons_stability, Pearsons, HDir_Rate_splitted, HDirOccupancy_splitted] = GetSplittedTuningCurve(EventTime, framesSplitted, binned_HDir, Nbins, framerate, CaMatrix, binCenter,edges);
        
        %% shuffle Ca events and recalculate vector length - get 95th %ile
        disp("Shuffling Ca Events...")
        tic;
        RVL_distribution_events = ShuffleCaEvents(CaMatrix,repeat, minShift, framesToUse, binned_HDir, HDirOccupancy, Nbins, binCenter, edges);
        toc;
        %% shuffle heading direction and recalculate vector length - get 95th %ile
        disp("Shuffling Hdir...")
        tic;
        RVL_distribution_HDir = ShuffleHD(HDir, minShift, repeat, edges, framesToUse, Nbins, framerate, EventTime, binCenter);
        toc;

        %% get HD cells and create output table
        HD_table = GetHDCells(RV,RVL_distribution_events,RVL_distribution_HDir, CaMatrix, cellID, VectorRemap, Pearsons_stability, thresh);
        
        %% save data
        if exist(strcat(workdir, "/processedData/HDanalysis.mat"), "file")
            delete(strcat(workdir, "/processedData/HDanalysis.mat"))
        end
            save(strcat(workdir, "/processedData/HDanalysis.mat"), "HD_table", "RV", "HDir_Rate",  "HDirOccupancy", "EventHDir","binned_HDir", "edges", "binCenter", "Rew", "RefPoint", "rotXY", "theta")
    end

end
