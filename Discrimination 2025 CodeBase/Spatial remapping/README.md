# Spatial remapping pipeline


## 1. StabilityAnalysis
Input: CaACtivity.mat

Pipeline: spatial rate map for each  unit is calculated for ctxt A/C and B/D during running; data is split into 1st/2nd & even/odd halves - rate maps and Pearson's r is calculated as a measure of spatial stability (r is averaged for 1 v 2 & even v odd); Ca traces are shuffled and measurement is repeated to identify significantly stable cells (> 95th %ile).

Output: analysis is summarized in PC_tbl, maps are storerd in RateMap struct.


## 2. SpatialRemapping
Codes to visualize analysis on place cells. Run the SpatialRemapping_Notebook.mlx that directly uses functions in the SpatialRemapping folder.

IMPORTANT. The folder contains additional function (see main_CreateInput_Get_SI.m) script that generates the proper input file for the PlaceField GUI (see RateRemapping folder for details)


## Additonal CaEvents
The first part of the pipeline that creates CaActivity.mat using the output file from Minian that is not on Google Drive. Files will be shared upon request.

Pipeline: Ca events are detected and assigned to individual camera frames; assign camera frames to behavioral states (e.g. running, foraging, trial # etc.); position is binned for later map contstruction.

Output: CaActivity.mat 
