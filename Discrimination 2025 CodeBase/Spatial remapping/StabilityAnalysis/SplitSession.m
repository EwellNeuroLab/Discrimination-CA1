%% Gergely Tarcsay, 2024. Function to split session into 1st and 2nd half trials, even and odd trials for each context

function [frames, labels] = SplitSession(TrialFrames, States)
% get trial # for each context
CtxtOfTrial  = States.Context(TrialFrames(:,2)); % get context for each trial; trial 1 is not assigned
frames = cell(4,2); %1st, 2nd, odd, even for both contexts
labels = ["1st"; "2nd"; "odd"; "even"];

for c=  1:2
    TrialList = find(CtxtOfTrial == c); % get trials for one context
    HalfOfTrial =  round(length(TrialList)/2); % calculate where to split between first and second half

    for i = 1:length(TrialList)

        if i < HalfOfTrial % first half
            frames{1,c} = [frames{1,c}; intersect(TrialFrames(TrialList(i),1):TrialFrames(TrialList(i),2), find(States.Run == 1))]; % only foraging running is included
        else % 2nd half
            frames{2,c} = [frames{2,c}; intersect(TrialFrames(TrialList(i),1): TrialFrames(TrialList(i),2), find(States.Run == 1))];
        end

        if rem(i,2) == 0 % even trials
            frames{4,c} = [frames{4,c}; intersect(TrialFrames(TrialList(i),1): TrialFrames(TrialList(i),2), find(States.Run == 1))];
        else % odd trials
            frames{3,c} = [frames{3,c}; intersect(TrialFrames(TrialList(i),1): TrialFrames(TrialList(i),2), find(States.Run == 1))];
        end
    end

    %% sanity check - test whether 1st+2nd = even+odd
    if length(frames{1,c})+length(frames{2,c}) ~= length(frames{3,c}) + length(frames{4,c})
        disp(strcat("1st+2nd ~ = even+odd in ctxt ", num2str(c)))
    end
end
end




