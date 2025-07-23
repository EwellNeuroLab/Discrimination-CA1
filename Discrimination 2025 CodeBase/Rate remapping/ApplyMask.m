%% Function to apply field mask on each map
function [Summary_tbl, FieldMap_full, FieldMap_sess] = ApplyMask(maps, fields)
field_counter = 1;
[N_cells, N_session] = size(maps.ActivityRate_sess);
FieldMap_full = cell(N_cells,1);
FieldMap_sess = cell(N_cells, N_session);
field_ID = [];
cell_ID = [];
FieldSize = [];
FieldCenter = [];
PeakRate = [];
MeanRate = [];
PeakRate_All = [];
for i =1: N_cells
    [row,col,N_fields] = size(fields.mask{i});
    FieldMap_full{i} = zeros(row,col,N_fields);
    if ~isempty(fields.mask{i})  
        for f = 1:N_fields
            mask = fields.mask{i}(:,:,f);
            FieldMap_full{i}(:,:,f) = maps.ActivityRate_full{i}.*mask;
            for s = 1:N_session
                FieldMap_sess{i,s}= zeros(row,col,N_fields);
                FieldMap_sess{i,s}(:,:,f) = maps.ActivityRate_sess{i,s}.*mask;
                PeakRate(field_counter,s) = max(FieldMap_sess{i,s}(:,:,f), [], "all");
                map = FieldMap_sess{i,s}(:,:,f);
                MeanRate(field_counter,s) = mean(map(map > 0), "all");
            end
            PeakRate_All(field_counter) = max(FieldMap_full{i}(:,:,f), [],"all");
            field_ID(field_counter) = field_counter;
            cell_ID(field_counter) = fields.cellID(i);
            FieldSize(field_counter) = sum(mask,"all");

            if max(maps.ActivityRate_full{i}.*mask,[],"all") > 0
                [FieldCenter(field_counter,1), FieldCenter(field_counter,2)] = find(maps.ActivityRate_full{i} == max(maps.ActivityRate_full{i}.*mask,[],"all"));
            else
                FieldCenter(field_counter, : ) = [NaN NaN];
            end
            field_counter = field_counter+1;
        end
    end

end

field_ID = field_ID';
cell_ID = cell_ID';
FieldSize = FieldSize';
PeakRate_All = PeakRate_All';
IsActive = zeros(size(field_ID));
Summary_tbl = table(field_ID, IsActive, cell_ID, PeakRate_All, FieldSize, FieldCenter, MeanRate, PeakRate);

end
