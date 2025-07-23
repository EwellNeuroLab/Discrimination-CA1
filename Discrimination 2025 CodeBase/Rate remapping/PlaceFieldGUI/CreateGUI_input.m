%% Function to generate input maps for the Field Analysis GUI
clear all
rootdir ="D:\Grouping First\M318\Training_Separation_D2\";
onset_file = "processed\OnsetDataDLC.mat";
pc_file = "processed\StableCells_DLC.mat";
output = "processed\PlaceMaps_DLC.mat";
framerate = 30;
% load onset file
load(strcat(rootdir,onset_file));

N_cell = length(onset_XY.all);


% create spiking map
[on_map_full, ~] = GenerateMap(onset_XY.run_all, Nx,Ny, occupancy.all_run, framerate);
[on_map_sessI, ~] = GenerateMap(onset_XY.run_cI, Nx,Ny, occupancy.cI_run, framerate);
[on_map_sessII, ~] = GenerateMap(onset_XY.run_cII, Nx,Ny, occupancy.cII_run, framerate);

% create activity rate map (event/min)
filterSize = 1.5; % gaussian filter on the map
ActivityMap_full = GetActivityRate(on_map_full, occupancy.all_run, filterSize,framerate);
ActivityMap_sess = cell(N_cell,2);
ActivityMap_sess(:,1) = GetActivityRate(on_map_sessI, occupancy.cI_run, filterSize,framerate);
ActivityMap_sess(:,2) = GetActivityRate(on_map_sessII, occupancy.cII_run, filterSize,framerate);

%get cellIDs that will be used
load(strcat(rootdir,pc_file))
cell_ID = stable.all;

% get cells that will not be used
not_used = 1:N_cell;
not_used(cell_ID) = [];

% remove maps from cells that are not used
ActivityMap_full(not_used)=  [];
ActivityMap_sess(not_used,:)=  [];

% save maps 
save(strcat(rootdir,output), "ActivityMap_sess", "ActivityMap_full", "cell_ID")

