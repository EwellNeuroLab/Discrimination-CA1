% main script for vector remapping

workdir_d = ["F:\Included miniscope Mice\M119\TrainingD11\"  "F:\Included miniscope Mice\M120\TrainingD11\"  "F:\Included miniscope Mice\M292\TrainingD6\"  "F:\Included miniscope Mice\M319\TrainingD7\" "D:\Grouping First\M231\TrainingD9\" "D:\Grouping First\M314\Training_Separation_D5\" "D:\Grouping First\M316\Training_Separation_D6\"  "D:\Grouping First\M318\Training_Separation_D4\" "F:\Included miniscope Mice\M210\TrainingD17\"];
workdir_g = ["F:\Included miniscope Mice\M119\GroupingD6\" "F:\Included miniscope Mice\M120\GroupingD6\" "F:\Included miniscope Mice\M292\GroupingD3\" "F:\Included miniscope Mice\M319\GroupingD4\" "D:\Grouping First\M231\GroupingD5\" "D:\Grouping First\M314\GroupingD3\" "D:\Grouping First\M316\GroupingD3\" "D:\Grouping First\M318\GroupingD3\" ];
discrimination = [1 1 1 1 2 2 2 2 1];
grouping = [2 2 2 2 1 1 1 1 0];
Sex = ["f" "f" "f" "m" "f" "m" "m" "m"];
colors = ["#CAEA3B" "#93EB74" "#BCEAC5" "#6C1FEB" "#875FEA" "#D093EB" ];
SaveExamples = 0;
binCenter = -157.5:45:157.5;
wallsDir = ["SW", "W", "NW", "N", "NE", "E", "SE", "S"];

LightBins_d = [5 6; 3 4];
[All_d, Cohort]= WrapVectorRemap2(workdir_d, discrimination, LightBins_d);
LightBins_g = [1 2; 7 8];
[All_g, Cohort]= WrapVectorRemap2(workdir_g, discrimination, LightBins_g);

%% plot % of orthogonal cells and angular tunining difference
close all
figure
bar(1,sum(All_d.IsOrthogonal{1})/length(All_d.IsOrthogonal{1})*100, FaceColor=colors(1),BarWidth=0.5)
hold on
bar(2,sum(All_d.IsOrthogonal{2})/length(All_d.IsOrthogonal{2})*100, FaceColor=colors(1),BarWidth=0.5)
bar(4,sum(All_g.IsOrthogonal{1})/length(All_g.IsOrthogonal{1})*100, FaceColor=colors(4),BarWidth=0.5)
bar(5,sum(All_g.IsOrthogonal{2})/length(All_g.IsOrthogonal{2})*100, FaceColor=colors(4),BarWidth=0.5)
xticks([1 2 4 5])
xticklabels({"HDC/PC", "HDC only", "HDC/PC", "HDC only"})
ylabel("% of orthogonal cells")
box off


binEdges = 0:45:360;
figure
tiledlayout(2,2)

titles = ["HDC/PC", "HDC"];

for i= 1:2
    nexttile;
    histogram(All_d.AngleDiff{i}(All_d.IsOrthogonal{i}==0), BinEdges=binEdges, FaceColor=colors(1))
    box off
    xlabel("Angular difference")
    ylabel("# of cells")
    title(strcat(titles(i), "non-orthogonal"))
end


for i= 1:2
    nexttile;
    histogram(All_g.AngleDiff{i}(All_g.IsOrthogonal{i}==0), BinEdges=binEdges, FaceColor=colors(4))
    box off
    xlabel("Angular difference")
    ylabel("# of cells")
    title(strcat(titles(i), "non-orthogonal"))
end

% plot mean event rate

figure
tiledlayout(2,2)

for i= 1:2
    nexttile;
    histogram(All_d.MeanRate{i}, FaceColor=colors(1))
    box off
    xlabel("Mean event rate (event/min)")
    ylabel("# of cells")
    title(titles(i))
end

for i= 1:2
    nexttile;
    histogram(All_g.MeanRate{i}, FaceColor=colors(4))
    box off
    xlabel("Mean event rate (event/min)")
    ylabel("# of cells")
    title(titles(i))
end


% plot distribution of tuning strength
p_tuning = zeros(2,2);
figure
tiledlayout(2,2)

for i = 1:2
    nexttile;
    hold on
    p_tuning(1,i) = signrank(All_d.TuningStrength{i}(:,1), All_d.TuningStrength{i}(:,2));
    [y,x] = ecdf(All_d.TuningStrength{i}(:,1));
    plot(x,y, LineWidth=3, Color=colors(1))
    hold on
    [y,x] = ecdf(All_d.TuningStrength{i}(:,2));
    plot(x,y, LineWidth=3, Color=colors(1), LineStyle="--")
    box off
    xlabel("Tuning strength")
    ylabel("Portion")
    legend("Tuned", "Untuned", "Location", "southeast")
    title(titles(i))
end

for i = 1:2
    nexttile;
    hold on
    p_tuning(2,i) = signrank(All_g.TuningStrength{i}(:,1), All_g.TuningStrength{i}(:,2));
    [y,x] = ecdf(All_g.TuningStrength{i}(:,1));
    plot(x,y, LineWidth=3, Color=colors(4))
    hold on
    [y,x] = ecdf(All_g.TuningStrength{i}(:,2));
    plot(x,y, LineWidth=3, Color=colors(4), LineStyle="--")
    box off
    xlabel("Tuning strength")
    ylabel("Portion")
    legend("Tuned", "Untuned", "Location", "southeast")
    title(titles(i))
end


% plot reward tuning
figure
tiledlayout(2,2)
nexttile;
hold on
for i = 1:2
    bar(i, length(find(sum(All_d.RewardTuning{i},2 , 'omitnan')>0))/length(All_d.RewardTuning{i}(:,1))*100, FaceColor=colors(1) )
end
yline(25, '--')
ylabel("% of HD Ccells")
xticks([1 2])
xticklabels({"HDC/PC", "HDC only"})
ylim([0 100])
title("Reward tuned cells")

xpos= [1 2; 4 5];
nexttile;
hold on
for i = 1:2
    bar(xpos(i,1), sum(All_d.Match{i}(:,1) == 0)/sum(~isnan(All_d.Match{i}(:,1)))*100, FaceColor=colors(1))
    bar(xpos(i,2), sum(All_d.Match{i}(:,2) == 0)/sum(~isnan(All_d.Match{i}(:,2)))*100, FaceColor=colors(1))
end
ylabel("% of reward tuned cells")
title("Mismatch cells")
xticks([1 2 4 5])
xticklabels({"ctxt A", "ctxt B", "ctxt A", "ctxt B"})
ylim([0 100])

nexttile;
hold on
for i= 1:2
    for r = 1:2
       bar(r + (i-1)*3,sum(All_d.RewardLoc{i} == r), FaceColor=colors(1))
    end
end
ylabel("# of HDC cells")
xticks([0.75 1.25 1.75 2.25])
xticklabels({"Rew 1", "Rew 2", "Rew 1", "Rew 2"})

nexttile;
hold on
for i = 1:2
    bar(i, length(find(sum(All_g.RewardTuning{i},2 , 'omitnan')>0))/length(All_g.RewardTuning{i}(:,1))*100, FaceColor=colors(4) )
end
yline(12.5, '--')
ylabel("% of HDC cells")
xticks([1 2])
xticklabels({"HDC/PC", "HDC only"})
ylim([0 100])
title("Reward tuned cells")




%plot how many reward tuned HDCPC has reward field
figure
tiledlayout(1,2)
nexttile;
bar(1,sum(All_d.HasRewardField > 0)/sum(~isnan(All_d.HasRewardField))*100, FaceColor = colors(1))
hold on
bar(2,sum(All_g.HasRewardField > 0)/sum(~isnan(All_g.HasRewardField))*100, FaceColor = colors(4))
box off
ylabel("% of reward tuned HDC/PCs")
title("Reward tuned cells with reward fields")
ylim([0 100])

% are the tuning at the same reward location?
IsMisMatchTuning = GetHDSpatialRewardTuning(All_d);
nexttile;
bar(1,sum(IsMisMatchTuning, "all", 'o')/sum(All_d.HasRewardField > 0)*100, FaceColor=colors(1))
hold on
bar(2,sum(IsMisMatchTuning(:,1))/sum(All_d.HasRewardField > 0)*100, FaceColor=colors(1))
bar(3,sum(IsMisMatchTuning(:,2))/sum(All_d.HasRewardField > 0)*100, FaceColor=colors(1))
box off
title("Distinct reward representation")
ylim([0 100])
xticks(1:3)
xticklabels(["all", "rew 1", "rew 2"])
ylabel("% of cells")

%% plot light tuning
figure
tiledlayout("flow")
nexttile;
hold on
for i = 1:2
    bar(i,sum(sum(All_d.LightTuning{i},2 , 'omitnan')>0)/length(All_d.LightTuning{i})*100, FaceColor=colors(1));
end

for i = 1:2
    bar(i+2,sum(sum(All_g.LightTuning{i},2 , 'omitnan')>0)/length(All_g.LightTuning{i})*100, FaceColor=colors(4));
end

yline(36,"--")
yline(48.5, '--')
ylabel("% of light tuned cells")
ylim([0 100])

xticks(1:4)
xticklabels({"HDC/PC", "HDC only", "HDC/PC", "HDC only"})

%% get tuning composition
figure
tiledlayout(1,3)
nexttile;
piechart([25,37.5, 37.5], {"Reward", "Light", "Other"})
title("Baseline")
for i =1:2
    rew = length(find(All_d.CategoricalTuning{i}(:,1) ==1 | All_d.CategoricalTuning{i}(:,2) ==1));
    light = length(find(All_d.CategoricalTuning{i}(:,1) ==2 | All_d.CategoricalTuning{i}(:,2) ==2));
    other = length(find(All_d.CategoricalTuning{i}(:,1) ==3 | All_d.CategoricalTuning{i}(:,2) ==3));
    norm = rew+light+other;
    rew = rew/norm*100;
    light = light/norm*100;
    other = other/norm*100;
    nexttile;
    piechart([rew,light,other], {"Reward", "Light", "Other"})
    title(titles(i))
end


figure
tiledlayout(1,3)
nexttile;
piechart([12.5, 50, 37.5], {"Reward", "Light", "Other"})
title("Baseline")
for i =1:2
    rew = length(find(All_g.CategoricalTuning{i}(:,1) ==1 | All_g.CategoricalTuning{i}(:,2) ==1));
    light = length(find(All_g.CategoricalTuning{i}(:,1) ==2 | All_g.CategoricalTuning{i}(:,2) ==2));
    other = length(find(All_g.CategoricalTuning{i}(:,1) ==3 | All_g.CategoricalTuning{i}(:,2) ==3));
    norm = rew+light+other;
    rew = rew/norm*100;
    light = light/norm*100;
    other = other/norm*100;
    nexttile;
    piechart([rew,light,other], {"Reward", "Light", "Other"})
    title(titles(i))
end

%%
figure
tiledlayout(1,3)


nexttile;
piechart([12.5, 50, 37.5], {"Reward", "Light", "Other"})
title("Baseline (chance)")

nexttile;
piechart([16.3, 43.1, 40.6], {"Reward", "Light", "Other"})
title("HDCPC")

nexttile;
piechart([17.3, 46.9, 35.8], {"Reward", "Light", "Other"})
title("HDC only")





%% save examples
if SaveExamples == 1
    disp("Saving examples discrimination...")
    file_name = "E:\Codes\Miniscope codes\VectorRemapping_NEW\TuningCurve_D.pdf";
    SaveTuningExamples(All_d,file_name);
    disp("Saving examples grouping...")
    file_name = "E:\Codes\Miniscope codes\VectorRemapping_NEW\TuningCurve_G.pdf";
    SaveTuningExamples(All_g,file_name);
end

% %% plot
% close all
% composition_d = sum(All_d.CellComposition);
% composition_g = sum(All_g.CellComposition);
% 
% 
% [ydAll, xdAll] = ecdf(All_d.VectorRemap);
% [ygAll, xgAll] = ecdf(All_g.VectorRemap);
% 
% [ydAlla, xdAlla] = ecdf(abs(All_d.Angle(:,1)-All_d.Angle(:,2)));
% [ygAlla, xgAlla] = ecdf(abs(All_g.Angle(:,1)-All_g.Angle(:,2)));
% 
% figure
% tiledlayout(2,2)
% nexttile;
% bar(1:2:5,composition_d(1:3)./composition_d(4).*100, 'FaceColor',colors(1), 'BarWidth',0.3)
% hold on
% bar(2:2:6,composition_g(1:3)./composition_d(4).*100, 'FaceColor',colors(4), 'BarWidth',0.3)
% xticks([1.5 3.5 5.5])
% xticklabels(["HDC&PC", "HDC only", "PC only"])
% ylabel("% of cells")
% box off
% axis square
% 
% nexttile;
% plot(xdAll,ydAll, Color=colors(1), LineWidth=3)
% hold on
% plot(xgAll,ygAll, Color=colors(4), LineWidth=3)
% box off
% xlabel("Pearson's coefficient")
% ylabel("Portion")
% title("Vector correlation")
% legend("Disc.", "Group.", "Location","northwest")
% axis square
% 
% nexttile;
% plot(xdAlla,ydAlla, Color=colors(1), LineWidth=3)
% hold on
% plot(xgAlla,ygAlla, Color=colors(4), LineWidth=3)
% box off
% xlabel("Angle")
% ylabel("Portion")
% title("Angular difference")
% legend("Disc.", "Group.", "Location","northwest")
% axis square
% 
% 
% 
% [ydAll, xdAll] = ecdf(All_d.SpatialRemap);
% [ygAll, xgAll] = ecdf(All_g.SpatialRemap);
% 
% nexttile;
% plot(xdAll,ydAll, Color=colors(1), LineWidth=3)
% hold on
% plot(xgAll,ygAll, Color=colors(4), LineWidth=3)
% box off
% xlabel("Pearson's coefficient")
% ylabel("Portion")
% title("Spatial correlation of HDC/PC population")
% legend("Disc.", "Group.", "Location","northwest")
% axis square
% 
% %% plot tuned vs untuned vector length
% figure
% [y,x] = ecdf(All_d.TunedLength);
% plot(x,y, Color=colors(1), LineStyle="-", LineWidth=3)
% hold on
% [y,x] = ecdf(All_d.UnTunedLength);
% plot(x,y, Color=colors(1), LineStyle="--", LineWidth=3)
% 
% [y,x] = ecdf(All_g.TunedLength);
% plot(x,y, Color=colors(4), LineStyle="-", LineWidth=3)
% hold on
% [y,x] = ecdf(All_g.UnTunedLength);
% plot(x,y, Color=colors(4), LineStyle="--", LineWidth=3)
% xlabel("Tuning strength")
% ylabel("Portion")
% box off
% legend("Tuned", "Untuned", "AutoUpdate", "off", Location="southeast")
% 
% figure
% t= tiledlayout(2,2);
% 
% 
% nexttile;
% histogram(All_d.Tuning{1}, "Normalization","probability", "FaceColor", colors(1))
% box off
% axis square
% xticks(binCenter)
% xticklabels(wallsDir)
% title("Ctxt A")
% ylim([0 0.2])
% ylabel("Probability")
% 
% nexttile;
% histogram(All_d.Tuning{2}, "Normalization","probability", "FaceColor", colors(1))
% box off
% axis square
% xticks(binCenter)
% xticklabels(wallsDir)
% title("Ctxt B")
% ylim([0 0.2])
% ylabel("Probability")
% 
% nexttile;
% histogram(All_g.Tuning{1}, "Normalization","probability", "FaceColor", colors(4))
% box off
% axis square
% xticks(binCenter)
% xticklabels(wallsDir)
% title("Ctxt A")
% ylim([0 0.2])
% ylabel("Probability")
% 
% nexttile;
% histogram(All_g.Tuning{2}, "Normalization","probability", "FaceColor", colors(4))
% box off
% axis square
% xticks(binCenter)
% xticklabels(wallsDir)
% title("Ctxt B")
% ylim([0 0.2])
% ylabel("Probability")
% 
% title(t, "Significant tuning strength - direction")
% 
% %% pop vector correlation of HD tuning between ctxt A and B
% PVC_d = GetPVC_HD(All_d.Curves);
% PVC_g = GetPVC_HD(All_g.Curves);
% 
% figure
% tiledlayout(1,2)
% nexttile;
% bar(PVC_d, FaceColor=colors(1))
% axis square
% box off
% xticks(1:8)
% xticklabels(wallsDir)
% ylim([0 1])
% yline(mean(PVC_d))
% ylabel("PVC")
% 
% nexttile;
% bar(PVC_g, FaceColor=colors(4))
% axis square
% box off
% xticks(1:8)
% xticklabels(wallsDir)
% ylim([0 1])
% yline(mean(PVC_g))
% ylabel("PVC")
% 
% 
% %% plot reward tuning
% RewardTuned_sum_D = sum(All_d.RewardTuned_all,1);
% RewardTuned_sum_G = sum(All_g.RewardTuned_all,1);
% 
% figure
% tiledlayout(3,2)
% nexttile;
% bar([1 2], RewardTuned_sum_D(1:2), "FaceColor",colors(1),"EdgeColor","none")
% 
% hold on
% bar([4 5], RewardTuned_sum_D(3:4), "EdgeColor",colors(1), "FaceColor","none", "LineWidth",3)
% xticks([1 2 4 5])
% ylabel("# of cells")
% box off
% legend("Ctxt A", "Ctxt B", "Location","northwest")
% xticklabels({"rew 1", "rew 2", "rew 1", "rew 2"})
% axis square
% 
% nexttile;
% bar(1 , RewardTuned_sum_G(1), "FaceColor",colors(4),"EdgeColor","none")
% hold on;
% bar(3, RewardTuned_sum_G(3), "EdgeColor",colors(4), "FaceColor","none", "LineWidth",3)
% xticks([1 3])
% ylabel("# of cells")
% box off
% legend("Ctxt A", "Ctxt B", "Location","northeast")
% xticklabels({"rew 1","rew 1"})
% axis square
% ylim([0 40])
% 
% 
% RewardTuned_sum_D = sum(All_d.RewardTuned_ortho,1);
% RewardTuned_sum_G = sum(All_g.RewardTuned_ortho,1);
% 
% nexttile;
% bar([1 2], RewardTuned_sum_D(1:2), "FaceColor",colors(1),"EdgeColor","none")
% 
% hold on
% bar([4 5], RewardTuned_sum_D(3:4), "EdgeColor",colors(1), "FaceColor","none", "LineWidth",3)
% xticks([1 2 4 5])
% ylabel("# of cells")
% box off
% xticklabels({"rew 1", "rew 2", "rew 1", "rew 2"})
% axis square
% 
% nexttile;
% bar(1 , RewardTuned_sum_G(1), "FaceColor",colors(4),"EdgeColor","none")
% hold on;
% bar(3, RewardTuned_sum_G(3), "EdgeColor",colors(4), "FaceColor","none", "LineWidth",3)
% xticks([1 3])
% ylabel("# of cells")
% box off
% xticklabels({"rew 1","rew 1"})
% axis square
% ylim([0 20])
% 
% RewardTuned_sum_D = sum(All_d.RewardTuned_neutral,1);
% RewardTuned_sum_G = sum(All_g.RewardTuned_neutral,1);
% 
% nexttile;
% bar([1 2], RewardTuned_sum_D(1:2), "FaceColor",colors(1),"EdgeColor","none")
% 
% hold on
% bar([4 5], RewardTuned_sum_D(3:4), "EdgeColor",colors(1), "FaceColor","none", "LineWidth",3)
% xticks([1 2 4 5])
% ylabel("# of cells")
% box off
% xticklabels({"rew 1", "rew 2", "rew 1", "rew 2"})
% axis square
% 
% nexttile;
% bar(1 , RewardTuned_sum_G(1), "FaceColor",colors(4),"EdgeColor","none")
% hold on;
% bar(3, RewardTuned_sum_G(3), "EdgeColor",colors(4), "FaceColor","none", "LineWidth",3)
% xticks([1 3])
% ylabel("# of cells")
% box off
% xticklabels({"rew 1","rew 1"})
% axis square
% ylim([0 15])
