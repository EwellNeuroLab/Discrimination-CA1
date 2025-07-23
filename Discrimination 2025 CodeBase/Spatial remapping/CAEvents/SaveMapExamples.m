figure
tiledlayout(3,2)

nexttile;
imagesc(RateMap{1}(:,:,3))
axis square
box off 

nexttile;
imagesc(RateMap{2}(:,:,3))
axis square
box off 




function SaveMaps(workdir)

file_name = strcat(workdir, "\PlaceMaps.pdf");
load(strcat(workdir, "\PCAnalysis.mat"))
cells = PC_tbl.IsPC(PC_tbl.IsDrifting ~= 1) ;
idx = find(cells == 1);

for n = 1:length(idx)
    max_val = max([ max(RateMap{1}(:,:,idx(n)), [], "all") max(RateMap{2}(:,:,idx(n)), [],"all")]);
    figure("Visible","off")
    t = tiledlayout(1,2);
    for i = 1:2
        nexttile;
        f= imagesc(RateMap{i}(:,:,idx(n)));
        set(f,"AlphaData", ~isnan(RateMap{i}(:,:,idx(1))))
        box off
        axis square
        axis off
        colormap jet
        colorbar
        clim([0 max_val])
        title(t,strcat("Cell ", num2str(idx(n))))
    end

    exportgraphics(gcf, file_name, "Append", true )

    close(gcf)

end
end