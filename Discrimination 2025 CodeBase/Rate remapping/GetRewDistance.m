%% function to get field center - reward site distance
function [RewDistance, RewLoc] = GetRewDistance(event, Field_tbl, BinnedXY)
[TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
[Correct, ~, ~, ~, ~, ~, ~] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);


if sum(ismember(context, 'A')) > 0
    context_labels = ["A", "A'"];
    rew = 2;
else
    context_labels = ["B", "B'"];
    rew = 1;
    
end
RewLoc = zeros(2,rew);


%% now get reward location(s) & calculate distance from each field's center
RewDistance = zeros(length(Field_tbl.field_ID),rew);
for r = 1:rew
    trials = find(context == context_labels(r));
    RewLoc(:,r) = GetRewLocation(trials, Correct, event, BinnedXY);
    XDist = Field_tbl.FieldCenter(:,1)-RewLoc(1,r);
    YDist = Field_tbl.FieldCenter(:,2)-RewLoc(2,r);
    RewDistance(:,r) = sqrt(XDist.^2 + YDist.^2);
end


end