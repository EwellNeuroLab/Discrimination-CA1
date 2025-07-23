%% wrapping function for vector analysis - second version

function [All, Cohort, Individual]= WrapVectorRemap3_FINAL(workdir, discrimination, LightBin)

All.AngleDiff = {[]; []}; 
All.IsOrthogonal = {[]; []};
All.MeanRate = {[]; []};
All.TuningStrength = {[]; []};
All.TuningBin = {[]; []};
All.RewardTuning = {[]; []};
All.Match = {[]; []};
All.RewardLoc= {[];[]};
All.HasRewardField = [];
All.FieldDist = [];
All.FieldFiringPref = [];


All.Curves = [];
All.TunedCurves = [];
All.Length = [];
All.Angle = [];

All.CategoricalTuning = {[]; []};


Cohort.TuningBin= {[] []; [] []};
Cohort.IsOrthogonal = {[] []; [] []};
Cohort.AngleDiff = {[] []; [] []};

Individual.NRewardTuned = zeros(length(workdir),2,2);


for f = 1:length(workdir)  
    disp(workdir(f))
    clearvars -except f All workdir discrimination Individual LightBin Cohort
    load(strcat(workdir(f),"\processedData\HDAnalysis.mat"))
    load(strcat(workdir(f),"\processedData\PCAnalysis.mat"))
    load(strcat(workdir(f),"\processedData\FieldTbl.mat"))
    HDC_id =HD_table.cellID(HD_table.IsPC_HDC(:,1)==1);
    PC_id = PC_tbl.cellID(PC_tbl.IsPC(:,1)==1);
    [HDC_PC_id, ~, HD_PC_idx] = intersect(PC_id, HDC_id);


    
    %% get only HD cells
    onlyHD_id = HDC_id;
    onlyHD_id(HD_PC_idx) = []; % keep cells that are not spatially tuned


    %%
    All.CellComposition(f,1) = length(HDC_PC_id); % HDC & PC
    All.CellComposition(f,2) = length(onlyHD_id); % only HDC
    All.CellComposition(f,3) = length(PC_id)-length(HDC_PC_id); % only PC
    All.CellComposition(f,4) = length(HD_table.cellID(:,1)); % all
    All.Length = cat(1,All.Length , HD_table.RVL(HD_table.IsPC_HDC(:,1) == 1,:));
    All.Angle = cat(1,All.Angle,HD_table.RVMean(HD_table.IsPC_HDC(:,1) == 1,:));

    %% get mean eventrate
    MeanRate = GetMeanRateHDC(HDC_PC_id, HD_table, HDir_Rate);
    All.MeanRate{1} = [All.MeanRate{1}; MeanRate ];
    MeanRate = GetMeanRateHDC(onlyHD_id, HD_table, HDir_Rate);
    All.MeanRate{2} = [All.MeanRate{2}; MeanRate ];

    %% check for orthogonality 
    [AngDiff,IsOrthogonal] = GetAngularDifference(HDC_PC_id, HD_table);
    All.AngleDiff{1} = [All.AngleDiff{1} ; AngDiff];
    Cohort.AngleDiff{discrimination(f),1} = [Cohort.AngleDiff{discrimination(f),1}; AngDiff];
    All.IsOrthogonal{1} = [All.IsOrthogonal{1} ; IsOrthogonal];
    Cohort.IsOrthogonal{discrimination(f),1} = [Cohort.IsOrthogonal{discrimination(f),1}; IsOrthogonal];

    [AngDiff,IsOrthogonal] = GetAngularDifference(onlyHD_id, HD_table);
    All.AngleDiff{2} = [All.AngleDiff{2}; AngDiff];
    Cohort.AngleDiff{discrimination(f),2} = [Cohort.AngleDiff{discrimination(f),2}; AngDiff];
    All.IsOrthogonal{2} = [All.IsOrthogonal{2}; IsOrthogonal];
    Cohort.IsOrthogonal{discrimination(f),2} = [Cohort.IsOrthogonal{discrimination(f),2}; IsOrthogonal];

    %% get tuned vs untuned vector length for both types
    TuningStrength = GetTuningStrength(HD_table, HDC_PC_id);
    All.TuningStrength{1} = cat(1,All.TuningStrength{1}, TuningStrength );
    TuningStrength = GetTuningStrength(HD_table, onlyHD_id);
    All.TuningStrength{2} = cat(1,All.TuningStrength{2}, TuningStrength );

    %% get bin that cell is tuned to & get reward related tuning & analyze where those HDCs have place fields
    TunedBin = GetTuningBin(HDC_PC_id, HD_table);
    All.TuningBin{1} = [All.TuningBin{1}; TunedBin];
    Cohort.TuningBin{discrimination(f),1} = [Cohort.TuningBin{discrimination(f),1}; TunedBin];
    
    % reward tuning
    [IsRewardTuned, WhichReward, IsMatch] = GetRewardTuning(TunedBin,Rew.Bin, LightBin);
    All.RewardTuning{1} = cat(1,All.RewardTuning{1}, IsRewardTuned);
    All.Match{1} = cat(1,All.Match{1}, IsMatch);
    All.RewardLoc{1} = cat(1,All.RewardLoc{1}, WhichReward);

    [HasRewardField, FieldRewDist] = AnalyzeFieldHDCPC(IsRewardTuned, HDC_PC_id, Field_tbl, LightBin, Rew.Bin);
    All.HasRewardField = [All.HasRewardField; HasRewardField];
    All.FieldDist = [All.FieldDist; FieldRewDist];

    % get which reward wall the cell are tuned to
    [NReward, WhichReward] = GetWhichReward(TunedBin,Rew.Bin);
    Individual.NRewardTuned(f,:,1) =  NReward;

    % categorize all tuning
    CategoricalTuning = GetTuningComposition(TunedBin, Rew.Bin, LightBin);
    All.CategoricalTuning{1} = cat(1,All.CategoricalTuning{1}, CategoricalTuning);
    
    %% HDC only
    TunedBin = GetTuningBin(onlyHD_id, HD_table);
    All.TuningBin{2} = [All.TuningBin{2}; TunedBin];
    [IsRewardTuned, WhichReward, IsMatch] = GetRewardTuning(TunedBin,Rew.Bin, LightBin);
    All.RewardTuning{2} = cat(1,All.RewardTuning{2}, IsRewardTuned);
    All.Match{2} = cat(1,All.Match{2}, IsMatch);
    All.RewardLoc{2} = cat(1,All.RewardLoc{2}, WhichReward);
    Cohort.TuningBin{discrimination(f),2} = [Cohort.TuningBin{discrimination(f),2}; TunedBin];
   
    % categorize all tuning
    CategoricalTuning = GetTuningComposition(TunedBin, Rew.Bin, LightBin);
    All.CategoricalTuning{2} = cat(1,All.CategoricalTuning{2}, CategoricalTuning);

     % get which reward wall the cell are tuned to
    [NReward, WhichReward] = GetWhichReward(TunedBin,Rew.Bin);
    Individual.NRewardTuned(f,:,2) =  NReward;

    %% save curves
    All.Curves = cat(1,All.Curves, HDir_Rate(HD_table.IsPC_HDC(:,1) == 1,:,:));
    All.TunedCurves = cat(1, All.TunedCurves, HD_table.IsPC_HDC(HD_table.IsPC_HDC(:,1) == 1,2:3) == 1);

    
  
    
end


end