%% script - main vector remap 2


workdir_d = ["F:\Included miniscope Mice\M119\TrainingD11\"  "F:\Included miniscope Mice\M120\TrainingD11\"  "F:\Included miniscope Mice\M292\TrainingD6\"  "F:\Included miniscope Mice\M319\TrainingD7\" "D:\Grouping First\M231\TrainingD9\" "D:\Grouping First\M314\Training_Separation_D5\" "D:\Grouping First\M316\Training_Separation_D6\"  "D:\Grouping First\M318\Training_Separation_D4\" "F:\Included miniscope Mice\M210\TrainingD17\"];
workdir_g = ["F:\Included miniscope Mice\M119\GroupingD6\" "F:\Included miniscope Mice\M120\GroupingD6\" "F:\Included miniscope Mice\M292\GroupingD3\" "F:\Included miniscope Mice\M319\GroupingD4\" "D:\Grouping First\M231\GroupingD5\" "D:\Grouping First\M314\GroupingD3\" "D:\Grouping First\M316\GroupingD3\" "D:\Grouping First\M318\GroupingD3\" ];
discrimination = [1 1 1 1 2 2 2 2 1];
grouping = [2 2 2 2 1 1 1 1 0];
OverlappingWall = [2 2 1 1 2 1 2 1 1];
Sex = ["f" "f" "f" "m" "f" "m" "m" "m"];
colors = ["#CAEA3B" "#93EB74" "#BCEAC5" "#6C1FEB" "#875FEA" "#D093EB" ];
SaveExamples = 0;
binCenter = -157.5:45:157.5;
wallsDir = ["SW", "W", "NW", "N", "NE", "E", "SE", "S"];

LightBins_d = [5 6; 3 4];
[All_d, Individual_d]= WrapVectorRemap2(workdir_d, discrimination, LightBins_d);
LightBins_g = [1 2; 7 8];
[All_g, Individual_g]= WrapVectorRemap2(workdir_g, discrimination, LightBins_g);


titles = ["HDC/PC" "HDC"];
%% plot
%figure 1. Composition of cells
CellCompD = sum(All_d.CellComposition,1);
CellCompG = sum(All_g.CellComposition,1);
close all

figure 
bar([1 4 7], CellCompD(1:3)./CellCompD(4).*100, FaceColor=colors(1), BarWidth=0.3)
hold on
bar([2 5 8], CellCompG(1:3)./CellCompG(4).*100, FaceColor=colors(4), BarWidth=0.3)
box off
xticks([1.5 4.5 7.5])
xticklabels({"HDC/PC", "HDC only", "PC"})
ylabel("% of cells")

% figure 2. orthogonality
figure
tiledlayout("flow")
nexttile;
bar(1,sum(All_d.IsOrthogonal{1})/length(All_d.IsOrthogonal{1})*100, FaceColor=colors(1),BarWidth=0.5)
hold on
bar(2,sum(All_d.IsOrthogonal{2})/length(All_d.IsOrthogonal{2})*100, FaceColor=colors(1),BarWidth=0.5)
bar(4,sum(All_g.IsOrthogonal{1})/length(All_g.IsOrthogonal{1})*100, FaceColor=colors(4),BarWidth=0.5)
bar(5,sum(All_g.IsOrthogonal{2})/length(All_g.IsOrthogonal{2})*100, FaceColor=colors(4),BarWidth=0.5)
xticks([1 2 4 5])
xticklabels({"HDC/PC", "HDC only", "HDC/PC", "HDC only"})
ylabel("% of orthogonal cells")
box off

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


% figure 3. tunining composition 
figure
tiledlayout(2,3)
baseline_d = [1; 3; 3]./7.*100;
nexttile;
donutchart(baseline_d, {"Reward", "Light", "Other"})
observed_comp = cell(2,1);
title("Baseline")
for i =1:2
    rew_d(i) = length(find(All_d.CategoricalTuning{i}(:,1) ==1 | All_d.CategoricalTuning{i}(:,2) ==1));
    light_d(i) = length(find(All_d.CategoricalTuning{i}(:,1) ==2 | All_d.CategoricalTuning{i}(:,2) ==2));
    other_d(i) = length(find(All_d.CategoricalTuning{i}(:,1) ==3 | All_d.CategoricalTuning{i}(:,2) ==3));
    norm_d(i) = rew_d(i)+light_d(i)+other_d(i);
    rew_d(i) = rew_d(i);
    light_d(i) = light_d(i);
    other_d(i) = other_d(i);
    nexttile;
    observed_comp{i} = [rew_d(i); light_d(i); other_d(i)]./norm_d(i).*100;
    donutchart(observed_comp{i}, {"Reward", "Light", "Other"})
    title(titles(i))
    x = [baseline_d observed_comp{i}];
    [h,p_chiD(i)] = chi2cont(x);
    
end

observed_comp = cell(2,1);
nexttile;
baseline_g = [1, 4, 3]./8.*100;
donutchart(baseline_g, {"Reward", "Light", "Other"})
title("Baseline")
for i =1:2
    rew_g(i) = length(find(All_g.CategoricalTuning{i}(:,1) ==1 | All_g.CategoricalTuning{i}(:,2) ==1));
    light_g(i)  = length(find(All_g.CategoricalTuning{i}(:,1) ==2 | All_g.CategoricalTuning{i}(:,2) ==2));
    other_g(i)  = length(find(All_g.CategoricalTuning{i}(:,1) ==3 | All_g.CategoricalTuning{i}(:,2) ==3));
    norm_g(i) = rew_g(i) +light_g(i) +other_g(i) ;

    nexttile;
    observed_comp{i} = [rew_g(i); light_g(i); other_g(i)]./norm_g(i).*100;
    donutchart(observed_comp{i}, {"Reward", "Light", "Other"})
    title(titles(i))
    x = [baseline_d observed_comp{i}];
    [h,p_chiG(i)] = chi2cont(x);
end


% figure 4. reward tuned HDC/PCs
figure
% tuned to reward
bar(1,rew_d(1)/norm_d(1)*100, FaceColor=colors(1), BarWidth=0.3)
hold on
bar(1.5,rew_g(1)/norm_g(1)*100, FaceColor=colors(4), BarWidth=0.3)
ylabel("% of tuned HDCs")

% tuned to reward with reward field
bar(2,sum(All_d.HasRewardField > 0)/norm_d(1)*100, FaceColor=colors(1), BarWidth=0.3)
bar(2.5,sum(All_g.HasRewardField > 0)/norm_g(1)*100, FaceColor=colors(4), BarWidth=0.3)
% tuned to reward with reward field at the opposite reward location
IsMisMatchTuning = GetHDSpatialRewardTuning(All_d);
bar(4,sum(IsMisMatchTuning, "all", 'omitnan')/norm_d(1)*100, FaceColor=colors(1), BarWidth=0.3)
xticks([1.25 2.25 4])
xticklabels({"rew tuned", "has rew field", "distinct tuning"})
box off

%% figure - plot whether overlapping wall is overrepresented
All_HDCPC_rew_overlapping = 0;
for i = 1:9
   All_HDCPC_rew_overlapping = All_HDCPC_rew_overlapping + Individual_d.NRewardTuned(i, OverlappingWall(i),1);
end
N_rew_HDCPC = sum(Individual_d.NRewardTuned(:,:,1), "all");

All_HDC_rew_overlapping = 0;
for i = 1:9
   All_HDC_rew_overlapping = All_HDC_rew_overlapping + Individual_d.NRewardTuned(i, OverlappingWall(i),2);
end
N_rew_HDC = sum(Individual_d.NRewardTuned(:,:,2), "all");

figure
bar(1, All_HDCPC_rew_overlapping/N_rew_HDCPC*100, FaceColor=colors(1))
hold on
bar(2, All_HDC_rew_overlapping/N_rew_HDC*100, FaceColor=colors(1))
xticks([1 2])
xticklabels({"HDC/PC", "HDC only"})
ylabel("% of reward tuned cells")
title("Reward tuned HDCs at overlapping wall")
ylim([0 100])
yline(50, '--')


%% panel B
onlyPC_d = sum(All_d.CellComposition(:,3));
onlyHDC_d = sum(All_d.CellComposition(:,2));
both_d = sum(All_d.CellComposition(:,1));
none_d = sum(All_d.CellComposition(:,4))-onlyPC_d-onlyHDC_d-both_d;

onlyPC_g = sum(All_g.CellComposition(:,3));
onlyHDC_g = sum(All_g.CellComposition(:,2));
both_g = sum(All_g.CellComposition(:,1));
none_g = sum(All_g.CellComposition(:,4))-onlyPC_g-onlyHDC_g-both_g;

figure
tiledlayout(1,2)
nexttile;
donutchart([onlyHDC_d,onlyPC_d,  both_d, none_d])

nexttile;
donutchart([onlyHDC_g, onlyPC_g,  both_g, none_g])


%% panel C - orthogonality
% first HDC/PC
figure
tiledlayout(2,2)

for i = 1:2
comp_d = GetComp(All_d.TuningBin{i});
comp_g = GetComp(All_g.TuningBin{i});

nexttile;
%bar(1:3, comp_d./sum(comp_d).*100, FaceColor=colors(1))
piechart(comp_d)
nexttile;%bar(5:7, comp_g./sum(comp_g).*100, FaceColor=colors(4))
piechart(comp_g)
end


figure
tiledlayout(1,2)
nexttile;
for i = 1:2
    
    bothTuned = find(~isnan(All_d.TuningBin{i}(:,2))  & ~isnan(All_d.TuningBin{i}(:,1)));
    [y,x] = ecdf(All_d.AngleDiff{i}(bothTuned));
    plot(x,y)
    hold on
    box off
    xlim([0 180])
end
axis square
nexttile;
for i = 1:2
    
    bothTuned = find(~isnan(All_g.TuningBin{i}(:,2))  & ~isnan(All_g.TuningBin{i}(:,1)));
    [y,x] = ecdf(All_g.AngleDiff{i}(bothTuned));
    plot(x,y)
    hold on
    box off
    xlim([0 180])
end

axis square



function comp = GetComp(tunedBins)
      comp(1)= sum(~isnan(tunedBins(:,1))  & isnan(tunedBins(:,2))); % ctxt 1
      comp(2) = sum(~isnan(tunedBins(:,2))  & isnan(tunedBins(:,1)));% ctxt 2
       comp(3) = sum(~isnan(tunedBins(:,2))  & ~isnan(tunedBins(:,1)));  % both

end