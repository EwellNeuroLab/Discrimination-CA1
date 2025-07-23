%% function to count match/mismatch/neutral fields
function [N_mm, dist_mm] = CountMM(Mismatch, cut_off)

dist_mm = cell(4,1);

i=1;
dist_mm{1} = [dist_mm{1}; Mismatch{i}(find(Mismatch{i}(:,1)  >= cut_off),1)];
dist_mm{2} = [dist_mm{2}; Mismatch{i}(find(Mismatch{i}(:,1)  < cut_off & Mismatch{i}(:,2) < cut_off),1)];
dist_mm{3} = [dist_mm{3}; Mismatch{i}(find(Mismatch{i}(:,2)  >= cut_off),1)];

i=2;
if ~isempty(Mismatch{i})
dist_mm{1} = [dist_mm{1}; Mismatch{i}(find(Mismatch{i}(:,2)  >= cut_off),2)];
dist_mm{2} = [dist_mm{2}; Mismatch{i}(find(Mismatch{i}(:,1)  < cut_off & Mismatch{i}(:,2) < cut_off),2)];
dist_mm{3} = [dist_mm{3}; Mismatch{i}(find(Mismatch{i}(:,1)  >= cut_off),2)];
end

dist_mm{4} = [dist_mm{1};dist_mm{2};dist_mm{3}];

N_mm = cellfun(@length, dist_mm);
N_mm(1:3) = N_mm(1:3)./N_mm(4).*100;

end