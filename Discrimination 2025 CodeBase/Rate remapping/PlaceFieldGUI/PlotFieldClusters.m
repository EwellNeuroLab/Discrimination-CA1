%% function to plot place map and clustered fields

function PlotFieldClusters(I, clusters, cluster_Method, gm)

    figure
    tiledlayout("flow")

    nexttile;
    h= imagesc(I);
    axis square

    set(h, "AlphaData", ~isnan(I))
    box off
    axis off

    if cluster_Method == "GMM"
        [r,c] = size(I);
        x= 1:c;
        y = 1:r;
        gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0 y0]),x,y);
        hold on
        fcontour(gmPDF, "LineColor","w")      
    end
    title("Place map")

    [~,~,n] = size(clusters);
    
    for i = 1:n
        nexttile;
        h = imagesc(I.*clusters(:,:,i));
            axis square

    set(h, "AlphaData", ~isnan(I))
    box off
    axis off
    title(strcat("Field ", num2str(i)))
    end
end