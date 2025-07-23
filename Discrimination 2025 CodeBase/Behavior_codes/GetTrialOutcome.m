%% Gergely Tarcsay, 2022. Function to get outcome of individual trials - correct/incorrect/time out. Correct port belonging to each trial is also saved,
%% moreover the time that was necessary to find the reward + Training trials when the port LED was on.

function [Correct, Incorrect, Timeout, port,time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered)
%counters
c=1; %for correct trials
i=1; %for incorrect trials
t=1; %for timeout trials
p = 1; %for training trials
l=1; % for port position
flags = event{:,1};
port = strings(length(ZoneTriggered));
Correct = [];
Incorrect = [];
Timeout = [];
all_outcome = [];
TrainingTrials = [];
time = [];
for trial = 1:length(TrialStart)
    for d = TrialStart(trial):TrialStop(trial)
        if length(flags{d,1}) > 4
        if flags{d,1}(1:4) == "Corr"
            Correct(c,:) = [trial d];
            msg = strsplit(flags{d,1},"_");
           % time(l) = str2num(msg{4}(1:end-2))/1000;
            c = c+1;
            chartype= isletter(msg{2});
            number = find(chartype == 0);
            port(l) = msg{2}(1:number-1);
            all_outcome(l,:) = [0 d];
            l = l+1;
            
        elseif flags{d,1}(1:4) == "Inco"
            Incorrect(i,:) = [trial d];
            i = i+1;
            msg = strsplit(flags{d,1},"_");
            port(l) = msg{2};
            all_outcome(l,:) = [1 d];
            time(l) = 0;
            l = l+1;
        elseif flags{d,1}(1:4) == "Time"
            Timeout(t,:) = [trial d];
            t=t+1;
            msg = strsplit(flags{d,1},"_");
            port(l) = msg{2};
            all_outcome(l,:) = [2 d];
            l = l+1;
            time(l) = nan;
        elseif flags{d,1}(1:5) == "Train"
            TrainingTrials(p,:) = [trial d];
            p = p+1;
        end
        end
    end
end

end

function port = GetPortPos(msg)
    %get which port is the correct one
    chartype= isletter(msg{2});
    number = find(chartype == 0);
    port = msg{2}(1:number-1);
end

