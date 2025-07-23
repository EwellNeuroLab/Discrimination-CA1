%% main script to measure how many cells were excluded or labelled as threshold needed

rootdir(1) = "F:\Included miniscope Mice\";
folders(:,1) = ["\M119\TrainingD11\" "\M120\GroupingD6\" "M319\TrainingD7\" "M292\GroupingD3\"  "M210\TrainingD17\"];

rootdir(2) = "D:\Grouping First\";
folders(:,2) = ["\M231\GroupingD5\" "\M314\GroupingD3\" "M316\GroupingD3\"  "M318\GroupingD3\", ""];

IncludedPercent = zeros(9,1);
ThresholdedPercent = zeros(9,1);
counter = 1;
Till = [5 4];
for r  =1:2
    for f = 1:Till(r)
        disp(strcat(rootdir(r), folders(f,r)))
        load(strcat(rootdir(r), folders(f,r), "\processedData\DriftDetection.mat"))

        All = length(IsDrifting);
        IncludedPercent(counter) = length(find(IsDrifting == 0))/All*100;
        ThresholdedPercent(counter) = length(find(IsDrifting == 2))/All*100;
        counter= counter +1;
        clear IsDrifting
    end

end

%% plot
close all
figure
tiledlayout(1,2)

nexttile;
bar(IncludedPercent, "k")
ylabel("% of cells")
xticklabels({"M119", "M120", "M319", "M292", "M210", "M231", "M314", "M316", "M318"})
title("% of cells labelled as non-drifting")
ylim([0 100])
box off

nexttile;
bar(ThresholdedPercent, "k")
ylabel("% of cells")
xticklabels({"M119", "M120", "M319", "M292", "M210", "M231", "M314", "M316", "M318"})
title("% of cells labelled as non-drifting")
ylim([0 10])
box off





