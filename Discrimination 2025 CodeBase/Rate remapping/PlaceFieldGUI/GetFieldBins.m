%% function to get bins that are included in analysis

function [fieldBins, fieldBinsUpsampled] = GetFieldBins(I, rate_thresh, peakRate)

I0 = I;
%% get bins that exceed rate threshold
Npeak = length(peakRate);
[peakRate, ~] = sort(peakRate, 'descend');
FieldX =[];
FieldY = [];
[r,c] = size(I);
for i = 1:Npeak
    mask = zeros(r*c,1);
    threshold = peakRate(i)*rate_thresh;
    CC = bwconncomp(I >= threshold);
    peak_idx = find(I == peakRate(i));
    for j= 1:CC.NumObjects
        if ismember(peak_idx, CC.PixelIdxList{j})
            mask(CC.PixelIdxList{j}) = 1;
            I(CC.PixelIdxList{j}) = 0;
        end
    end
    mask = reshape(mask, size(I));
    [tempX, tempY] = find(mask == 1);
    FieldX = [FieldX; tempX];
    FieldY = [FieldY; tempY];
end

fieldBins = [FieldY FieldX];


%% upsample bins for clustering (pixels are weighed byt rate)
norm_map = I0./max(I0,[],"all").*100;
FieldX_upsampled = [];
FieldY_upsampled = [];
for i = 1:length(FieldX)
    N_repeat = round(norm_map(FieldX(i), FieldY(i)))+1;
    FieldX_upsampled = [FieldX_upsampled; repmat(FieldX(i), N_repeat,1)];
    FieldY_upsampled = [FieldY_upsampled; repmat(FieldY(i), N_repeat,1)];
end


fieldBinsUpsampled = [FieldY_upsampled FieldX_upsampled];




end