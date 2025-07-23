%% function to count events - 2nd version when maps and eventXY has the same cells included only%% Function to count Ca events in individual fields
function [EventCounter, FieldEventTime, FieldEventPercentage] = CountFieldEvents_MisMatch(FieldMap_full, onset, p)

EventCounter = [];
FieldEventTime = {};
FieldEventPercentage = []; % percentage of events that happened within the field
field_counter = 1;
    % first get cell_idx - event time does not contain drifting cells! idx
    % have to be matched
for i =1:length(FieldMap_full)
    
    % next concat eventXY for the current cell
    EventBins = [onset.EventXY{i,1}; onset.EventXY{i,2}];
    EventTs = [onset.EventTime{i,1}; onset.EventTime{i,2}];
    if ~isempty(FieldMap_full{i})
        [~,~,N_fields] = size(FieldMap_full{i}); % get number of fields
        
        for f = 1:N_fields % loop on each field
            map = FieldMap_full{i}(:,:,f); % take map from current field
            threshold = prctile(map(map > 0), p); % select bins (bins > median value of peak)
            [binx, biny] = find(map >= threshold);
            EventCounter(field_counter) = 0;
            EventTime_temp = [];
            % now compare these selected bins to event bins
                for b = 1:length(binx)
                   ActiveInField = find(EventBins(:,1) == biny(b) & EventBins(:,2) == binx(b));
                   if ~isempty(ActiveInField)
                       EventCounter(field_counter) = EventCounter(field_counter) + length(ActiveInField );
                       EventTime_temp = [EventTime_temp; EventTs(ActiveInField)];
                   end
                end
            FieldEventTime{field_counter} = EventTime_temp;
            FieldEventPercentage(field_counter) = EventCounter(field_counter)/length(EventBins(:,1))*100;
            field_counter = field_counter+1;
        end
    
    end

end
EventCounter = EventCounter';
FieldEventTime = FieldEventTime';
FieldEventPercentage = FieldEventPercentage';
end