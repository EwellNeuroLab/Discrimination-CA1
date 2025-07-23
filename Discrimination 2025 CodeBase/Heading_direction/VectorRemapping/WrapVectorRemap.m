%% wrapping function for vector remap analysis
function [All, Cohort]= WrapVectorRemap(workdir, discrimination)

All.CellComposition = zeros(length(workdir),4); %
All.OrthogonalHDC = zeros(length(workdir),2);
All.VectorRemap = [];
All.SpatialRemap =[];
All.Curves = [];
All.Length = [];
All.Angle = [];
All.Context = [];
All.Bin = [];
All.Tuning = cell(2,1); % ctxt 1 and 2
All.TunedLength =[];
All.UnTunedLength = [];
All.RewardTuned_all = zeros(length(workdir),4);
All.RewardTuned_ortho = zeros(length(workdir),4);
All.RewardTuned_neutral = zeros(length(workdir),4);

Cohort.OrthogonalHDC = nan(length(workdir),4);

for f = 1:length(workdir)
    clearvars -except f All workdir discrimination Cohort
    load(strcat(workdir(f),"\processedData\HDAnalysis.mat"))
    load(strcat(workdir(f),"\processedData\PCAnalysis.mat"))


    HDC_id =HD_table.cellID(HD_table.IsPC_HDC(:,1)==1);
    PC_id = PC_tbl.cellID(PC_tbl.IsPC(:,1)==1);
    HDC_PC = intersect(PC_id, HDC_id);
    [~,HDCPC_idx, ~] = intersect(PC_tbl.cellID, HDC_PC);
    All.CellComposition(f,1) = length(HDC_PC); % HDC & PC
    All.CellComposition(f,2) = length(HDC_id)-length(HDC_PC); % only HDC
    All.CellComposition(f,3) = length(PC_id); % only PC
    All.CellComposition(f,4) = length(HD_table.cellID(:,1)); % all


    %% is tuning orthogonal? (only one context)
    All.OrthogonalHDC(f,1) = nnz(sum(HD_table.IsPC_HDC(:,2:3),2)==1);
    All.OrthogonalHDC(f,2) = length(HDC_id);
    Cohort.OrthogonalHDC(f,(2*discrimination(f)-1)) = nnz(sum(HD_table.IsPC_HDC(:,2:3),2)==1);
    Cohort.OrthogonalHDC(f,2*discrimination(f)) = length(HDC_id);

    %% get remapping value
    All.VectorRemap = [All.VectorRemap ; HD_table.RemapValue(HD_table.IsPC_HDC(:,1)==1)];

    %% get Pearsons of PCs that are also HDCs
    All.SpatialRemap =[All.SpatialRemap; PC_tbl.Remap(HDCPC_idx)];


    %% collect all tuning curves
    All.Curves = cat(1,All.Curves, HDir_Rate(HD_table.IsPC_HDC(:,1) == 1,:,:));
    All.Length = cat(1,All.Length , HD_table.RVL(HD_table.IsPC_HDC(:,1) == 1,:));
    All.Angle = cat(1,All.Angle,HD_table.RVMean(HD_table.IsPC_HDC(:,1) == 1,:));
    All.Context = cat(1,All.Context,HD_table.IsPC_HDC(HD_table.IsPC_HDC(:,1) == 1,2:3));
    All.Bin = cat(1,All.Bin,HD_table.IsPC_HDC(HD_table.IsPC_HDC(:,1) == 1,2:3));

    %% now group tuned and untuned lengths

    All.TunedLength= [All.TunedLength; HD_table.RVL(HD_table.IsPC_HDC(:,2) == 1 & HD_table.IsPC_HDC(:,3) == 0,1)];
    All.UnTunedLength= [All.UnTunedLength; HD_table.RVL(HD_table.IsPC_HDC(:,2) == 1 & HD_table.IsPC_HDC(:,3) == 0,2)];

    All.TunedLength= [All.TunedLength; HD_table.RVL(HD_table.IsPC_HDC(:,2) == 0 & HD_table.IsPC_HDC(:,3) == 1,2)];
    All.UnTunedLength= [All.UnTunedLength; HD_table.RVL(HD_table.IsPC_HDC(:,2) == 0 & HD_table.IsPC_HDC(:,3) == 1,2)];

    %% now get reward-tuned HDCs - all cells
    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,2)==1, 1); % ctxt 1
    
    for k = 1:length(Rew.Bin)
        All.RewardTuned_all(f,k) = length(find(TunedBin == Rew.Bin(k)));
    end

    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,3)==1,2); % ctxt 2
    for k = 1:length(Rew.Bin)
        All.RewardTuned_all(f,k+2) = length(find(TunedBin == Rew.Bin(k)));
    end

    %% now do the same but only with orthogonal cells (tuned only in one context)
    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,2)==1 & HD_table.IsPC_HDC(:,3)==0, 1); % ctxt  1
    
    for k = 1:length(Rew.Bin)
        All.RewardTuned_ortho(f,k) = length(find(TunedBin == Rew.Bin(k)));
    end

    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,3)==1 & HD_table.IsPC_HDC(:,2)==0 ,2);
    for k = 1:length(Rew.Bin)
        All.RewardTuned_ortho(f,k+2) = length(find(TunedBin == Rew.Bin(k)));
    end

    %% now do the same but only for cells that are tuned in both contexts
    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,2)==1 & HD_table.IsPC_HDC(:,3)==1, 1); % ctxt  1
    
    for k = 1:length(Rew.Bin)
        All.RewardTuned_neutral(f,k) = length(find(TunedBin == Rew.Bin(k)));
    end

    TunedBin = HD_table.RVMeanBin(HD_table.IsPC_HDC(:,3)==1 & HD_table.IsPC_HDC(:,2)==1 ,2);
    for k = 1:length(Rew.Bin)
        All.RewardTuned_neutral(f,k+2) = length(find(TunedBin == Rew.Bin(k)));
    end

end
for i = 1:2
    All.Tuning{i}= All.Angle(All.Context(:,i)==1,i);
end
end
