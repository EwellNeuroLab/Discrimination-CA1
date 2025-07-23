%% Gergely Tarcsay, 2024. Script to generate struct for individual mice to assess behavior for learning curves
%% Struct contains the followings: mouse ID, Sex, day of discrimination passed, day of grouping passed, eventFile and position data
%% For the learning curves we use control mice from the lesion
rootdir = "G:\Behavior\";
behavior_struct = struct;
ID = ["M95", "M96", "M97", "M98", "M99", "M100", "M114", "M115", "M116", "M117"]; % make sure that it matches folder names
Sex = ["f", "m", "f", "m", "f", "m", "f", "f", "f", "m"];
DiscriminationPassed = [12 9 4 5 3 8 7 15 9 4 ];
Discrimination70 =[11 8 3 3 2 7 6 14 7 3];
GroupingPassed  = [2 NaN NaN NaN 3 NaN 3 5 4 3 ];
Grouping70  = [1 NaN NaN NaN 2 NaN 2 4 3 2 ];
G1 = [17 NaN NaN NaN 10 NaN 12 20 15 9 ];
Implanted = [ones(1,10)];

behavior_struct.details = table(ID',  Sex' , DiscriminationPassed', GroupingPassed', Implanted', 'VariableNames', ["Mouse", "Sex", "DPassed", "GPassed", "Implanted"]);


% now loop on each mice and read all days (TraingingDX) after pretraining
for m = 1:10
    main_folder = strcat(rootdir, ID(m), "\");
    day = 1;
    for d=1:DiscriminationPassed(m)
        day_folder = strcat(main_folder, "TrainingD", num2str(day), "\");
        if exist(day_folder, "dir")
            day = day+1;
            disp(strcat("Reading ", day_folder))
            if length(dir(day_folder)) == 2 % if folder is empty skip that day
                continue;
            end
            [behavior_struct.D_xy{day-1,m}, behavior_struct.D_events{day-1,m}] = ReadData(day_folder);

        end
    end

    %add grouping
    if ~isnan(G1(m))
        d=1;
        for day = G1(m):G1(m)+GroupingPassed(m)-1
            day_folder = strcat(main_folder, "TrainingD", num2str(day), "\");
            if exist(day_folder, "dir")
                disp(strcat("Reading ", day_folder))
                if length(dir(day_folder)) == 2 % if folder is empty skip that day
                    continue;
                end
                [behavior_struct.G_xy{d,m}, behavior_struct.G_events{d,m}] = ReadData(day_folder);
                d = d+1;
            else
                disp(strcat("Missing folder: ", day_folder))
            end
        end
    end
end


 
save(strcat(rootdir,"BehaviorData.mat"), 'behavior_struct')
