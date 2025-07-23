%% Gergely Tarcsay, 2024. Assign camera frames to different behaviorally relevant states


function [States, TrialFrames]  = AssignFramesToStates(event, v, v_thresh)
% assign frames whether mouse is running (1) r resting (0)
States.Run= v > v_thresh;
States.Context = zeros(length(v),1); % 1 or 2; not assigned (trial 1) is -1, inter-trial intervals are 0
States.TrialPhase = zeros(length(v),1); % 1 = foraging; 2  =reward retrieval 0 = ITI
States.TrialType = ones(length(v),1); % 1 = training; 2 = testing;  
States.Outcome = zeros(length(v),1); % 1 = incorrect; 2 = correct; 3 = timeout 0= ITI

% analyze trials
[TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
[Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);

if ~isempty(TrainingTrials)
    TrainingTrials = [1 1; TrainingTrials]; % add first trial as training
end

% loop on each trial to assign frames
TrialFrames = [event{TrialStart(1,:), 2} event{ZoneTriggered(1,:), 2} event{TrialStop(1,:), 2}];
TrialFrames(1,1) = 1; % first trial start at frame 1
ctxts = unique(context); % get contexts
ctxts = ctxts(end-1:end); % discard empty string

for i = 1:length(context)

    % trial phase
    States.TrialPhase(TrialFrames(i,1):TrialFrames(i,2)) = 1;
    States.TrialPhase(TrialFrames(i,2)+1:TrialFrames(i,3)) = 2;

    % context
    ctxtType = find(ismember(ctxts, context(i)));
    if ~isempty(ctxtType)
        States.Context(TrialFrames(i,1):TrialFrames(i,3)) =ctxtType;
    else
        States.Context(TrialFrames(i,1):TrialFrames(i,3))  = -1;
    end
    
    % trial type
    if ismember(TrainingTrials(:,1), i)
        States.TrialType(TrialFrames(i,1):TrialFrames(i,3)) = 1;
    elseif ~ismember(TrainingTrials(:,1), i) & ~isempty(ctxtType)
        States.TrialType(TrialFrames(i,1):TrialFrames(i,3)) = 2;
    end

    % outcome
    for k = 0:2
        if all_outcome(i) == k
           States.Outcome(TrialFrames(i,1):TrialFrames(i,3)) = k+1;
        end
    end



end


