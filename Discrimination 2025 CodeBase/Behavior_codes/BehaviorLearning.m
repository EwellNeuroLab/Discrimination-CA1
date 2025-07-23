%% Gergely Tarcsay, 2025 Ewell lab. MATLAB script to recreate learning curve and performance (Figure 1)
close all
clearvars -except behavior_struct
cd("G:\Behavior only\")

if ~exist("behavior_struct", "var")
    load BehaviorData
    behavior_struct.details.GPassed(5) =behavior_struct.details.GPassed(5)-1; % count the first day of > 70% for M99 because 2nd had behavior problems (cold room)
end

[N_days_d, N_mice] = size(behavior_struct.D_events);
Performance_d = nan(N_days_d,N_mice+8, 3); % to store performance  - total, ctxt A & ctxt B

%% get Performance for discrimination
for m = 1:N_mice
    disp(behavior_struct.details.Mouse(m))
    for d = 1:N_days_d
    event = behavior_struct.D_events{d,m};
    if isempty(event)
        break;
    end
    [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
    [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
    TrialType  = ones(length(all_outcome),1);
    if ~isempty(TrainingTrials)
        TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
    end
        Performance_d(d,m,:) = GetPerformance(TrialType, context, all_outcome);
    end

end

%% get performance for generalization
[N_days_g, N_mice] = size(behavior_struct.G_events);
Performance_g = nan(N_days_g,N_mice+8, 3); % to store performance  - total, ctxt A & ctxt B

for m = 1:N_mice
    disp(behavior_struct.details.Mouse(m))
    for d = 1:N_days_g
    event = behavior_struct.G_events{d,m};
    if isempty(event)
        break;
    end
    [TrialStart, TrialStop, ZoneTriggered, context] = ParseTrials(event);
    [Correct, Incorrect, Timeout, port, time, TrainingTrials, all_outcome] = GetTrialOutcome(event,TrialStart,TrialStop,ZoneTriggered);
    TrialType  = ones(length(all_outcome),1);
    if ~isempty(TrainingTrials)
        TrialType([1; TrainingTrials(:,1)]) = 0; %1st trial is training when training trials are included in the session
    end
        Performance_g(d,m,:) = GetPerformance(TrialType, context, all_outcome);
    end

end


%% get performance for miniscope mice
rootdir = strings(2,1);
folders = strings(5,2);
rootdir(1) = "F:\Included miniscope Mice\";
folders(:,1) = ["\M119\"  "\M120\" "\M292\" "M319\" "M210\"];
rootdir(2) = "D:\Grouping First\";
folders(:,2) = ["\M231\" "\M314\"  "\M316\" "M318\" ""];
nMice = [5 4];
MiniscopeSex = ["f" "f" "f" "m" "m" "m", "f" "m" "m"];
counter = 1;
for r = 1:2
    for f = 1:nMice(r)
        load(strcat(rootdir(r), folders(f,r), "Performance_d.mat"))
        [days, ~,~]  = size(Performance);
        Performance_d(1:days,counter+10,:) = Performance;
        clear Performance
        
        if exist(strcat(rootdir(r), folders(f,r), "Performance_g.mat"), "file") 
            load(strcat(rootdir(r), folders(f,r), "Performance_g.mat"))
            [days, ~,~]  = size(Performance);
            Performance_g(1:days,counter+10,:) = Performance;
            clear Performance
        else
            Performance_g(1:days,counter+10,:) = nan(days,3);
        end
        counter = counter +1;
    end
end

% plot results
males = [find(behavior_struct.details.Sex == "m"); find(MiniscopeSex == "m")'+10];
females = [find(behavior_struct.details.Sex == "f"); find(MiniscopeSex == "f")'+10];


%% get when they reached 70%
Main_Perform_D = Performance_d(:,:,1);
Main_Perform_G = Performance_g(:,:,1);

Discrimination_70 = nan(19,2);
Grouping_70 = nan(19,2);

for i = 1:19
   idx = find(Main_Perform_D(:,i) >= 70);
   Discrimination_70(i,1) = idx(1);
   Discrimination_70(i,2) = Main_Perform_D(idx(1),i);
   idx = find(Main_Perform_G(:,i) >= 70);
   if ~isempty(idx)
        Grouping_70(i,1) = idx(1);
        Grouping_70(i,2) = Main_Perform_G(idx(1),i);
   end
end

%% plot learning curves - separate for males and females
figure
tiledlayout(1,2)
nexttile;
hold on
box off
axis square
for i = 1:length(females)
    plot(Main_Perform_D(1:Discrimination_70(females(i),1),females(i)),"o-", "MarkerSize",5, "Color","#a8cfc3")
end

for i = 1:length(males)
    plot(Main_Perform_D(1:Discrimination_70(males(i),1),males(i)),"o-", "MarkerSize",5, "Color","#27a37d")
end
ylim([0 100])
xlim([0 11])

nexttile;
hold on
box off
axis square
for i = 1:length(females)
    disp(i)
    if ~isnan(Grouping_70(females(i),1))
        plot(Main_Perform_G(1:Grouping_70(females(i),1),females(i)),"o-", "MarkerSize",5, "Color","#bea7d9")
    end
end

for i = 1:length(males)
    if ~isnan(Grouping_70(males(i),1))
        plot(Main_Perform_G(1:Grouping_70(males(i),1),males(i)),"o-", "MarkerSize",5, "Color","#854bc9")
    end
end
xlim([0 7])
ylim([0 100])

%% make violin plots for grouping and discrimination
figure
tiledlayout(1,2)
Y_D = nan(10,2);
Y_G = nan(10,2);

Y_D(1:length(females),1) = Discrimination_70(females,2);
Y_D(1:length(males),2) = Discrimination_70(males,2);

nexttile;
violin(Y_D, 'x', [1 2], 'facecolor', [.85 .85 .85; 0 0 0; .85 .85 .85; 0 0 0], 'edgecolor', 'k', 'mc', [], 'medc', [])
box off
hold on
plot(repmat(1,10,1), Y_D(:,1), 'o', 'MarkerEdgeColor', [.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5], 'MarkerSize', 3)
plot(repmat(2,10,1), Y_D(:,2), 'o', 'MarkerEdgeColor', [.5 .5 .5].*0, 'MarkerFaceColor',[.5 .5 .5].*0, 'MarkerSize', 3)
xlim([0.5 2.5])
ylim([40 120])
yticks(10:20:90)
ylabel("Performance (%)")
box off


Y_G(1:length(females),1) = Grouping_70(females,2);
Y_G(1:length(males),2) = Grouping_70(males,2);

nexttile;
violin(Y_G, 'x', [1 2], 'facecolor', [.85 .85 .85; 0 0 0; .85 .85 .85; 0 0 0], 'edgecolor', 'k', 'mc', [], 'medc', [])
box off
hold on
plot(repmat(1,10,1), Y_G(:,1), 'o', 'MarkerEdgeColor', [.5 .5 .5], 'MarkerFaceColor',[.5 .5 .5], 'MarkerSize', 3)
plot(repmat(2,10,1), Y_G(:,2), 'o', 'MarkerEdgeColor', [.5 .5 .5].*0, 'MarkerFaceColor',[.5 .5 .5].*0, 'MarkerSize', 3)
xlim([0.5 2.5])
ylim([40 120])
yticks(10:20:90)
ylabel("Performance (%)")
box off

%% statistics
[~,p_D, ci_D, stats_D] = ttest2(Y_D(:,1), Y_D(:,2));
[~,p_G,ci_G,stats_G] = ttest2(Y_G(:,1), Y_G(:,2));


%% plot days to reach criteria
Y_D = nan(10,2);
Y_G = nan(10,2);

Y_D(1:length(females),1) = Discrimination_70(females,1);
Y_D(1:length(males),2) = Discrimination_70(males,1);

Y_G(1:length(females),1) = Grouping_70(females,1);
Y_G(1:length(males),2) = Grouping_70(males,1);


figure
tiledlayout(1,2)
nexttile;
boxplot(Y_D)
box off
ylim([0 12])
nexttile;
boxplot(Y_G)
box off
ylim([0 12])





