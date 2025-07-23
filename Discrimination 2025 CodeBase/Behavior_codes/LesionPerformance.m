%% Gergely Tarcsay, 2024 Ewell lab. Script to generate performance for the lesion experiments (Fig 1)

close all
warning('off','all')
if ~exist("lesion_struct", "var")
    load ("G:\HPC lesion\LesionData.mat")
end

%get all days starting from day when passed
ctrl = find(lesion_struct.details.Group == "c");
lesion = find(lesion_struct.details.Group == "l");
starting_day = lesion_struct.details.LesionD1-1;

%calculate performance for these days
[~, N_mice] = size(lesion_struct.events);
Performance = nan(5,N_mice,3);

for m = 1:N_mice
    disp(lesion_struct.details.Mouse(m))
    %for d = starting_day(m):starting_day(m)+4
    for d = starting_day(m):starting_day(m)+4
    event = lesion_struct.events{d,m};
    [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
    [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
    TrialType  = ones(length(all_outcome),1);
    if ~isempty(TrainingTrials)
        TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
    end
        %Performance(d-starting_day(m)+1,m,:) = GetPerformance(TrialType, context, all_outcome);
        Performance(d-starting_day(m)+1,m,:) = GetPerformance(TrialType, context, all_outcome);
    end
end

%plot performance for each group
c_col = '#A43B1D';
l_col = '#8B008B';
mean_L = mean(Performance(:,lesion,1),2);
mean_C = mean(Performance(:,ctrl,1),2);
sem_L = std(Performance(:,lesion,1),[],2);
sem_C = std(Performance(:,ctrl,1),[],2);

figure
hold on
errorbar(0:2:8, mean_C, sem_C, 'o', 'Color', c_col, 'LineWidth',4, 'CapSize',16, 'MarkerSize',6)
errorbar(0.5:2:8.5, mean_L, sem_L, 'o', 'Color', l_col, 'LineWidth',4, 'CapSize',16, 'MarkerSize',6)
ylim([0 100])
xlim([-0.5 9])

for i = 1:5
    plot(repmat(2*(i-1)+0.5,6,1), Performance(i,lesion,1), "o", "Color", [.5 .5 .5])
    plot(repmat(2*(i-1),6,1), Performance(i,ctrl,1), "o", "Color", [.5 .5 .5])
end


%% figure version 2 - show w/ violin plot
close all
figure
hold on
l_violin = [255 102 102]./255;
c_violin = [153 204 255]./255;
l_dot = [204 0 0]./255;
c_dot = [0 0 204]./255;
x_loc = [0 1 3 4 6 7 9 10 12 13];
for i =1:5
    Y(:,1) = Performance(i,lesion,1);
    Y(:,2) = Performance(i,ctrl,1);
    
    violin(Y, 'x', [x_loc(2*i-1) x_loc(2*i)], 'facecolor', [l_violin; c_violin], 'edgecolor', 'k', 'mc', [], 'medc', [])
    plot(repmat(x_loc(2*i-1), 6,1), Performance(i,lesion,1), 'o', 'MarkerEdgeColor', l_dot, 'MarkerFaceColor',l_dot, 'MarkerSize', 3)
    plot(repmat(x_loc(2*i), 6,1), Performance(i,ctrl,1), 'o', 'MarkerEdgeColor', c_dot, 'MarkerFaceColor',c_dot, 'MarkerSize', 3)
    clear Y
end

xlim([-1 15])
ylim([0 120])
box off
xticks([0.5 3.5 6.5 9.5 12.5])
yticks(10:20:90)
ylabel("Performance (%)")
xline(2, '--')

