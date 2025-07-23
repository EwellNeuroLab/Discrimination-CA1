%% function to plot random examples of tuning curves
close all
binCenter = deg2rad(-157.5:45:157.5);
k = 10;

y = randsample(length(All_d.TunedCurves(:,1)),k);

figure
t= tiledlayout("flow");
for j = 1:k
    i = y(j);
    %i = j;
    ctxt = find(All_d.TunedCurves(i,:) == 1);
    curve = All_d.Curves(i,:,ctxt(1))/max(All_d.Curves(i,:,ctxt(1)));
    ax = polaraxes(t);
    polarplot(ax,[ binCenter binCenter(1)], [curve curve(1)] , 'k-')

    hold(ax,"on")

    polarplot(ax,[0 deg2rad(All_d.Angle(i,ctxt(1)))], [0 All_d.Length(i,ctxt(1))], 'r-')
    ax.ThetaZeroLocation = 'top';
    ax.ThetaDir = 'clockwise';
    ax.Layout.Tile = j;
    ax.RGrid = "off";
    ax.ThetaGrid = "off";
    ax.RTick = [];
    thetaticks(0:45:360)
    title(strcat("r=",num2str(round(All_d.Length(i,ctxt(1)),2))))
end

figure
t= tiledlayout("flow");

for j = 1:k
    i = y(j);
    %i = j;
    ctxt = find(All_d.TunedCurves(i,:) == 1);
    curve = All_d.Curves(i,:,ctxt(1))/max(All_d.Curves(i,:,ctxt(1)));
    polarHist = [];
    for b = 1:8
        polarHist = [polarHist; repmat(binCenter(b), round(curve(b)*100), 1)];
    end
    ax = polaraxes(t);
    polarhistogram(rad2deg(polarHist), "BinEdges",deg2rad(0:45:360))% "Normalization", "probability", "BinWidth",45)

    hold(ax,"on")

    ax.ThetaZeroLocation = 'top';
    ax.ThetaDir = 'clockwise';
    ax.Layout.Tile = j;
    thetaticks(0:45:360)
end







