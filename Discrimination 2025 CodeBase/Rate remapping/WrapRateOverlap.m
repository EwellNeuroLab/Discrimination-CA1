% wrapping function analyze rate overlap

function [All,Cohort, Individual] = WrapRateOverlap(workdir, discrimination)

All.ROS = [];
All.RewROS  = [];
All.OutROS = [];
All.RewDist = [];
All.RZID = [];
All.Pref = [];
All.MeanRate = [];
All.N_events= [];
All.Size = [];
All.NFields = [];



Cohort.ROS = {[]; []};
Cohort.RewROS = {[]; []};
Cohort.OutROS= {[]; []};
Cohort.RewDist = {[]; []};

Individual.ROS = cell(length(workdir),1);
Individual.RewROS = cell(length(workdir),1);
Individual.OutROS = cell(length(workdir),1);
Individual.NRewField = zeros(length(workdir), 2);
Individual.NMismatch = zeros(length(workdir), 2);


for f = 1:length(workdir)
    disp(workdir(f))
    load(strcat(workdir(f),"\processedData\FieldTbl.mat"))
    load(strcat(workdir(f),"\processedData\FieldClustering.mat"))
    load(strcat(workdir(f),"\processedData\PlaceMaps.mat"))

    % use only fields that are labelled as active
    field_idx = find(Field_tbl.IsActive == 1);
    All.ROS = [All.ROS; Field_tbl.ROLMean(field_idx)];
    Cohort.ROS{discrimination(f)}  = [Cohort.ROS{discrimination(f)} ; Field_tbl.ROLMean(field_idx)];
    Individual.ROS{f} = Field_tbl.ROLMean(field_idx);
    % split fields to rew and nonrew
    rfield_idx = find(Field_tbl.IsActive == 1 & Field_tbl.RewZone > 0);
    
    All.RewROS = [All.RewROS; Field_tbl.ROLMean(rfield_idx )];
    Cohort.RewROS{discrimination(f)}  = [Cohort.RewROS{discrimination(f)} ; Field_tbl.ROLMean(rfield_idx )];
    Individual.RewROS{f} = Field_tbl.ROLMean(rfield_idx);

    ofield_idx = find(Field_tbl.IsActive == 1 & Field_tbl.RewZone == 0);
    All.OutROS = [All.OutROS; Field_tbl.ROLMean(ofield_idx )];
    Cohort.OutROS{discrimination(f)}  = [Cohort.OutROS{discrimination(f)} ; Field_tbl.ROLMean(ofield_idx )];
    Individual.OutROS{f} = Field_tbl.ROLMean(ofield_idx);

    % save distance from reward
    All.N_events = [All.N_events; Field_tbl.N_events(field_idx)]; 
    All.RewDist = [All.RewDist ; min(Field_tbl.RewDist(field_idx,:),[],2)];
    Cohort.RewDist{discrimination(f)} = [Cohort.RewDist{discrimination(f)}; min(Field_tbl.RewDist(field_idx,:),[],2)];

    % save rz id, firing pref and rates for mismatch analysis
    All.RZID = [All.RZID; Field_tbl.RewZone(Field_tbl.RewZone > 0 & Field_tbl.IsActive == 1)];
    All.Pref = [All.Pref; Field_tbl.FiringPrefMean(Field_tbl.RewZone > 0  & Field_tbl.IsActive == 1)];
    All.MeanRate = [All.MeanRate; Field_tbl.MeanRate(Field_tbl.RewZone > 0  & Field_tbl.IsActive == 1,:)];

    % get size and number of fields
     [~,~,idx] = unique(Field_tbl.cell_ID(field_idx));
     C = accumarray(idx,1);
     All.NFields = [All.NFields; C];
     All.Size = [All.Size; Field_tbl.FieldSize(field_idx)];

    % count number of fields
    Individual.NRewField(f,1) = sum(Field_tbl.RewZone == 1);
    Individual.NRewField(f,2) = sum(Field_tbl.RewZone == 2);

    Individual.NMismatch(f,1) = sum(Field_tbl.FiringPrefMean(Field_tbl.RewZone == 1) < -0.333);
    Individual.NMismatch(f,2) = sum(Field_tbl.FiringPrefMean(Field_tbl.RewZone == 2)< -0.333);


    clearvars -except workdir f All Cohort Individual discrimination

end
end

