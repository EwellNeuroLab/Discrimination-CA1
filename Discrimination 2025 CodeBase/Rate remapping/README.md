# Rate remapping pipeline

## 1. PlaceFieldGUI

Input: PlaceMaps.mat (generated w/ Spatial remapping/SpatialRemapping/main_CreateInput_Get_SI.m -> see Wrap_SI line 39 where the maps are saved) containing maps for individual context (A/B or C/D) and map calculated across the entire session.

Pipeline: run the FieldCluster.app. Load a data set (e.g.  ...\CA1 miniscope data\M119\TrainingD11\processedData\PlaceMaps.mat). Run the clustering algorithm; toggle on extracted place fields and split/merge them when needed. Tip: place fields are calculated on the full session maps. Visualize map for ctxt A/B to help deciding whether you need to split/merge. 

Output: FieldClustering.mat

## 2. MakeFieldTable.m

Input: FieldClustering.mat

Pipeline: generating a table for each place field, containing field id, cell id, # of events, field size, distance from reward sites, rate overlap score, etc.

Output: Field_tbl.mat - this table is used to create plots for Figure 4.

## 3. MakeMisMatchTable analysis

Use the MakeMismatchTable.m to create results for the mismatch analysis (main_Mismatch.m is old and does not exclude incorrect trials, while MakeMismatchTable.m script does).

Pipeline: calculating rate overlap score for fields close to reward sites. Distuingishes between match (i.e. fires more in A field near rew A), mismatch (i.e. fires more in B field near rew A), or neutral.

Output: Mismatch_tbl that is used to create plot for Figure 4.


