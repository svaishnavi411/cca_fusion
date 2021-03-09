# cca_cancer

Code accompanying our ISBI 2021 paper "Multimodal Fusion using Sparse CCA \\for Breast Cancer Survival Prediction" by Vaishnavi Subramanian,  Tanveer Syeda-Mahmood, Minh N. Do

#### Code

The code for CCA is in MATLAB, and that for prediction is in Python. The code is structured as follows:

- ```code```: Contains all the functions to run the CCA methods, the deflation methods, the K-SCCA and K-GCCA code, and code to simulate and evaluate metrics on simulated data.
- ```data```: This directory should contain the data downloaded from https://uofi.box.com/s/pvhs03t8u9wfjs6j31c6wbvec7237wfc downloaded and unzipped to subdirectories ```data/brca``` and ```data/simulated``` respectively.
- ``` results```: This directory contains all the results from our experiments reported in the conference paper. 
- ``` run```:  All code to re-run our experiments are provided in this directory. 

#### Instruction to run code

Here, we provide the details to re-run the code provided in the ```run``` directory.

