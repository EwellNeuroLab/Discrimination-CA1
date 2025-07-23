%% function to assign states to frames for the random foraging experiments

function [States, TrialFrames] = AssignFramesToStates_RF(event, v, v_thresh)


    States.Run = v > v_thresh;
    States.Context = zeros(length(v),1);
    States.TrialPhase = zeros(length(v),1);
    States.TrialType = nan(length(v),1);
    States.Outcome = nan(length(v),1);

    [TrialStartFrame, TrialStopFrame, context] = ParseTrialsRandomForaging(event, length(v));
    TrialFrames = [TrialStartFrame TrialStopFrame];

    % loop on each trial and assign frames to states
    ctxts = unique(context); % get contexts
    for i = 1:length(context)
        % foraging (always, except whe frames not assigned to anything)
        States.TrialPhase(TrialFrames(i,1):TrialFrames(i,2)) = 1;

        %assign context
        ctxtType = find(ismember(ctxts, context(i)));
        States.Context(TrialFrames(i,1):TrialFrames(i,2)) =ctxtType;
    end

    States.Context(States.Context == 0) = -1; % set not assigned frames to -1

end
    