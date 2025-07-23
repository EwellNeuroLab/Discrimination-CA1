%% main script to analyze spatial remapping of place cells between two contexts

% all discrimination session
workdir_d = ["F:\Included miniscope Mice\M119\TrainingD11\"  "F:\Included miniscope Mice\M120\TrainingD11\"  "F:\Included miniscope Mice\M292\TrainingD6\"  "F:\Included miniscope Mice\M319\TrainingD7\" "D:\Grouping First\M231\TrainingD9\" "D:\Grouping First\M314\Training_Separation_D5\" "D:\Grouping First\M316\Training_Separation_D6\"  "D:\Grouping First\M318\Training_Separation_D4\" "F:\Included miniscope Mice\M210\TrainingD17\"];
% all generalization session
workdir_g = ["F:\Included miniscope Mice\M119\GroupingD6\" "F:\Included miniscope Mice\M120\GroupingD6\" "F:\Included miniscope Mice\M292\GroupingD3\" "F:\Included miniscope Mice\M319\GroupingD4\" "D:\Grouping First\M231\GroupingD5\" "D:\Grouping First\M314\GroupingD3\" "D:\Grouping First\M316\GroupingD3\" "D:\Grouping First\M318\GroupingD3\" ];
%label for D1 and G1 cohorts & sex
discrimination = [1 1 1 1 2 2 2 2 1];
grouping = [2 2 2 2 1 1 1 1 0];
Sex = ["f" "f" "f" "m" "f" "m" "m" "m"];

%colors for cohorts
colors = ["#CAEA3B" "#93EB74" "#BCEAC5" "#6C1FEB" "#875FEA" "#D093EB" ];

used_days = [3 11; 3 11; 2 6; 2 7; 2 9; 2 5; 2 6; 2 4];
used_days_g = [6 6 3 4 5 3 3 3];
PerformanceDays = nan(9,3);
%% get performance
for i = 1:length(perf_folder)
    load(strcat(perf_folder(i), "Performance_d.mat"))
    PerformanceDays(i,1:2) = Performance(used_days(i,:),1);
    clear Performance
    if i < 9
        load(strcat(perf_folder(i), "Performance_g.mat"))
        PerformanceDays(i,3) = Performance(used_days_g(i),1);
        clear Performance
    end
end
%% add m210 (only trained discrimination)
load("F:\Included miniscope Mice\M210\Performance_d.mat")
PerformanceDays(i+1,2) = Performance(17,1);
%% get pearsons
[All_D, Cohort_D, Individual_D] =  Wrap_Remap_Spatial(workdir_d,discrimination);
[All_G, Cohort_G, Individual_G] =  Wrap_Remap_Spatial(workdir_g,discrimination);
[All_Df, Cohort_Df, Individual_Df] =  Wrap_Remap_Spatial(workdir_df,discrimination);

%% subsample disc 1 and group 1 and compare it to group 2
[DistDifference_DG, p_val_DG] = SubSamplePopulation(Cohort_D.Remap{1}, Cohort_G.Remap{1}, 500);
[DistDifference_GG, p_val_GG] = SubSamplePopulation(Cohort_G.Remap{2}, Cohort_G.Remap{1}, 500);

[DistDifference_DGAll, p_val_DGAll] = SubSamplePopulation(All_D.Remap, All_G.Remap, 500);


%% plot
close all
[yd,xd] = ecdf(All_D.Remap);
[yg,xg] = ecdf(All_G.Remap);
p_all = ranksum(All_D.Remap, All_G.Remap);

figure
tiledlayout(1,3)
nexttile;
hold on
plot(xd,yd, "g-", "LineWidth", 3, Color=colors(1))
plot(xg,yg, "b-", "LineWidth", 3, Color=colors(4))
xlim([-0.2 1])
xlabel("Spatial correlation")
ylabel("Portion")
title("All cohorts")
box off
legend("Discrimination", "Grouping", "Location","northwest")
axis square
titles= ["Discrimination 1st", "Grouping 1st"];
p_cohort= zeros(2,2);
for i = 1:2
    p_cohort(i,i) = ranksum(Cohort_D.Remap{i}, Cohort_G.Remap{i});
    [ydc{i},xdc{i}] = ecdf(Cohort_D.Remap{i});
    [ygc{i},xgc{i}] = ecdf(Cohort_G.Remap{i});
    nexttile;
    hold on
    plot(xdc{i},ydc{i}, "-", "LineWidth", 3, Color=colors(1+i))
    plot(xgc{i},ygc{i}, "-", "LineWidth", 3, Color=colors(4+i))
    xlabel("Spatial correlation")
    ylabel("Portion")
    title(titles(i))
    box off
    legend("Discrimination", "Grouping", "Location","northwest")
    axis square
    xlim([-0.2 1])
end

%% individual cohorts
figure
tiledlayout(2,2)
titles= ["Discrimination 1st", "Grouping 1st"];
p_cohort= zeros(2,2);
for i = 1:2
    p_cohort(i,i) = ranksum(Cohort_D.Remap{i}, Cohort_G.Remap{i});
    [ydc{i},xdc{i}] = ecdf(Cohort_D.Remap{i});
    [ygc{i},xgc{i}] = ecdf(Cohort_G.Remap{i});
    nexttile;
    hold on
    plot(xdc{i},ydc{i}, "-", "LineWidth", 3, Color=colors(1+i))
    plot(xgc{i},ygc{i}, "-", "LineWidth", 3, Color=colors(4+i))
    xlabel("Spatial correlation")
    ylabel("Portion")
    title(titles(i))
    box off
    legend("Discrimination", "Grouping", "Location","northwest")
    axis square
    xlim([-0.2 1])
end

nexttile;
hold on
plot(xdc{1},ydc{1}, "-", "LineWidth", 3, Color=colors(2))
plot(xdc{2},ydc{2}, "-", "LineWidth", 3, Color=colors(3))
xlabel("Spatial correlation")
ylabel("Portion")
title("Discrimination")
box off
legend("Discrimination 1st", "Discrimination 2nd", "Location","northwest")
axis square
xlim([-0.2 1])
p_cohort(1,2)= ranksum(Cohort_D.Remap{1}, Cohort_D.Remap{2});
p_cohort(2,1)= ranksum(Cohort_G.Remap{1}, Cohort_G.Remap{2});

nexttile;
hold on
plot(xgc{1},ygc{1}, "-", "LineWidth", 3, Color=colors(5))
plot(xgc{2},ygc{2}, "-", "LineWidth", 3, Color=colors(6))
xlabel("Spatial correlation")
ylabel("Portion")
title("Grouping")
box off
legend("Grouping 2nd", "Grouping 1st", "Location","northwest")
xlim([-0.2 1])
axis square

figure
hold on
plot(xdc{1},ydc{1}, "-", "LineWidth", 3, Color=colors(2))
plot(xdc{2},ydc{2}, "-", "LineWidth", 3, Color=colors(3))
plot(xgc{1},ygc{1}, "-", "LineWidth", 3, Color=colors(5))
plot(xgc{2},ygc{2}, "-", "LineWidth", 3, Color=colors(6))

axis square
xlim([-0.2 1])
box off

%% individual mice

figure
tiledlayout("flow")
titles = ["M119" "M120" "M292" "M319" "M231" "M314" "M316" "M318"];


for i = 1:8
    [ydm, xdm] = ecdf(Individual_D.Remap{i});
    [ygm, xgm] = ecdf(Individual_G.Remap{i});

    nexttile;
    hold on
    plot(xdm,ydm, "-", "LineWidth", 3, Color=colors(2+(discrimination(i)-1)))
    plot(xgm,ygm, "-", "LineWidth", 3, Color=colors(5+(discrimination(i)-1)))
    xlabel("Spatial correlation")
    ylabel("Portion")
    title(titles(i))
    box off
    legend("Discrimination", "Grouping", "Location","northwest")

end

[ydm, xdm] = ecdf(Individual_D.Remap{9});
nexttile;
plot(xdm,ydm, "-", "LineWidth", 3, Color=colors(2+(discrimination(9)-1)))
xlabel("Spatial correlation")
ylabel("Portion")
title("M210")
box off

%look at within stability in the pooled data set
[yds, xds] = ecdf(All_D.Stability);
[ygs, xgs] = ecdf(All_G.Stability);

figure
tiledlayout(2,2)
nexttile;
hold on
plot(xds,yds, "g-", "LineWidth", 3, Color=colors(1))
plot(xgs,ygs, "b-", "LineWidth", 3, Color=colors(4))
xlabel("Spatial correlation")
ylabel("Portion")
title("Stability of cells")
box off
legend("Discrimination", "Grouping", "Location","northwest")


nexttile;
hold on
for i = 1:8
    plot([1 2], [Individual_D.Percentage(i) Individual_G.Percentage(i)].*100, 'ko-', 'MarkerFaceColor','k')
end
plot(1, Individual_D.Percentage(9).*100, 'ko', 'MarkerFaceColor','k')
xlim([0 3])
xticks([1 2])
xticklabels({"Discrimination", "Grouping"})
ylabel("% of cells")

nexttile;
histogram([All_D.Rate; All_G.Rate] , "Normalization","probability")
xlabel("Total Rate (event/min)")
ylabel("Probability")
box off

nexttile;
plot(All_D.Remap, All_D.Rate, '.', Color=colors(1))
hold on;
plot(All_G.Remap, All_G.Rate, '.', Color=colors(4))
box off
xlabel("Pearson's r")
ylabel("Rate (event/min)")
legend("Discrimination", "Grouping", "Location","northwest")


figure
tiledlayout(2,3)

for i= 1:2
    nexttile;
    hold on
    histogram(DistDifference_DG(:,i), 'FaceColor', 'k', "Normalization","probability")
    box off
    xlabel("Disc-Group")
    ylabel("Probability")
    xline(median(DistDifference_DG(:,i)), ' k-', "LineWidth",2)
    xline(prctile(Cohort_D.Remap{1},i*25)-prctile(Cohort_G.Remap{1},i*25), ' r-', "LineWidth",2)
end
nexttile;
hold on
histogram(p_val_DG, 'FaceColor', 'k', "Normalization","probability")
box off
xlabel("p value")
ylabel("Probability")
xline(median(p_val_DG), ' k-', "LineWidth",2)
xline(p_cohort(1,1), ' r-', "LineWidth",2)


for i= 1:2
    nexttile;
    hold on
    histogram(DistDifference_GG(:,i), 'FaceColor', 'k', "Normalization","probability")
    box off
    xlabel("Group1-Group2")
    ylabel("Probability")
    xline(median(DistDifference_GG(:,i)), ' k-', "LineWidth",2)
    xline(prctile(Cohort_G.Remap{2},i*25)-prctile(Cohort_G.Remap{1},i*25), ' r-', "LineWidth",2)
end
nexttile;
hold on
histogram(p_val_GG, 'FaceColor', 'k', "Normalization","probability")
box off
xlabel("p value")
ylabel("Probability")
xline(median(p_val_GG), ' k-', "LineWidth",2)
xline(p_cohort(2,1), ' r-', "LineWidth",2)


%% plot population vector
figure
hold on
bar(1, mean(Individual_D.PV), FaceColor=colors(1))
bar(2, mean(Individual_G.PV), FaceColor=colors(4))
bar(3, mean(Individual_D.PV([1:4 9])), FaceColor=colors(2))
bar(4, mean(Individual_G.PV(1:4)), FaceColor=colors(5))
bar(5, mean(Individual_D.PV(5:8)), FaceColor=colors(3))
bar(6, mean(Individual_G.PV(5:8)), FaceColor=colors(6))


plot(ones(9,1), Individual_D.PV, "ko")
plot(repmat(2,8,1), Individual_G.PV, "ko")
plot(repmat(3,5,1), Individual_D.PV([1:4 9]), "ko")
plot(repmat(4,4,1), Individual_G.PV(1:4), "ko")
plot(repmat(5,4,1), Individual_D.PV(5:8), "ko")
plot(repmat(6,4,1), Individual_G.PV(5:8), "ko")
xlim([0 7])
ylim([0 1])
ylabel("Mean PV correlation")
box off
xticks(1:6)
xticklabels({"Disc all", "Group all", "Disc 1st", "Group 2nd", "Disc 2nd", "Group 1st"})


figure
histogram(p_val_DGAll, "FaceColor", "k", "Normalization", "probability")
xline(p_all, "r-", "LineWidth",2)
box off
xlabel("p-value")
ylabel("Probability")
legend("Subsampled", "True p", "Location","northeast")

%% now compare discrimination early and late day
[ydf,xdf] = ecdf(All_Df.Remap);

figure
tiledlayout(1,3)
nexttile;
plot(xdf,ydf,LineWidth=3,LineStyle="--", Color=colors(1))
hold on
plot(xd,yd,LineWidth=3, Color=colors(1))

nexttile;

plot(zeros(9,1), PerformanceDays(:,1), 'ko', "MarkerFaceColor","k")
hold on
plot(ones(9,1), PerformanceDays(:,2), 'ko', "MarkerFaceColor","k")
xticks([0 1])
xticklabels({"Early", "Trained"})
xlim([-0.5 1.5])
ylabel("Performance (%)")

naiveEarly = find(PerformanceDays(:,1) < 60);
trainedEarly =  find(PerformanceDays(:,1) > 60);

naiveEarlyR =  GetSubsetRemap(naiveEarly, Individual_Df);
trainedEarlyR =  GetSubsetRemap(trainedEarly, Individual_Df);

[yne,xne] = ecdf(naiveEarlyR);
[yte,xte] = ecdf(trainedEarlyR);

nexttile;
plot(xne,yne, Color="k")
hold on
plot(xte,yte, Color=[.5 .5 .5])

%% do statistics on the cohorts - Kruskal-Wallis w/ multiple comparison
KW_inputData = [];
KW_inputLabel = [];
for i = 1:2
   KW_inputData = [KW_inputData; Cohort_D.Remap{i}]; 
   KW_inputLabel = [KW_inputLabel; repmat(strcat("D", num2str(i)), length(Cohort_D.Remap{i}),1)];
   KW_inputData = [KW_inputData; Cohort_G.Remap{i}]; 
   KW_inputLabel = [KW_inputLabel; repmat(strcat("G", num2str(i)), length(Cohort_G.Remap{i}),1)];
end

[p,tbl, stats] = kruskalwallis(KW_inputData, KW_inputLabel, 'off');
figure
c = multcompare(stats, "CriticalValueType", "bonferroni");


function subset =  GetSubsetRemap(idx, Individual)
        subset = [];

        for i = 1:length(idx)
            subset = [subset; Individual.Remap{idx(i)}];
        end
end

%% get stats
[p_DG_D1,~, stats_DG_D1] = ranksum(Cohort_D.Remap{1}, Cohort_G.Remap{1});
[p_DG_G1,~, stats_DG_G1] = ranksum(Cohort_D.Remap{2}, Cohort_G.Remap{2});

[p_DD,~, stats_DD] = ranksum(Cohort_D.Remap{1}, Cohort_D.Remap{2});
[p_GG,~, stats_GG] = ranksum(Cohort_G.Remap{1}, Cohort_G.Remap{2});