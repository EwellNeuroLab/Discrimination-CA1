%% script to visualize HPC volume in the lesion experiment. Gergely Tarcsay, 2024 Ewell lab
close all
tbl = readtable("G:\HPC lesion\Lesion scoring\AreaSummary.xlsx");

%% calculate volume from distance and summed area
for i = 1:length(tbl.distance_um_)
    tbl.CA1Volume(i) = (tbl.CA1Area_um2_(i)*tbl.distance_um_(i))/1e9; % in mm3
    tbl.CA3Volume(i) = (tbl.CA3Area(i)*tbl.distance_um_(i))/1e9; % in mm3
    tbl.DGVolume(i) = (tbl.DGArea(i)*tbl.distance_um_(i))/1e9;
end

%% compare ctrl vs lesion volume
ctrl = find(tbl.type == 0);
lesion = find(tbl.type == 1);
left = find(tbl.hemisphere == 1);
right = find(tbl.hemisphere == 2);

meanCA1 = [mean(tbl.CA1Volume(ctrl)) mean(tbl.CA1Volume(lesion))];
meanCA3 = [mean(tbl.CA3Volume(ctrl)) mean(tbl.CA3Volume(lesion))];
meanDG = [mean(tbl.DGVolume(ctrl)) mean(tbl.DGVolume(lesion))];

semCA1 = [std(tbl.CA1Volume(ctrl))/sqrt(10) std(tbl.CA1Volume(lesion))/sqrt(12)];
semCA3 = [std(tbl.CA3Volume(ctrl))/sqrt(10) std(tbl.CA3Volume(lesion))/sqrt(12)];
semDG = [std(tbl.DGVolume(ctrl))/sqrt(10) std(tbl.DGVolume(lesion))/sqrt(12)];

%% calculate the % volume compared to the mean of the control volume
tbl.CA1Relative =tbl.CA1Volume./meanCA1(1)*100;
tbl.CA3Relative =tbl.CA3Volume./meanCA3(1)*100;
tbl.DGRelative =tbl.DGVolume./meanDG(1)*100;

%% now take the average of left and right
lesion_left = intersect(lesion,left);
lesion_right = intersect(lesion,right);

%% calculate the mean relative volume (left & right)
relative_CA1 = (tbl.CA1Relative(lesion_left)+tbl.CA1Relative(lesion_right))/2;
relative_CA3 = (tbl.CA3Relative(lesion_left)+tbl.CA3Relative(lesion_right))/2;
relative_DG = (tbl.DGRelative(lesion_left)+tbl.DGRelative(lesion_right))/2;


%% plot relative volume
figure
hold on
bar(0, mean(relative_DG), 'FaceColor','w', 'EdgeColor', 'k')
bar(1, mean(relative_CA3), 'FaceColor','w', 'EdgeColor', 'k')
bar(2, mean(relative_CA1), 'FaceColor','w', 'EdgeColor', 'k')
xticks([0 1 2])
xticklabels({'DG', 'CA3', 'CA1'})
ylabel("Relative volume (%)")

er = errorbar([0 1 2], [mean(relative_DG) mean(relative_CA3) mean(relative_CA1)], [std(relative_DG) std(relative_CA3) std(relative_CA1)]);
er.Color=  [0 0 0];
er.LineStyle  = 'none';
er.LineWidth = 1;
er.CapSize  =15;

plot(zeros(6,1), relative_DG, 'ko')
plot(ones(6,1), relative_CA3, 'ko')
plot(repmat(2,6,1), relative_CA1, 'ko')
plot([0 1 2 ], [relative_DG relative_CA3 relative_CA1], '--', 'Color', [.5 .5 .5])

%% do statisics - one-way anova with post-hoc tukey's tets
anova_data = [relative_DG; relative_CA3; relative_CA1];
anova_label = [repmat(1, 6,1); repmat(2, 6,1); repmat(3, 6,1)];

[p,tbl,stats] = anova1(anova_data,anova_label);

c= multcompare(stats);