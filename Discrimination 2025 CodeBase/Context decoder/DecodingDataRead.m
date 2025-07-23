%% script to read data and get cells and frames that are going to be used for the analysis

%% define data folders
% modified by justin
rootdir = "Z:\Lab\Gergely\8 port maze\PatternSeparationProject\MiniscopeDecoding_InputData\";
%rootdir = "";
folders = ["M119"+filesep "M120"+filesep "M292"+filesep "M319"+filesep ...
    "M231"+filesep "M314"+filesep "M316"+filesep "M318"+filesep "M210"+filesep];
sessions = ["early", "trained", "grouping"];

SelectedSession = sessions(2); % please run the decoding on all 3 sessions - but start with session 2

if ~strcmp(SelectedSession, "trained")
   folders(end)=  []; % M210 only has trained session day
end

%% read data from each folder

for f = 1:length(folders)
    a= load(strcat(rootdir, folders(f), SelectedSession, filesep+"CaActivity.mat")); % contains the binarized Ca events and all other important information
    pc = load(strcat(rootdir, folders(f), SelectedSession, filesep+"PCAnalysis.mat")); % Contains a table that tells you which cells to use (only PCs)

    % get the frames that will be used - running state during the foraging
    % phase of the trials, and context label is assigned (1 or 2). Don't
    % use ctxt labels with 0s or -1s.
    %% add resting state (resting = 1) rest before first mobility is excluded
    a = GetRestState(a);
    % ONLY RUNNING OR ALL TIMES?
    %FramesToUse = intersect(intersect(find(a.States.TrialPhase==1),find(a.States.Context > 0)),find(a.States.Run == 1));
    %FramesToUse = intersect(intersect(find(a.States.TrialPhase==1),find(a.States.Context > 0)),find(a.States.Rest == 1));
    
    FramesToUse = intersect(intersect(find(a.States.TrialPhase==1),find(a.States.Context > 0)),find((a.States.Run == 1) | (a.States.Rest == 1)));

    %FramesToUse = intersect(find(a.States.TrialPhase==1),find(a.States.Context > 0));
    
    NOTFrames = setdiff(FramesToUse,1:length(a.States.Context));
    
    %CellsToUse = find(pc.PC_tbl.IsPC(:,1) ==1); % for place cells only
    CellsToUse = find(pc.PC_tbl.IsDrifting == 0); % for all cells
    %CellsToUse = find((pc.PC_tbl.IsDrifting == 0) &(pc.PC_tbl.IsPC(:,1) ==0)); %exlcude pc

    % remapping metrics of cells
    corr_coef=pc.PC_tbl.Remap(CellsToUse);
    rate = pc.PC_tbl.TotalRate(CellsToUse);
    
    %a_rate =  smoothdata(a.CaMatrix(CellsToUse,:),2,"gaussian",[180,180])';
    dt = 60; % number of frames to bin over
    
    a_rate =  a.CaMatrix(CellsToUse,:)';

    % MASK THE TIMES WE EXCLUDE
    a_rate(NOTFrames,:) = 0;

    for i = 1:dt:size(a_rate,1)-dt
        a_rate(i:i+dt-1,:) = repmat(sum(a_rate(i:i+dt-1,:),1),dt,1);
    end

    a_use = a_rate(FramesToUse,:);
    context_use = a.States.Context(FramesToUse);

    % validates the above statementes that only the frames we want are used
    % and there is a calcium data point for each
    assert(size(a_use,1)==length(context_use));

    save(folders(f)+"binned_activity_decode_trained_runrest_allcells_allframes.mat","a_use","context_use","corr_coef","rate","-mat");
end


function a = GetRestState(a)
NTrial = length(a.TrialFrames(:,1));
a.States.Rest = zeros(length(a.States.Run),1);
for i = 1:NTrial
    ForagingStart = a.TrialFrames(i,1);
    ForagingStop = a.TrialFrames(i,2);
    TrialRest = a.States.Run(ForagingStart:ForagingStop) == 0; % time when mouse is resting during the trial
    RestGaps = find(diff(find(TrialRest == 1))  >1);
    if ~isempty(RestGaps)
        TrialRest(1:RestGaps(1)+1) = 0;
    end
    a.States.Rest(ForagingStart:ForagingStop) = TrialRest;
end
end



