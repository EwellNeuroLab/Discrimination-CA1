% function to calculate PVC of vector tuning
function PVC = GetPVC_HD(TuningCurves)
PVC = zeros(8,1);
for b =  1:8
    PVC(b) = nancorr(TuningCurves(:,b,1), TuningCurves(:,b,2));
end

end