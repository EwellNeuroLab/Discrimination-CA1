%% main script to analyze rate remapping
% discrimination sessions

workdir_d = ["F:\Included miniscope Mice\M119\TrainingD11\"  "F:\Included miniscope Mice\M120\TrainingD11\"  "F:\Included miniscope Mice\M292\TrainingD6\"  "F:\Included miniscope Mice\M319\TrainingD7\" "D:\Grouping First\M231\TrainingD9\" "D:\Grouping First\M314\Training_Separation_D5\" "D:\Grouping First\M316\Training_Separation_D6\"  "D:\Grouping First\M318\Training_Separation_D4\" "F:\Included miniscope Mice\M210\TrainingD17\"];
workdir_g = ["F:\Included miniscope Mice\M119\GroupingD6\" "F:\Included miniscope Mice\M120\GroupingD6\" "F:\Included miniscope Mice\M292\GroupingD3\" "F:\Included miniscope Mice\M319\GroupingD4\" "D:\Grouping First\M231\GroupingD5\" "D:\Grouping First\M314\GroupingD3\" "D:\Grouping First\M316\GroupingD3\" "D:\Grouping First\M318\GroupingD3\" ];
discrimination = [1 1 1 1 2 2 2 2 1];
grouping = [2 2 2 2 1 1 1 1 0];
OverlappingWall = [2 2 1 1 2 1 2 1 1];
Sex = ["f" "f" "f" "m" "f" "m" "m" "m"];
colors = ["#CAEA3B" "#93EB74" "#BCEAC5" "#6C1FEB" "#875FEA" "#D093EB" ];


[All_d, Cohort_d, Individual_d] = WrapRateOverlap(workdir_d, discrimination);
[All_g, Cohort_g, Individual_g] = WrapRateOverlap(workdir_g, discrimination);


[DistDifference_DGAll, p_val_DGAll] = SubSamplePopulation(All_d.ROS, All_g.ROS, 500);

%% create cdfs for all data & plot
[ydAll, xdAll] = ecdf(All_d.ROS);
[ygAll, xgAll] = ecdf(All_g.ROS);

[ydRAll, xdRAll] = ecdf(All_d.RewROS);
[ygRAll, xgRAll] = ecdf(All_g.RewROS);

[ydOAll, xdOAll] = ecdf(All_d.OutROS);
[ygOAll, xgOAll] = ecdf(All_g.OutROS);

p_All = ranksum(All_d.ROS , All_g.ROS);
p_SplittedAll = [ranksum(Cohort_d.ROS{1} , Cohort_g.ROS{1} ); ranksum(Cohort_d.ROS{2} , Cohort_g.ROS{2} )];

p_splittedCohort = zeros(2,2);

for i = 1:2

    p_splittedCohort(i,:)= [ranksum(Cohort_d.RewROS{i} , Cohort_g.RewROS{i} ); ranksum(Cohort_d.OutROS{i} , Cohort_g.OutROS{i} )];
end

close all
figure
tiledlayout(1,2)

nexttile;
plot(xdAll,ydAll, Color=colors(1), LineWidth=3)
hold on
plot(xgAll,ygAll, Color=colors(4), LineWidth=3)
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title("Pooled Data")
legend("Disc.", "Group.", "Location","northwest")
axis square

nexttile;
plot(xdRAll,ydRAll, Color=colors(1), LineWidth=2, LineStyle="--")
hold on
plot(xgRAll,ygRAll, Color=colors(4), LineWidth=2, LineStyle="--")
plot(xdOAll,ydOAll, Color=colors(1), LineWidth=2, LineStyle=":")
plot(xgOAll,ygOAll, Color=colors(4), LineWidth=2, LineStyle=":")
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title("Pooled Data")
legend("D_{rew}", "G_{rew}", "D_{out}", "G_{out}", "Location", "northwest")
axis square

%% same for cohorts
for i =1:2
    [ydCoh{i}, xdCoh{i}] = ecdf(Cohort_d.ROS{i});
    [ygCoh{i}, xgCoh{i}] = ecdf(Cohort_g.ROS{i});

    [ydRCoh{i}, xdRCoh{i}] = ecdf(Cohort_d.RewROS{i});
    [ygRCoh{i}, xgRCoh{i}] = ecdf(Cohort_g.RewROS{i});

    [ydOCoh{i}, xdOCoh{i}] = ecdf(Cohort_d.OutROS{i});
    [ygOCoh{i}, xgOCoh{i}] = ecdf(Cohort_g.OutROS{i});
end

titles = ["Disc 1st", "Group 1st"];

figure
tiledlayout(2,2)
for i = 1:2
    nexttile;
    plot(xdCoh{i}, ydCoh{i}, LineWidth=3, Color=colors(1+i))
    hold on
    plot(xgCoh{i}, ygCoh{i}, LineWidth=3, Color=colors(4+i))
    box off
    xlabel("Rate Overlap Score")
    ylabel("Portion")
    title(titles(i))
    axis square
end

nexttile;
i= 1;
plot(xdCoh{i}, ydCoh{i}, LineWidth=3, Color=colors(1+i))
hold on
i = 2;
plot(xdCoh{i}, ydCoh{i}, LineWidth=3, Color=colors(1+i))
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
axis square


nexttile;
i= 1;
plot(xgCoh{i}, ygCoh{i}, LineWidth=3, Color=colors(4+i))
hold on
i = 2;
plot(xgCoh{i}, ygCoh{i}, LineWidth=3, Color=colors(4+i))
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
axis square


figure
tiledlayout(1,2)
for i = 1:2
    nexttile;
    plot(xdRCoh{i}, ydRCoh{i}, LineWidth=3, Color=colors(1+i), LineStyle="--")
    hold on
    plot(xgRCoh{i}, ygRCoh{i}, LineWidth=3, Color=colors(4+i), LineStyle="--")
    plot(xdOCoh{i}, ydOCoh{i}, LineWidth=3, Color=colors(1+i), LineStyle=":")
    plot(xgOCoh{i}, ygOCoh{i}, LineWidth=3, Color=colors(4+i), LineStyle=":")
    box off
    xlabel("Rate Overlap Score")
    ylabel("Portion")
    title(titles(i))
    axis square
    plot([0 1], [0 0.7], "k-")
end

%% compare all subsets of fields between cohort 1 and 2

p_cohortCompare = zeros(2,2);
p_cohortCompare(1,1) = ranksum(Cohort_d.RewROS{1}, Cohort_d.RewROS{2});
p_cohortCompare(1,2) = ranksum(Cohort_d.OutROS{1}, Cohort_d.OutROS{2});

p_cohortCompare(2,1) = ranksum(Cohort_g.RewROS{1}, Cohort_g.RewROS{2});
p_cohortCompare(2,2) = ranksum(Cohort_g.OutROS{1}, Cohort_g.OutROS{2});

figure
tiledlayout("flow")

nexttile;
hold on
for i = 1:2
    plot(xdRCoh{i}, ydRCoh{i}, LineWidth=3, Color=colors(1+i), LineStyle="--")
end
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title(titles(i))
axis square


nexttile;
hold on
for i = 1:2
    plot(xdOCoh{i}, ydOCoh{i}, LineWidth=3, Color=colors(1+i), LineStyle=":")
end
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title(titles(i))
axis square


nexttile;
hold on
for i = 1:2
    plot(xgRCoh{i}, ygRCoh{i}, LineWidth=3, Color=colors(4+i), LineStyle="-")
end
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title(titles(i))
axis square


nexttile;
hold on
for i = 1:2
    plot(xgOCoh{i}, ygOCoh{i}, LineWidth=3, Color=colors(4+i), LineStyle="-")
end
box off
xlabel("Rate Overlap Score")
ylabel("Portion")
title(titles(i))
axis square
%% plot the same things for individual mice
titles = ["M119" "M120" "M292" "M319" "M231" "M314" "M316" "M318"];

figure
tiledlayout("flow")
for m =1:8

    [yd,xd] = ecdf(Individual_d.ROS{m});
    [yg,xg] = ecdf(Individual_g.ROS{m});


    nexttile;
    hold on
    plot(xd,yd, "-", "LineWidth", 3, Color=colors(2+(discrimination(m)-1)))
    plot(xg,yg, "-", "LineWidth", 3, Color=colors(5+(discrimination(m)-1)))
    xlabel("Rate Overlap Score")
    ylabel("Portion")
    title(titles(m))
    box off
    legend("Disc.", "Group.", "Location","northwest")
end

[yd, xd] = ecdf(Individual_d.ROS{9});
nexttile;
plot(xd,yd, "-", "LineWidth", 3, Color=colors(2+(discrimination(9)-1)))
xlabel("Rate Overlap Score")
ylabel("Portion")
title("M210")
box off


figure
tiledlayout("flow")
for m =1:8

    [ydr,xdr] = ecdf(Individual_d.RewROS{m});
    [ydo,xdo] = ecdf(Individual_d.OutROS{m});
    [ygr,xgr] = ecdf(Individual_g.RewROS{m});
    [ygo,xgo] = ecdf(Individual_g.OutROS{m});


    nexttile;
    hold on
    plot(xdr,ydr, "--", "LineWidth", 3, Color=colors(2+(discrimination(m)-1)))
    plot(xgr,ygr, "--", "LineWidth", 3, Color=colors(5+(discrimination(m)-1)))
    plot(xdo,ydo, ":", "LineWidth", 3, Color=colors(2+(discrimination(m)-1)))
    plot(xgo,ygo, ":", "LineWidth", 3, Color=colors(5+(discrimination(m)-1)))
    xlabel("Rate Overlap Score")
    ylabel("Portion")
    title(titles(m))
    box off
    legend("Disc.", "Group.", "Location","northwest")
    legend("D_{rew}", "G_{rew}", "D_{out}", "G_{out}", "Location", "northwest")
end

[ydr,xdr] = ecdf(Individual_d.RewROS{m+1});
[ydo,xdo] = ecdf(Individual_d.OutROS{m+1});
nexttile;
hold on
plot(xdr,ydr, "--", "LineWidth", 3, Color=colors(2+(discrimination(m+1)-1)))
plot(xdo,ydo, ":", "LineWidth", 3, Color=colors(2+(discrimination(m+1)-1)))
title("M210")


%% now get reward distance ROS - relationship
[ROSdist_d,counts_d, edges_d] = GetROS_Dist(All_d.RewDist, All_d.ROS);
[ROSdist_g,counts_g, edges_g] = GetROS_Dist(All_g.RewDist, All_g.ROS);

for j = 1:2
    [ROSdist_Cohd{j},~, edges_Cohd{j}] = GetROS_Dist(Cohort_d.RewDist{j}, Cohort_d.ROS{j});
    [ROSdist_Cohg{j},~, edges_Cohg{j}] = GetROS_Dist(Cohort_g.RewDist{j}, Cohort_d.ROS{j});
end

figure
tiledlayout(2,2)
nexttile;
bar(edges_d*2+2.5, counts_d./sum(counts_d).*100, "FaceColor",colors(1))
hold on
bar(edges_g*2+2.5, counts_g./sum(counts_g).*100, "FaceColor",colors(4), "FaceAlpha", 0.5)
box off
xlabel("Distance from reward (cm)")
ylabel("Probability")
xline(10, '--')

i = 2;
nexttile;
plot(edges_d*2+2.5, ROSdist_d(:,i), "o-", "Color",colors(1), "MarkerFaceColor",colors(1))
hold on
plot(edges_g*2+2.5, ROSdist_g(:,i), "o-", "Color",colors(4), "MarkerFaceColor",colors(4))
xlabel("Distance from reward (cm)")
ylabel(strcat(num2str(i*25),"th %ile ROS"))
box off
xline(10, '--')



for j = 1:2
    nexttile;
    plot(edges_Cohd{j}*2+2.5, ROSdist_Cohd{j}(:,i), "o-", "Color",colors(1+j), "MarkerFaceColor",colors(1+j))
    hold on
    plot(edges_Cohg{j}*2+2.5, ROSdist_Cohg{j}(:,i), "o-", "Color",colors(4+j), "MarkerFaceColor",colors(4+j))
    xlabel("Distance from reward (cm)")
    ylabel(strcat(num2str(i*25),"th %ile ROS"))
    box off
    xline(10, '--')
end

%% plot distribution bin by bin for discirmination and for grouping
figure
tiledlayout(1,2)

nexttile;
hold on
box off

crange = 1:-1/length(nonzeros(counts_d)):0.2;
for i = 1:length(nonzeros(counts_d))
    idx_d =  find(All_d.RewDist < edges_d(i+1) & All_d.RewDist >= edges_d(i) );
    [ysub_d, xsub_d] = ecdf(All_d.ROS(idx_d));
    plot(xsub_d, ysub_d, LineWidth=3, Color=[216 250 63]./256.*crange(i))

end
plot([0 1], [0 1], 'k--')
plot([0 1]+0.2, [0 1], 'k--')
nexttile;
hold on
box off

crange = 1:-1/length(nonzeros(counts_g)):0;
for i = 1:length(nonzeros(counts_g))
    idx_g =  find(All_g.RewDist < edges_g(i+1) & All_g.RewDist >= edges_g(i) );
    [ysub_g, xsub_g] = ecdf(All_g.ROS(idx_g));
    plot(xsub_g, ysub_g, LineWidth=3, Color=[115 32 250]./256.*crange(i))
end
plot([0 1], [0 1], 'k--')
plot([0 1]+0.2, [0 1], 'k--')

%% plot distributions in the first 5 bins
N_events_sub = cell(5,2);
p_sub = zeros(5,1);
figure
tiledlayout("flow")
for i =1:5
    idx_d =  find(All_d.RewDist < edges_d(i+1) & All_d.RewDist >= edges_d(i) );
    [ysub_d, xsub_d] = ecdf(All_d.ROS(idx_d));
    N_events_sub{i,1} = All_d.N_events(idx_d);
    idx_g =  find(All_g.RewDist < edges_g(i+1) & All_g.RewDist >= edges_g(i) );
    [ysub_g, xsub_g] = ecdf(All_g.ROS(idx_g));
    N_events_sub{i,2} = All_g.N_events(idx_g);
    p_sub(i) = ranksum(All_d.ROS(idx_d), All_g.ROS(idx_g));

    nexttile;
    plot(xsub_d, ysub_d, LineWidth=3, Color=colors(1))
    hold on
    plot(xsub_g, ysub_g, LineWidth=3, Color=colors(4))
    box off
    xlabel("Rate Overlap Score")
    ylabel("Portion")
    title(strcat("Reward dist = [", num2str(edges_d(i)*2), "; ", num2str(edges_d(i+1)*2), "]"))
end





%% show reward fields (distance <= 10 cm) w/ and w/o match cells
figure
tiledlayout(1,2)
nexttile;

[ydr1,xdr1] = ecdf(All_d.RewROS);
[ygr1,xgr1] = ecdf(All_g.RewROS);

hold on
%plot(xdr1,ydr1, Color=colors(1), LineStyle="--", LineWidth=3)
plot(xgr1,ygr1, Color=colors(4), LineStyle="-", LineWidth=3)
axis square

% include only neutral and mismatch fields (firingpref < 0.333)
idx_mm_exc = find(All_d.Pref > -1/3);
idx_m_exc = find(All_d.Pref < 1/3);

[ydr2,xdr2] = ecdf(All_d.RewROS(idx_m_exc));
[ydr3,xdr3] = ecdf(All_d.RewROS(idx_mm_exc));


%plot(xdr2,ydr2, Color=colors(1), LineStyle=":", LineWidth=3)
plot(xdr3,ydr3, Color=colors(1), LineStyle="-", LineWidth=3)
legend("All D", "All G", "Match excluded", "Mismatch excluded", "Location","northwest")
xlabel("Rate Overlap")

nexttile;
idx_mm = find(All_d.Pref <= -1/3);
idx_m = find(All_d.Pref >= 1/3);
idx_n = find(All_d.Pref < 1/3 & All_d.Pref > -1/3);

[ydrm,xdrm] = ecdf(All_d.RewROS(idx_m));
[ydrmm,xdrmm] = ecdf(All_d.RewROS(idx_mm));
[ydrn,xdrn] = ecdf(All_d.RewROS(idx_n));

plot(xdrm,ydrm, Color=colors(1), LineStyle="-.", LineWidth=3)
hold on
plot(xdrmm,ydrmm, Color=colors(1), LineStyle=":", LineWidth=3)
plot(xdrn,ydrn, Color=colors(1), LineStyle="-", LineWidth=3)
plot(xgr1,ygr1, Color=colors(4), LineStyle="--", LineWidth=3)
legend("only match", "only mismatch", "only neutral", "All G","Location","northwest")

%% figure - # of fields and field size

figure
tiledlayout(2,2)
nexttile;
histogram(All_d.NFields, "Normalization", "percentage", "EdgeColor",colors(1), "FaceColor",colors(1))
box off
xlabel("# of fields")
ylabel("% of PCs")

nexttile;
histogram(All_g.NFields, "Normalization", "percentage", "EdgeColor",colors(4), "FaceColor",colors(4))
box off
xlabel("# of fields")
ylabel("% of PCs")


nexttile;
histogram(All_d.Size, "Normalization", "percentage", "EdgeColor",colors(1), "FaceColor",colors(1))
box off
xlabel("Area (cm{^2})")
ylabel("% of PCs")
xticks([50 100 150 200])
xticklabels({"100", "200", "300", "400"})

nexttile;
histogram(All_g.Size, "Normalization", "percentage", "EdgeColor",colors(4), "FaceColor",colors(4))
box off
xlabel("Area (cm{^2})")
ylabel("% of PCs")
xticks([50 100 150 200])
xticklabels({"100", "200", "300", "400"})


%% figure  - # of reward fields at overlapping walls
Overlapping = 0;
for i = 1:9
    Overlapping = Overlapping+Individual_d.NRewField(i,OverlappingWall(i));
end

figure
tiledlayout(1,2)
nexttile;
bar(Overlapping/sum(Individual_d.NRewField, "all")*100, "FaceColor", colors(1))
ylabel("% of reward fields at overlapping wall")
yline(50, '--')
hold on
for i = 1:9
    plot(1, Individual_d.NRewField(i,OverlappingWall(i))/sum(Individual_d.NRewField(i,:))*100, 'ko', "MarkerFaceColor","k");
end
ylim([0 100])


%mismatch fields at the overlapping wall

Overlapping_mm = 0;
for i = 1:9
    Overlapping_mm = Overlapping_mm+Individual_d.NMismatch(i,OverlappingWall(i));
end

nexttile;
bar(Overlapping_mm/sum(Individual_d.NMismatch, "all")*100, "FaceColor", colors(1))
ylabel("% of reward fields at overlapping wall")
yline(50, '--')
hold on
for i = 1:9
    plot(1, Individual_d.NMismatch(i,OverlappingWall(i))/sum(Individual_d.NMismatch(i,:))*100, 'ko', "MarkerFaceColor","k");
end
ylim([0 100])


%% statistics - Kruskal-Wallis on reward/non-reward fields w/ multiple-comparison

KW_inputData = {[] []};
KW_inputLabel = {[] []};
for i = 1:2

    KW_inputData{i} = [KW_inputData{i}; Cohort_g.RewROS{i}];
    KW_inputLabel{i} = [KW_inputLabel{i}; repmat(strcat("GR", num2str(i)), length(Cohort_g.RewROS{i}),1)];
    KW_inputData{i} = [KW_inputData{i}; Cohort_g.OutROS{i}];
    KW_inputLabel{i} = [KW_inputLabel{i}; repmat(strcat("GNR", num2str(i)), length(Cohort_g.OutROS{i}),1)];

    KW_inputData{i} = [KW_inputData{i}; Cohort_d.RewROS{i}];
    KW_inputLabel{i} = [KW_inputLabel{i}; repmat(strcat("DR", num2str(i)), length(Cohort_d.RewROS{i}),1)];
    KW_inputData{i} = [KW_inputData{i}; Cohort_d.OutROS{i}];
    KW_inputLabel{i} = [KW_inputLabel{i}; repmat(strcat("DNR", num2str(i)), length(Cohort_d.OutROS{i}),1)];


end

i=2;
[p,tbl, stats] = kruskalwallis(KW_inputData{i}, KW_inputLabel{i}, 'off');

figure
c = multcompare(stats, "CriticalValueType", "lsd");

%% pie chart of non-reward & reward
figure
tiledlayout(2,2)
NRew_D = cellfun(@length, Cohort_d.RewROS);
NOut_D = cellfun(@length, Cohort_d.OutROS);
NRew_G = cellfun(@length, Cohort_g.RewROS);
NOut_G = cellfun(@length, Cohort_g.OutROS);

for i = 1:2
    nexttile;
    piechart([NRew_D(i) NOut_D(i)])
    nexttile;
    piechart([NRew_G(i) NOut_G(i)])
end


%% plot comparisons - reward vs reward , nonrew vs nonrew for both cohorts
figure
tiledlayout(2,2)

for i = 1:2
    nexttile;
    plot(xdRCoh{i}, ydRCoh{i}, "Color", colors(1))
    hold on
    plot(xgRCoh{i}, ygRCoh{i}, "Color", colors(4))
    axis square
    box off

    nexttile;
    plot(xdOCoh{i}, ydOCoh{i}, "Color", colors(1))
    hold on
    plot(xgOCoh{i}, ygOCoh{i}, "Color", colors(4))
    axis square
    box off

end




%% plot # of fields in each distance bin

for j = 1:2
    [ROSdist_Cohd{j},n_Cohd{j}, edges_Cohd{j}] = GetROS_Dist(Cohort_d.RewDist{j}, Cohort_d.ROS{j});
    [ROSdist_Cohg{j},n_Cohg{j}, edges_Cohg{j}] = GetROS_Dist(Cohort_g.RewDist{j}, Cohort_d.ROS{j});
end
n_rewd = [480 391];
n_rewg = [135 175];

figure
tiledlayout(2,2)
for j =1:2
    nexttile;
    bar([n_rewd(j); n_Cohd{j}(3:end)], "FaceColor", colors(1+j))
    box off
    ylim([0 500])
    xlim([0 8.5])
    nexttile;
    bar([n_rewg(j); n_Cohg{j}(3:end)], "FaceColor", colors(4+j))
    box off
    ylim([0 500])
    xlim([0 8.5])
end


%% plot remapping for individual distance
SortedFields_d = cell(2,1);
SortedFields_g = cell(2,1);
dist_pval = cell(2,1);
for n = 1:2
SortedFields_d{n} = nan(350,8);
SortedFields_g{n} = nan(350,8);

for i = 3:length(edges_d)-1
    FieldsToUse = find(Cohort_d.RewDist{n} >= edges_d(i) & Cohort_d.RewDist{n} < edges_d(i+1));
    if ~isempty(FieldsToUse)
        SortedFields_d{n}(1:length(FieldsToUse),i) = Cohort_d.ROS{n}(FieldsToUse);
    end
end

for i = 3:length(edges_g)-1
    FieldsToUse = find(Cohort_g.RewDist{n} >= edges_g(i) & Cohort_g.RewDist{n} < edges_g(i+1));
    if ~isempty(FieldsToUse)
        SortedFields_g{n}(1:length(FieldsToUse),i) = Cohort_g.ROS{n}(FieldsToUse);
    end
end

dist_pval{n} = zeros(3,1);

figure
tiledlayout("flow")
for i = 3:5
    
    [yd,xd] = ecdf(SortedFields_d{n}(:,i));
    [yg,xg] = ecdf(SortedFields_g{n}(:,i));
    dist_pval{n}(i-2) = ranksum(SortedFields_d{n}(:,i), SortedFields_g{n}(:,i));
    nexttile;
    plot(xd,yd,"Color", colors(1+n))
    hold on
    plot(xg,yg,"Color", colors(4+n))
    box off
    axis square

end

dist_pval{n} = dist_pval{n}.*3;
end

% plot binned-nonreward fields

figure
tiledlayout(2,2)

for n = 1:2
    nexttile;
    hold on
    plot(xdRCoh{n}, ydRCoh{n}, "k")
    for i = 3:5
        [yd,xd] = ecdf(SortedFields_d{n}(:,i));
        plot(xd,yd, "Color", [0 0 0]+((i-2)/3))
    end
    box off
    axis square

    nexttile;
    hold on
    plot(xgRCoh{n}, ygRCoh{n}, "k")
    for i = 3:8
        [yd,xd] = ecdf(SortedFields_g{n}(:,i));
        plot(xd,yd, "Color", [0 0 0]+((i-2)/6))
    end
    box off
    axis square
end


%% plot reward + binned non-reward fields and run Kruskal-Wallis w/ dunn
% post-hoc test
multCompare_d = cell(2,1);
multCompare_g = cell(2,1);
tbl_d = cell(2,1);
tbl_g = cell(2,1);
for n = 1:2
    [multCompare_d{n}, ~, tbl_d{n},~]= MultCompareRewDist(Cohort_d.RewROS{n},SortedFields_d{n}, 5, "dunnett");
    [multCompare_g{n}, ~,tbl_g{n},~]= MultCompareRewDist(Cohort_g.RewROS{n},SortedFields_g{n}, 8, "dunnett");
end



function [multCompare, p,tbl,stats] = MultCompareRewDist(RewData, SortedFields, LastBin, CompType)

KW_Distance_data = RewData;
KW_Distance_label = repmat("R", length(RewData),1);

for i = 3:LastBin
        KW_Distance_data = [KW_Distance_data; SortedFields(~isnan(SortedFields(:,i)),i)];
        KW_Distance_label = [KW_Distance_label; repmat(num2str(i*5-2.5), sum(~isnan(SortedFields(:,i))),1)];
end

[p,tbl, stats] = kruskalwallis(KW_Distance_data, KW_Distance_label, 'off');

figure
multCompare = multcompare(stats, "CriticalValueType", CompType);
end