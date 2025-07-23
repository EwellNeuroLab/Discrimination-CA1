%% function get tuning strength of orthogonal cells
function TuningStrength = GetTuningStrength(HD_table, HD_list)

TuningStrength = [];
counter = 1;
for i = 1:length(HD_list)
     idx = find(HD_table.cellID == HD_list(i));

     if HD_table.IsPC_HDC(idx,2) == 1 && HD_table.IsPC_HDC(idx,3) == 0  % if cell is tuned in ctxt A
         TuningStrength(counter,1) = HD_table.RVL(idx,1); %tuned strength
         TuningStrength(counter,2) = HD_table.RVL(idx,2); % untuned strength
         counter = counter+1;

     elseif HD_table.IsPC_HDC(idx,3) == 1 && HD_table.IsPC_HDC(idx,2) == 0  % if cell is tuned in ctxt B
         TuningStrength(counter,2) = HD_table.RVL(idx,1); %tuned strength
         TuningStrength(counter,1) = HD_table.RVL(idx,2); % untuned strength
         counter = counter+1;
         
     elseif HD_table.IsPC_HDC(idx,3) == 1 && HD_table.IsPC_HDC(idx,2) == 1
         TuningStrength(counter,1) = HD_table.RVL(idx,1); %tuned strength 1
         TuningStrength(counter,2) = HD_table.RVL(idx,2); % tuned strength 2
         counter = counter+1;
     end

end
end