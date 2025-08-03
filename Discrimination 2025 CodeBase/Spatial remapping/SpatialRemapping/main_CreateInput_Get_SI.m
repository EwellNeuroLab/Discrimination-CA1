%% main script to create field analysis gui input and calculate spatial information
rootdir = "G:\CA1 miniscope data"; % change this according to your path
addpath(strcat(rootdir, "Discrimination 2025 CodeBase\Spatial remapping GT\SpatialRemapping"))

workdir_d = [strcat(rootdir,"\M119\TrainingD11\")  strcat(rootdir,"\M120\TrainingD11\")  strcat(rootdir,"\M292\TrainingD6\")  strcat(rootdir,"\M319\TrainingD7\") strcat(rootdir,"\M231\TrainingD9\") strcat(rootdir,"\M314\Training_Separation_D5\") strcat(rootdir,"\M316\Training_Separation_D6\")  strcat(rootdir,"\M318\Training_Separation_D4\") strcat(rootdir,"\M210\TrainingD17\")];
workdir_g = [strcat(rootdir,"\M119\GroupingD6\") strcat(rootdir,"\M120\GroupingD6\") strcat(rootdir,"\M292\GroupingD3\") strcat(rootdir,"\M319\GroupingD4\") strcat(rootdir,"\M231\GroupingD5\") strcat(rootdir,"\M314\GroupingD3\") strcat(rootdir,"\M316\GroupingD3\") strcat(rootdir,"\M318\GroupingD3\") ];
discrimination = [1 1 1 1 2 2 2 2 1];
grouping = [2 2 2 2 1 1 1 1 0];
Sex = ["f" "f" "f" "m" "f" "m" "m" "m"];
colors = ["#CAEA3B" "#93EB74" "#BCEAC5" "#6C1FEB" "#875FEA" "#D093EB" ];

SpatialInfo_D = Wrap_SI(workdir_d,discrimination);
SpatialInfo_G = Wrap_SI(workdir_g,discrimination);


%% plot spatial info distribution
close all
figure
tiledlayout(1,3)

nexttile;
hold on

[yd,xd]  =ecdf(SpatialInfo_D.All);
plot(xd,yd, LineWidth=3, Color=colors(1))

[yg,xg]  =ecdf(SpatialInfo_G.All);
plot(xg,yg, LineWidth=3, Color=colors(4))

box off
xlabel("SI score")
ylabel("Portion")
legend("Discrimination", "Grouping", "Location","southeast")


for i  =1:2
nexttile;
hold on
[yd,xd]  =ecdf(SpatialInfo_D.Cohort{i});
plot(xd,yd, LineWidth=3, Color=colors(1+i))

[yg,xg]  =ecdf(SpatialInfo_G.Cohort{i});
plot(xg,yg, LineWidth=3, Color=colors(4+i))

box off
xlabel("SI score")
ylabel("Portion")
legend("Discrimination", "Grouping", "Location","southeast")
end





