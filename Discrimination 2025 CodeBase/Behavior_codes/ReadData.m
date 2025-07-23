%% Gergely Tarcsay, 2022. Function to read Bonsai behavior data. Files are merged when multiple outputs are found (due to restarting the recordings for example).
function [pos, event] = ReadData(rootdir)


poslist = dir(strcat(rootdir,'\Pos*.csv'));
%if there is more than 1 position csv - merge them

pos = [];
shift_frame = zeros(length(poslist)-1,1);
shift = zeros(length(poslist),1);
for p = 1:length(poslist)
    shift(p) = sum(shift_frame);
    temp_pos = readmatrix(strcat(poslist(p).folder, '\', poslist(p).name));
    shift_frame(p) = temp_pos(end,1)+1;
    temp_pos(:,1) = temp_pos(:,1)+shift(p);
    pos = [pos; temp_pos];
end

if length(poslist) > 1
    disp(strcat(num2str(length(poslist))," position files were merged"))    
end
%read event file
event = readtable(strcat(rootdir, '\EventFile.csv'));

% fix frames
gaps = [find(diff(event{:,2})<0)+1; length(event{:,2})+1];

if length(gaps) > 1
    for g = 1:length(gaps)-1
        event{gaps(g):gaps(g+1)-1,2} = event{gaps(g):gaps(g+1)-1,2}+shift(g+1);
    end
end
% %check if time is linear in event file - there shouldnt be restart if there
% %is only 1 position file
frames = event{:,2};
diff_frames = diff(frames);
restart = find(diff_frames < 0);

if length(poslist) == 1 && ~isempty(restart)
    event(1:restart+1,:) = [];

end
end
