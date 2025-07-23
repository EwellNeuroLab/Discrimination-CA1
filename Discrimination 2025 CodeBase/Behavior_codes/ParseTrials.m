 %% Gergely Tarcsay, 2022. Function to parse data into individual trials and get timestamp when mouse triggered the hidden zone.

function [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event) 



flags = event{:,1};
%loop on flags to find the beginning of the the trials, get the indicies in
%the event matrix
t=1;
z =1;
c=1;
context=strings();
for f = 1:length(flags)
    %trial starts when LED is on. Trial stops before the next LED on
    %
    if length(flags{f})<6
        disp(strcat("Too short event flag in line ", num2str(f), ". Skipped for now but please fix it manually in the EventFile."))
        continue;
    end
    if  strcmp(flags{f}(1:6), "LED on") == 1
        TrialStart(t) = f;
        TrialStop(t) = f-1;
        msg = strsplit(flags{f,1}," ");
        t=t+1;      
    end

    if strcmp(flags{f}(1:6), "Contex") == 1
        if length(flags{f})== 9
            context(c) = flags{f}(end);
        else
            context(c) = flags{f}(end-1:end);
        end
        c=c+1;
    end
    if strcmp(flags{f}(1:6), "Trigge") == 1
        ZoneTriggered(z) = f;
        z=z+1;
    end
end

%add very last index as the stop of last trial
TrialStop = [TrialStop length(flags)];

%add frame 1 as the start of Trial 1 - sometimes the first LED on event is
%not sent
if length(TrialStop) > length(TrialStart)
    context = ["" context];
    TrialStart = [1 TrialStart];
end

%check the consistency of TrialStart -> ZoneTriggered -> TrialStop. If not,
%remove a trigger flag as it might possible that 2 LED off is following
%each other.
counter = 1;

while counter <= length(ZoneTriggered)
    if TrialStart(counter) <= ZoneTriggered(counter) && TrialStop(counter)>= ZoneTriggered(counter)
        counter = counter +1;
    else
       disp(strcat("Event flag may missing around ", num2str(ZoneTriggered(counter))));
       break;
    end
end

%if in last trial no triggered happened - remove that trial

if length(ZoneTriggered)< length(TrialStart)
    TrialStart(end) = [];
    TrialStop(end) = [];
    context(end) = [];
end

