%% function to fix event file - remove too short event strings

function event = FixEventFile(event)
    rmv = find(cellfun(@length,event{:,1}) < 6);
    event(rmv,:) = [];

end

