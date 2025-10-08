# Heading-direction pipeline

## 1. Get HD cells
Input: processed dlc position, CaActivity, and the PCanalysis mat files. Running direction is calculated with respect to a reference point (N corner) and binned into 45° bins. Tuning curves and Rayleigh vectors are calculated, and repeated 500 times after shuffling 1) Ca traces and 2) HD. An additional reconstruction analysis was implemented based on Sarel et al to exclude directional tuning due to bias in the position of the animal. 

Output: summary table with properties and identified HDCs.


## 2. VectorRemapping
Functions are wrapped up in the live script, use that instead of this folder.

