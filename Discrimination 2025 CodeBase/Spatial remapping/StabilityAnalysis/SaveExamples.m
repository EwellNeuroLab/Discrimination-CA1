%% save map examples - stability and place cell examples
rootdir = strings(2,1);
folders = strings(9,2);
rootdir(1) = "F:\Included miniscope Mice\";
folders(:,1) = ["\M119\TrainingD11\" "\M119\GroupingD6\" "\M120\TrainingD11\" "\M120\GroupingD6\" "\M292\TrainingD6\" "\M292\GroupingD3\" "M319\TrainingD7\"  "M319\GroupingD4\" "M210\TrainingD17\"];

rootdir(2) = "D:\Grouping First\";
folders(:,2) = ["\M231\GroupingD5\" "\M231\TrainingD9\" "\M314\Training_Separation_D5\" "\M314\GroupingD3\" "\M316\Training_Separation_D6\" "\M316\GroupingD3\" "M318\Training_Separation_D4\"  "M318\GroupingD3\" ""];
nFiles = [9 8];
for r= 1:2
    for f = 1:nFiles(r)
        clearvars -except rootdir folders nFiles r f
        workdir = strcat(rootdir(r), folders(f,r), "\processedData\PCAnalysis.mat");
        disp(strcat(rootdir(r), folders(f,r)))
        load(workdir)
        file_name = strcat(rootdir(r), folders(f,r), "\processedData\MapExamples.pdf");
        if exist(file_name,"file")
            delete(file_name)
        end
        non_drifting = find(PC_tbl.IsDrifting ~= 1); % non-drifting or threshold needeed cells have map
        pc = find(PC_tbl.IsPC(:,1) == 1);
        map_id = find(PC_tbl.IsPC(non_drifting,1) == 1 ); % id of place cells
        pc_in = PC_tbl.IsSignificant(PC_tbl.IsPC(:,1) == 1,2:3);
        for n = 1:length(map_id)
            figure('Visible','off')
            t = tiledlayout(2,5);

            max_val = max([max(RateMap{1}(:,:,map_id(n)),[],"all"), max(RateMap{2}(:,:,map_id(n)),[],"all")]);
            for c = 1:2

                nexttile;
                PlotMap(RateMap{c}(:,:,map_id(n)), max_val)
                %colorbar;

                for i=1:4
                    nexttile;
                    PlotMap(RateMap_splitted{i,c}(:,:,map_id(n)), max_val)

                    title(t, strcat("ID ", num2str(map_id(n))), strcat(num2str(pc_in(n,1)), " ", num2str(pc_in(n,2))))

                end
            end
            exportgraphics(gcf, file_name, "Append", true );
            close(gcf)
        end

    end
end

function PlotMap(mat, max_val)
f= imagesc(mat);
set(f,"AlphaData", ~isnan(mat))

box off
axis square
axis off
colormap jet
clim([0 max_val])

end