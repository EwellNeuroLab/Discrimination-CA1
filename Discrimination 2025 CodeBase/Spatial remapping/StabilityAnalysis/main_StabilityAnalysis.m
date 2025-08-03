%% Gergely Tarcsay, 2024. Main analysis to classify cells as spatially stable cells after shuffling.

%% 0. load data & set params
main_path = "G:\"; % change this according to your path

rootdir = strcat(main_path, "\CA1 miniscope data"); 
addpath(strcat(main_path, "Discrimination 2025 CodeBase\Spatial remapping\StabilityAnalysis"))

folders = cell(2,1); % folder struct for D1 and G1 cohorts

% D1 cohort
folders{1} = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];

% G1 cohort
folders{2}= ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ];


% set parameters here
framerate=  30; % camera framerate
filterSize = 1.5; % filter size of map filter, measured in bins
minShift = 1*framerate*60; % circular shifting cannot happen +/- this frame interval (change the first number that stands for minutes)
repeat = 500; % repeat shuffling n times
thresh.pctile = 95; % correlation coefficient must exceed this %ile after shuffling
thresh.r = 0.4; % stability criteria
thresh.event = 10; % activity criteria



for coh = 1:2
for f = 1:length(folders{coh})

clearvars -except rootdir folders framerate filterSize minShift repeat thresh f coh nFiles
workdir = strcat(rootdir,folders{coh}(f), "\processedData\");
disp(workdir)
load(strcat(workdir,"\CaActivity.mat"))



%% remove rows from drifting cell for faster performance
[all_cell, ~]  = size(CaMatrix); 
cellID = 1:all_cell;
cellID(IsDrifting == 1) = []; % to keep track of cell IDs
CaMatrix(IsDrifting == 1,:) = [];
[N_cell, Nframes] = size(CaMatrix);

%% 1. Calculate spatial rate map (event/min) for running epochs, context 1 and 2 and Pearson's correlation between them 
framesToUse= cell(2,1);
RateMap = cell(1,2);
EventTime = cell(N_cell, 2);
EventXY  =cell(N_cell, 2);
Occupancy = cell(1,2);
for ctxt = 1:2
    framesToUse{ctxt}  = intersect(intersect(find(States.TrialPhase==1),find(States.Context == ctxt)),find(States.Run == 1)); % only running & foraging!
    [RateMap{ctxt}, EventXY(:,ctxt), EventTime(:,ctxt), Occupancy{ctxt}] = MakeRateMap(BinnedXY, CaMatrix, XYedges, framesToUse{ctxt}, framerate, filterSize);
end
[Pearsons, ~] = GetPearsons(RateMap{1}, RateMap{2});

%% 2. Split data into 1st half and 2nd half; even and odd for both contexts
[framesSplitted, Splitted_labels] = SplitSession(TrialFrames, States);

%% 3. Calculate Pearson's correlation, take the average of 1st vs 2nd and even vs odd
[RateMap_splitted,EventTime_splitted, EventXY_splitted, Occupancy_splitted] = GetSplittedRateMaps(BinnedXY, CaMatrix, XYedges, framesSplitted, framerate, filterSize, N_cell); % see function below

[Pearsons_within, Fishers_within] = GetSplittedPearsons(RateMap_splitted, N_cell); % see function below
% take the average - final results is two Pearsons for each cell in each context
Pearsons_true= squeeze(mean(Pearsons_within, 2, 'omitnan')); 
Fishers_true = real(squeeze(mean(Fishers_within, 2, 'omitnan')));

%% 4. Shuffle onset, recalculate maps and Pearson's between maps for stability

maxShift = Nframes-minShift;
K  = randi([minShift maxShift], repeat,1);
Fishers_shuffled = zeros(N_cell,2,repeat); % for statistics we only need Fisher's z 


for i = 1:repeat
    disp(strcat(num2str(i), "\", num2str(repeat)))
    CaMatrix_shuffled = circshift(CaMatrix,K(i),2);
    [RateMap_shuff,~, ~, ~] = GetSplittedRateMaps(BinnedXY, CaMatrix_shuffled, XYedges, framesSplitted, framerate, filterSize, N_cell); % see function below
    [~, Fishers_within_shuff] = GetSplittedPearsons(RateMap_shuff, N_cell); % see function below
    Fishers_shuffled(:,:,i) = real(squeeze(mean(Fishers_within_shuff, 2, 'omitnan')));
end


%% 5. Create table wether cell is 1) non-drifting 2) active 3) stable 4) significantly stable. If all yes -> PC

PC_tbl = GetPlaceCells(all_cell, cellID, Fishers_shuffled, Fishers_true, Pearsons_true, Pearsons, CaMatrix, IsDrifting, thresh,framerate);

if exist(strcat(workdir, "PCAnalysis.mat"),"file")
    delete(strcat(workdir, "PCAnalysis.mat"))
end
save(strcat(workdir, "PCAnalysis.mat"), "PC_tbl", "RateMap", "EventXY", "EventTime", "Occupancy", "Pearsons", "Pearsons_within", "thresh", "repeat", "RateMap_splitted", "framesToUse")

end
end

function [RateMap_splitted,EventTime_splitted, EventXY_splitted, Occupancy_splitted] = GetSplittedRateMaps(BinnedXY, CaMatrix, XYedges, framesSplitted, framerate, filterSize, N_cell)

RateMap_splitted = cell(4,2);
EventTime_splitted = cell(N_cell,8);
EventXY_splitted = cell(N_cell,8);
Occupancy_splitted = cell(4,2);
counter = 1;

for s = 1:4 % loop on splitted session: 1st, 2nd, odd, even
    for ctxt = 1:2 % loop on context
        [RateMap_splitted{s,ctxt}, EventXY_splitted(:,counter), EventTime_splitted(:,counter), Occupancy_splitted{s,ctxt}] = MakeRateMap(BinnedXY, CaMatrix, XYedges, framesSplitted{s,ctxt}, framerate, filterSize);
        counter = counter +1;
    end
end

end


function [Pearsons_within, Fishers_within] = GetSplittedPearsons(RateMap_splitted, N_cell)

    Pearsons_within = zeros(N_cell,2,2);
    Fishers_within = zeros(N_cell,2,2);
    for i  =1:2 % loop on 1st vs 2nd; even vs odd
        for ctxt = 1:2 % loop on context
            [Pearsons_within(:,i, ctxt), Fishers_within(:,i, ctxt)] = GetPearsons(RateMap_splitted{1+(i-1)*2,ctxt}, RateMap_splitted{2+(i-1)*2,ctxt});
        end
    end
    


end


