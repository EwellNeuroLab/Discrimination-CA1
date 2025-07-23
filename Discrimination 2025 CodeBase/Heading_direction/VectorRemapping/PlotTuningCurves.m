%% function to plot random examples of tuning curves
close all

binCenter = deg2rad(-157.5:45:157.5);
all_curves = All_d.Curves;
all_angles = All_d.Angle;
all_L = All_d.Length;
k = 5;

ctxtA  = find(All_d.TunedCurves(:,1) == 1 & All_d.TunedCurves(:,2) == 0);
ctxtB  = find(All_d.TunedCurves(:,1) == 0 & All_d.TunedCurves(:,2) == 1);
both  = find(All_d.TunedCurves(:,1) == 1 & All_d.TunedCurves(:,2) == 1);
yA = randsample(ctxtA,k);
yB = randsample(ctxtB,k);
yboth = randsample(both,k);



figure
t= tiledlayout(5,2);
PlotExamples(yA,k, all_curves, all_angles, all_L, binCenter,t)

figure
t= tiledlayout(5,2);
PlotExamples(yB,k, all_curves, all_angles, all_L, binCenter,t)

figure
t= tiledlayout(5,2);
PlotExamples(yboth,k, all_curves, all_angles, all_L, binCenter,t)




function PlotPolar(ax, binCenter, curve, angle, L,theta, maxTheta)


edges = deg2rad(-180:45:180);
hold(ax,"on")
polarhistogram(theta, 'BinEdges', edges, "FaceColor","k", "FaceAlpha", 0.25)
%polarplot(ax,[ binCenter binCenter(1)], [curve curve(1)].*100 , 'm-')
normed_L = max(curve*100)*L;
polarplot(ax,[0 deg2rad(angle)], [0 normed_L], '-', 'Color', '#991b46', 'LineWidth',1)
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.RGrid = "off";
ax.ThetaGrid = "off";
ax.RTick = [];
thetaticks(0:45:360)
rlim([0 maxTheta])

end


function PlotExamples(y,k, all_curves, all_angles, all_L, binCenter,t)

counter = 1;
for j = 1:k
    i = y(j);
    %ctxt = find(All_d.TunedCurves(i,:) == 1);
    %curve = All_d.Curves(i,:,ctxt(1))/max(All_d.Curves(i,:,ctxt(1)));
    theta = cell(2,1);
    maxRep = zeros(2,1);
    for m = 1:2
        curve = all_curves(i,:,m);%/max(all_curves(i,:,m), [], "all");
        theta{m} = repelem(binCenter, round(curve*100));
        maxRep(m) = max(histcounts(theta{m}, length(binCenter)));
    end

    for m = 1:2
        % create polar histogram from the curve
        curve = all_curves(i,:,m);
        ax = polaraxes(t);
        angle = all_angles(i,m);
        L = all_L(i,m);
        maxTheta = max(maxRep);
        PlotPolar(ax, binCenter, curve, angle, L, theta{m}, maxTheta)
        ax.Layout.Tile = counter;
        title(strcat("ID: ", num2str(i), " r=",num2str(round(all_L(i,m),2))))
        counter = counter+1;
    end
end
end



