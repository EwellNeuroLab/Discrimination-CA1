%% function to measure whether a cell's calcium trace is drifting or not during recordings

function [Mins, IsDrifting] = DetectDrift(c, segments, ms_framerate, DriftParams)
[N_points, N_cells] = size(c);
step = segments*ms_framerate*60;
N_segments = floor(N_points/(step));

Mins = zeros(N_cells, N_segments);
IsDrifting =zeros(N_cells,1);
for i = 1:N_cells
    for n = 1:N_segments
        start = 1+(n-1)*step;
        stop = n*step;
        Mins(i,n) = min(c(start:stop,i));
    end
    
    Drift = find(abs(Mins(i,:)) >= DriftParams.Thresh);
    if length(find(diff(Drift)==1))+1>=DriftParams.Dur
    % consecutive segments when drifting happens
        IsDrifting(i) = 1;
    end
    

end





       

