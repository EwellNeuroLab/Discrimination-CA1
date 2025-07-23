%% Gergely Tarcsay, 2023. Function to read the minian dataset. c: raw ca trace, s: deconvolved signal, a: spatial footprint, unit_id: cell_id. All are coming from the minian pipeline.
function [c,s,a, unit_id] = ReadNCData(rootdir)

    cd(rootdir)
    c = ncread("minian_dataset.nc", 'C');
    s = ncread("minian_dataset.nc", 'S');
    a = ncread("minian_dataset.nc", 'A');
    unit_id = ncread("minian_dataset.nc", 'unit_id');

end



