%% function to detect peaks on deconvolved calcium traces 
% simple findpeaks for non-drifting cells
% thresholded detection for threshold needed cells
% 0s for drifting cells


%% Gergely Tarcsay, 2024. Function to detect Ca events using the deconvolved calcium signal. 
% 1. Drifting cells are kept 0
% 2. For non-drifting cells findpeaks is used, without thresholding. ts
% matrix is used to convert miniscope frame to camera frame
% 3. For threshold needed cells findpeaks is used to determine whether the
% amplitude distribution is normal. If yes, findpeaks is rerun with a
% threshold of 1 sd, if no 2 sd is used
% Output is a matrix that assigns 1s when cell is active and 0s when not,
% time measured in camera frames
function [CaMatrix, h] = GetCaActivity(s,ts,IsDrifting)
N_frames = length(ts(:,1));
[~,N_cells] = size(s);
h = nan(N_cells,1);
CaMatrix = zeros(N_cells, N_frames);

for i = 1:N_cells

    if IsDrifting(i) == 1
        continue;
    end
    [pks,loc] = findpeaks(s(:,i));
    if IsDrifting(i) == 2
        h(i) = kstest(pks); % test whether amplitude distribution is normal
        if h(i) ==0
            N = 1; % if normal distribution, use a sd value of 1
        else
            N = 2; % otherwise use two
        end
        [~, loc] = findpeaks(s(:,i), "MinPeakHeight", mean(s(:,i))+N*std(s(:,i)));
    end

    for j  = 1:length(loc)
        [~, idx] = min(abs(ts(:,2)-loc(j)));
        CaMatrix(i,ts(idx,1)) = 1; % detected location is measured in miniscope frame, while the matrix outputs in camera frame
    end
end

end
