## Spatial remapping pipeline

1. CaEvents
Input: minian output (.nc file) containing spatial footprints and temporal dynamics; DLC position data (post-processed to exclude noise) w/ synced camera-miniscope timestamps;     IsDrifting vector to exclude units with unstable Ca dynamics (IsDrifting == 1).

Pipeline: Ca events are detected and assigned to individual camera frames; assign camera frames to behavioral states (e.g. running, foraging, trial # etc.); position is binned for later map contstruction.

Output: CaActivity.mat 


2. StabilityAnalysis
Input: CaACtivity.mat

Pipeline: spatial rate map for each  unit is calculated for ctxt A/C and B/D during running; data is split into 1st/2nd & even/odd halves - rate maps and Pearson's r is calculated as a measure of spatial stability (r is averaged for 1 v 2 & even v odd); Ca traces are shuffled and measurement is repeated to identify significantly stable cells (> 95th %ile).

Output: analysis is summarized in PC_tbl, maps are storerd in RateMap struct.


3. SpatialRemapping
Codes to visualize analysis on place cells. Run the SpatialRemapping_Notebook.mlx that directly uses functions in the SpatialRemapping folder.

