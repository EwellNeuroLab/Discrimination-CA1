%% Gergely Tarcsay, 2024, Ewell lab. Script to calculate % of type of trial errors made during the lesion experiments.

close all

if ~exist("lesion_struct", "var")
    load ("G:\HPC lesion\LesionData.mat")
end

if ~exist("behavior_struct", "var")
    load ("G:\Behavior\BehaviorData.mat")
end

%%get baseline errors from behavior only
[~, N_mice_bl] = size(lesion_struct.events);
ErrorType_bl = nan(3, N_mice_bl+10);
N_error_bl = nan(N_mice_bl+10,1);

for m = 1:N_mice_bl
    disp(lesion_struct.details.Mouse(m))
    d = lesion_struct.details.LesionD1(m)-1;
    event = lesion_struct.events{d,m};
    [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
    [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
    TrialType  = ones(length(all_outcome),1);
    if ~isempty(TrainingTrials)
        TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
    end
    %%get rewarded ports for this mouse
    reward_ports = unique(port);
    if length(reward_ports) > 2
        reward_ports(1) = [];
    end
    %only use testing trials
    [~,idx,~] = intersect(Incorrect(:,1),find(TrialType == 1));
    idx = sort(idx);
    if ~isempty(idx)
        Testing_Incorrect = Incorrect(idx,:);
        [ErrorType_bl(:,m), ~] =  GetWrongChoice(event, reward_ports, Testing_Incorrect);
        N_error_bl(m) = length(Testing_Incorrect(:,1));
    else
        ErrorType_bl(:,m) = [0 0 0];
    end
end


%% now add the behavior mice too
for m = N_mice_bl+1:N_mice_bl+10
    disp(behavior_struct.details.Mouse(m-N_mice_bl))
    d = behavior_struct.details.DPassed(m-N_mice_bl);
    event = behavior_struct.D_events{d,m-N_mice_bl};
    [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
    [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
    TrialType  = ones(length(all_outcome),1);
    if ~isempty(TrainingTrials)
        TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
    end
    %%get rewarded ports for this mouse
    reward_ports = unique(port);
    if length(reward_ports) > 2
        reward_ports(1) = [];
    end
    %only use testing trials
    [~,idx,~] = intersect(Incorrect(:,1),find(TrialType == 1));
    idx = sort(idx);
    if ~isempty(idx)
        Testing_Incorrect = Incorrect(idx,:);
        [ErrorType_bl(:,m), ~] =  GetWrongChoice(event, reward_ports, Testing_Incorrect);
        N_error_bl(m) = length(Testing_Incorrect(:,1));
    else
        ErrorType_bl(:,m) = [0 0 0];
    end
end

%get all days starting from day when passed
ctrl = find(lesion_struct.details.Group == "c");
lesion = find(lesion_struct.details.Group == "l");
starting_day = lesion_struct.details.LesionD1-1;

%% allocate variables for storing error information
[~, N_mice] = size(lesion_struct.events);
ErrorType = nan(5,3,N_mice); % percentage of error type; context error (1); port error(2); random(5)
N_error = nan(5,N_mice);

for m = 1:N_mice
    disp(lesion_struct.details.Mouse(m))
    for d = starting_day(m):starting_day(m)+4

        event = lesion_struct.events{d,m};
        [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
        [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
        TrialType  = ones(length(all_outcome),1);
        if ~isempty(TrainingTrials)
            TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
        end
        %%get rewarded ports for this mouse
        reward_ports = unique(port);
        if length(reward_ports) > 2
            reward_ports(1) = [];
        end
        %only use testing trials
        [~,idx,~] = intersect(Incorrect(:,1),find(TrialType == 1));
        idx = sort(idx);
        if ~isempty(idx)
            Testing_Incorrect = Incorrect(idx,:);
            [ErrorType(d-starting_day(m)+1,:,m), ~] =  GetWrongChoice(event, reward_ports, Testing_Incorrect);
            N_error(d-starting_day(m)+1,m) = length(Testing_Incorrect(:,1));
        else
            ErrorType(d-starting_day(m)+1,:,m) = [0 0 0];
        end
    end
end

%% take the mean for control and lesion
ctrl_error = mean(ErrorType(:,:,ctrl), 3 );
lesion_error = mean(ErrorType(:,:,lesion),3);

%% get baseline with all the mice (N = 24)
baseline = mean([ErrorType_bl reshape(ErrorType(1,:,:),3,12)],2);
figure
tiledlayout(2,5)
nexttile;
pie(baseline)

for i = 1:4
    nexttile;
    pie(lesion_error(i+1,:))

end
nexttile
box off 
axis off
for i = 1:4
    nexttile;
    pie(ctrl_error(i+1,:))

end
colormap bone


%% run chi square on data
p  = nan(4,2);
X2 = nan(4,2);

for i = 1:4
    x = [baseline lesion_error(i+1,:)'];
    [~,p(i,1),X2(i,1)] = chi2cont(x);
    x = [baseline ctrl_error(i+1,:)'];
    [~,p(i,2),X2(i,2)] = chi2cont(x);
end

%get average error
avg_error_bl = mean([N_error_bl; N_error(1,:)']);

avg_error = nan(4,2);
for i =1:4
    avg_error(i,1) = mean(N_error(i+1,lesion));
    avg_error(i,2)= mean(N_error(i+1,ctrl));
end