%% function to calculate events for splitted dataset

function EventTime = GetEventTime(CaMatrix,frames)

%% get splitted events
[N_cell, ~] = size(CaMatrix);
EventTime = cell(N_cell,1);
for i = 1:N_cell
    QueryEvents = intersect(find(CaMatrix(i,:)==1),frames); % activity in query frames
    EventTime{i} = QueryEvents; % save event time

end

end