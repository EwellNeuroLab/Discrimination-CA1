%% function to calculate rate overlap

function ROL = GetRateOverlap(vec1, vec2)
    
    ROL = 1 - abs(vec1-vec2)./(vec1+vec2); 
    

end