# Rate remapping pipeline

## 1. PlaceFieldGUI

Input: PlaceMaps.mat (generated w/ Spatial remapping/SpatialRemapping/main_CreateInput_Get_SI.m -> see Wrap_SI line 39 where the maps are saved) containing maps for individual context (A/B or C/D) and map calculated across the entire session.

Pipeline: run the FieldCluster.app. Load a data set (e.g.  ...\CA1 miniscope data\M119\TrainingD11\processedData\PlaceMaps.mat). Run the clustering algorithm; toggle on extracted place fields and split/merge them when needed. Tip: place fields are calculated on the full session maps. Visualize map for ctxt A/B to help deciding whether you need to split/merge. 

Output: FieldClustering.mat

Notes: when using the GUI, make sure the PlaceFieldGUI folder is added to the path. Algorithm uses the islocalmax2 function that is available since R2024a.

### GUI manual

1. Click on the Load Data button on the Cluster Fields tab and select a file (named as PlaceMaps.mat).
2. Run the clustering algorithm - Gaussian mixture model (recommended) or k-means. This will cluster each place map.
3. Note. The GMM might gives an error: "Ill-conditioned covariance created at iteration 55". In this case not all the maps will be processed but only the ones up until the error message. If this happens, cluster individual cells in the View Fields tab.

4. Click on the View Fields tab and click Plot Maps to see the full place map and the clustered field maps. To visualize cell activity context-wise, mark the Plot Sessions field (Session 1  = ctxt A/C; Session 2 = ctxt B/D). To visualize the fitted model, mark the Plot pdf field (GMM only). If the cluster looks good, go to the next cell. Toggle between cells by changing the cell ID.
5. If the clustering was not good, you can rerun the clustering with different parameters.
6. Splitting fields. If rerunning did not help, go to the manual editing field. Select a field that you want to split. Draw a closed line around the region you want to split.
7. Merging fields. Select the fields you want to merge (shift+ left click). Click on Merge.
8. Discard. Select the fields you want to delete, and click on discard.
9. When finished, click on Save Results to save the file for down-stream analysis.
10. Analyze fields outside the GUI.

## 2. MakeFieldTable.m

Input: FieldClustering.mat

Pipeline: generating a table for each place field, containing field id, cell id, # of events, field size, distance from reward sites, rate overlap score, etc.

Output: Field_tbl.mat - this table is used to create plots for Figure 4.

## 3. Mismatch analysis

Use the MakeMismatchTable.m to create results for the mismatch analysis (main_Mismatch.m is old and does not exclude incorrect trials, while MakeMismatchTable.m script does).

Pipeline: calculating rate overlap score for fields close to reward sites. Distuingishes between match (i.e. fires more in A field near rew A), mismatch (i.e. fires more in B field near rew A), or neutral.

Output: Mismatch_tbl that is used to create plot for Figure 4.




