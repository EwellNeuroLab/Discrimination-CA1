%% function for reconstruction analysis based on Sarel et al. An additional criteria for directional tuning. 


function [placeHD_idx, error_HD, error_RateMap] = ReconstructionAnalysis_Sarel2017(States, binned_HDir, HDir_Rate, BinnedXY, RateMap)

% 1. get frames of interests for each context
framesToUse = cell(2,1); % frames to be used for each context
for ctxt = 1:2
    framesToUse{ctxt}  = intersect(intersect(find(States.TrialPhase==1),find(States.Context == ctxt)),find(States.Run == 1)); %running (run = 1) & foraging (trial phase = 1)
    rmv_idx = find(isnan(BinnedXY(framesToUse{ctxt},1)) | isnan(binned_HDir(framesToUse{ctxt})));
    framesToUse{ctxt}(rmv_idx) = [];% remove nans
end


% 2. calculate occupancy map
probability_xyHD = cell(2,1);
for ctxt = 1:2
    probability_xyHD{ctxt} = accumarray([BinnedXY(framesToUse{ctxt},:) binned_HDir(framesToUse{ctxt})],1, [20,20,8]);
    % normalize it to 1 (probability matrix)
    probability_xyHD{ctxt}= probability_xyHD{ctxt}./sum(probability_xyHD{ctxt},"all");
end

% 3. reconstruct place tuning assuming pure goal direction cell
Reconstructed_RateMap = cell(2,1);
Reconstructed_RateMap{1} = nan(size(RateMap{1}));
Reconstructed_RateMap{2} = nan(size(RateMap{2}));
Reconstructed_HD = zeros(size(HDir_Rate));
[~,~,Ncells]=size(Reconstructed_RateMap{1});
error_RateMap = zeros(length(Ncells),2);
error_HD = zeros(length(Ncells),2);
placeHD_idx = zeros(length(Ncells),2);

for c=1:Ncells
    for ctxt = 1:2

        Reconstructed_RateMap{ctxt}(:,:,c) = sum(probability_xyHD{ctxt}.*reshape(HDir_Rate(c,:,ctxt), 1, 1, 8),3)./sum(probability_xyHD{ctxt}, 3); % tested, gives the same result as with a for loop on the numerator
        Reconstructed_HD(c,:,ctxt) = squeeze(sum(probability_xyHD{ctxt}.*RateMap{ctxt}(:,:,c), [1 2], 'omitnan')./sum(probability_xyHD{ctxt}, [1 2])); % tested with for loop, same result
        
        % 4. Calculate normalized mean squared error between observed and reconstructed
        O= RateMap{ctxt}(:,:,c)./max(RateMap{ctxt}(:,:,c), [], 'all', 'omitnan');
        E = Reconstructed_RateMap{ctxt}(:,:,c)./max(Reconstructed_RateMap{ctxt}(:,:,c), [], 'all', 'omitnan');
        error_RateMap(c,ctxt) = mean((O-E).^2, 'omitnan')/(max(O, [], 'omitnan')-min(O, [], 'omitnan')); % error assuming pure directional tuning
        
        O = HDir_Rate(c,:,ctxt)./max(HDir_Rate(c,:,ctxt), [], 'all', 'omitnan');
        E = Reconstructed_HD(c,:,ctxt)./max(Reconstructed_HD(c,:,ctxt), [], 'all', 'omitnan');
        error_HD(c,ctxt) = mean((O-E).^2, 'omitnan')/(max(O, [], 'omitnan')-min(O, [], 'omitnan')); % error assuming pure place tuning

        % 5. calculate place/hd index
        placeHD_idx(c,ctxt) = error_HD(c,ctxt)/error_RateMap(c,ctxt);
    end
end


end