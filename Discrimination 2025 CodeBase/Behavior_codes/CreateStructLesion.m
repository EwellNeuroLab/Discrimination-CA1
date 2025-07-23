%% Gergely Tarcsay, 2024 Ewell lab. Script to generate struct for individual mice to assess behavior for the lesion experiments.
%% Struct contains the followings: mouse ID, group, Sex, first day of retesting w/ lesion, eventFile and position data
rootdir = "H:\HPC lesion\";
lesion_struct = struct;
ID = ["M94", "M113", "M118", "M122", "M151", "M152", "M154", "M155", "M179", "M180", "M181", "M182"]; % make sure that it matches folder names
Sex = ["m", "f", "f", "m", "m", "f", "f", "m", "f", "m", "f", "m"];
Group = ["c", "c", "l", "l", "c", "l", "c", "l", "c", "l", "l", "c"];
LesionD1 = [13 16 8 9 11 9 9 12 4 8 8 9]; 

lesion_struct.details = table(ID',  Group', Sex' , LesionD1', 'VariableNames', ["Mouse", "Group", "Sex", "LesionD1"]);


% now loop on each mice and read all days (TraingingDX) after pretraining

for m = 1:length(ID)
    main_folder = strcat(rootdir, ID(m), "\");
    IsData = 1;
    day = 1;
    while IsData == 1
        day_folder = strcat(main_folder, "TrainingD", num2str(day), "\");
        if exist(day_folder, "dir")
            day = day+1;
            disp(strcat("Reading ", day_folder))
            if length(dir(day_folder)) == 2 % if folder is empty skip that day 
                continue;
            end
            [lesion_struct.xy{day-1,m}, lesion_struct.events{day-1,m}] = ReadData(day_folder);
            
        else
            IsData = 0;
        end
    end

end




save(strcat(rootdir,"LesionData.mat"), 'lesion_struct')
















