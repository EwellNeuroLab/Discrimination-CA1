%% Function to get firing preference that are located in reward zone

function FiringPref = GetFiringPref(vec1,vec2,RewZone)
    FiringPref = nan(length(vec1),1);
    for i =1:2
        idx = find(RewZone == i);
        FiringPref(idx) = (vec1(idx)-vec2(idx))./(vec1(idx)+vec2(idx)) * (-1).^(i+1);
    end
end