%% function to analyze whether reward tuned HDC/PCs have place field nearby reward

function [HasRewardField, RewDist] = AnalyzeFieldHDCPC(IsRewardTuned, cellID, Field_tbl, LightBin, RewBin)

[~,ia,~] = intersect(RewBin,LightBin);
HasRewardField = nan(length(cellID),1);
RewDist = nan(length(cellID),1);
for i = 1:length(cellID)
    if IsRewardTuned(i,1) ==1 || IsRewardTuned(i,2) ==1


        field_idx=  find(Field_tbl.cell_ID == cellID(i)); % get fields that belong to this cell
        fieldType = Field_tbl.RewZone(field_idx);
        fieldDist  = Field_tbl.RewDist(field_idx,:);
        if ~isempty(ia)
            if ismember(1,fieldType) == 1 && ~ismember(ia,1) % 1st reward
                HasRewardField(i) = 1;
                RewDist(i) = min(fieldDist(:,1)); % use the closest field

            elseif ismember(2,fieldType) == 1 && ~ismember(ia,2) % 2nd reward
                HasRewardField(i) = 1;
                RewDist(i) = min(fieldDist(:,2)); % use the closest field
            else
                HasRewardField(i) = 0;
                if ia == 1
                    RewDist(i) = min(fieldDist(:,2));
                else
                    RewDist(i) = min(fieldDist(:,1));
                end
            end
        else
            if ismember(1,fieldType)
                HasRewardField(i) = 1;
                RewDist(i) = min(fieldDist(:,1));
            else
                HasRewardField(i) = 0;
                RewDist(i) = min(fieldDist(:,1));
            end

        end

    end
end

end