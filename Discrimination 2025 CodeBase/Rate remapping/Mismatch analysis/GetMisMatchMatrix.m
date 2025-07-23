%% function to get mismatch matrices

function rate_ordered = GetMisMatchMatrix(rate,id,pref)
% split fields into ctx A and B RZ fields
idx = cell(2,1);
pref_split = cell(2,1);
rate_split = cell(2,1);
rate_ordered = cell(2,1);
for i = 1:2
    idx{i} =find(id == i);
    pref_split{i} = pref(idx{i});
    rate_split{i} = rate(idx{i},:);
    [~,sorted_idx] = sort(pref_split{i},'descend');
    rate_ordered{i} = rate_split{i}(sorted_idx,:);
    rate_ordered{i} = rate_ordered{i}./sum(rate_ordered{i},2);
end



