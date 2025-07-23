%% function to get angular difference between two contexts for a subset of cells

function [AngDiff,IsOrthogonal] = GetAngularDifference(HD_list, HD_table)
    AngDiff = zeros(length(HD_list),1);
    IsOrthogonal = zeros(length(HD_list),1);
    for i = 1:length(HD_list)
        idx = find(HD_table.cellID == HD_list(i));
        if(sum(HD_table.IsPC_HDC(idx,2:3),2)==1)
            IsOrthogonal(i) = 1;
        end
        AngDiff(i) = abs(HD_table.RVMean(idx,1)-HD_table.RVMean(idx,2));
    end
end