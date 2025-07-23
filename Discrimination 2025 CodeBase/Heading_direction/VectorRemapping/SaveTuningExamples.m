%function to plot and save figure in pdf of tuning curves (polar plot and histogram)

function SaveTuningExamples(All,file_name)
binCenter = deg2rad(-157.5:45:157.5)+pi/2;
N_cells = length(All.Length(:,1));

if exist(file_name,"file")
    delete(file_name);
end

for i = 1:N_cells

figure("Visible", "off")
t = tiledlayout(2,2);

for ctxt = 1:2
    nexttile;
    curve = All.Curves(i,:,ctxt);
    polarplot([ binCenter binCenter(1)], [curve curve(1)] , 'ko-')
    hold on
    polarplot([0 deg2rad(All.Angle(i,ctxt))+pi], [0 All.Length(i,ctxt)*10], 'r-')
    polarplot(deg2rad(All.Angle(i,ctxt))+pi, All.Length(i,ctxt)*10, 'ro', "MarkerFaceColor","r")
    title(strcat("HDC: ", num2str(All.Context(i,ctxt))))
    nexttile;
    bar(rad2deg(binCenter), curve, "FaceColor","k")
    box off
    ylabel("Rate (event/min)")

end
    
title(t, strcat("Cell ", num2str(i)))
exportgraphics(gcf, file_name, "Append", true )
close(gcf)
end
end





