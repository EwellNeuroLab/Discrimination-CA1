%% main mismatch script

workdir_d = ["F:\Included miniscope Mice\M119\TrainingD11\"  "F:\Included miniscope Mice\M120\TrainingD11\"  "F:\Included miniscope Mice\M292\TrainingD6\"  "F:\Included miniscope Mice\M319\TrainingD7\" "D:\Grouping First\M231\TrainingD9\" "D:\Grouping First\M314\Training_Separation_D5\" "D:\Grouping First\M316\Training_Separation_D6\"  "D:\Grouping First\M318\Training_Separation_D4\" "F:\Included miniscope Mice\M210\TrainingD17\"];


[FiringPref, RZ_ID, MeanRate] = WrapMisMatch(workdir_d);

rate_ordered = GetMisMatchMatrix(MeanRate,RZ_ID, FiringPref); % get ordered event rate


figure
tiledlayout(1,3)
for i = 1:2
nexttile;
imagesc(rate_ordered{i})
hold on
[~, idx] = min(abs(rate_ordered{i}(:,i)-0.666));

yline(idx, "w-", LineWidth=2)
[~, idx] = min(abs(rate_ordered{i}(:,i)-0.333));
yline(idx, "w-", LineWidth=2)
box off
colormap sky
xticks([1 2])
xticklabels({"ctxt A", "ctxt B"})
ylabel('Field ID')
ylim([0 450])
title(strcat("Reward ", num2str(i)))
end
colorbar


