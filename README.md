# cca_cancer

Code accompanying our ISBI 2021 paper "Multimodal Fusion using Sparse CCA for Breast Cancer Survival Prediction" https://arxiv.org/abs/2103.05432 by Vaishnavi Subramanian,  Tanveer Syeda-Mahmood, Minh N. Do

## Code

The code for CCA is in MATLAB, and that for prediction is in Python. The code is structured as follows:

- ```code```: Contains all the functions to run the CCA methods, the deflation methods, the K-SCCA and K-GCCA code, and code to simulate and evaluate metrics on simulated data.
- ```data```: This directory needs to be created. Data can be downloaded from https://uofi.box.com/s/pvhs03t8u9wfjs6j31c6wbvec7237wfc and unzipped to subdirectories ```data/brca``` and ```data/simulated``` respectively.
- ``` results```: This directory contains all the results from our experiments reported in the conference paper. 
- ``` run```:  All code to re-run our experiments are provided in this directory. 

## Requirements

Python packages: 

- ``numpy==1.18.5``
- ``pandas==1.1.2``
- ``scipy==1.5.2``
- ``scikit-learn==0.23.2``

## Instructions to run code

Here, we provide the details to re-run the code provided in the ```run``` directory.

-----------------------------

#### 1. Simulated data

Code location: ``run/simulated/``

##### Running SCCA on simulated data 

- Run ``run_1_scca_on_simulated.m`` in MATLAB.
- Once done, run ``test_1_scca_on_simulated.m`` in MATLAB to accumulate all results.

##### Running GCCA on simulated data

- Run ``run_1_gcca_on_simulated.m`` in MATLAB. The code requires an input parameter indicated if the graph used in GCCA is based on prior knowledge ``run_1_gcca_on_simulated('prior1')`` or inferred from data ``run_1_gcca_on_simulated('no-prior')``. 
- Once done, run ``test_1_gcca_on_simulated.m`` in MATLAB to accumulate all results. Here also, the code requires the same input parameter as above.

##### Summarizing simulation results
- Run the Jupyter notebook ``summarize_results_simulations.ipynb`` after completing the previous two steps.

-----------------------------

#### 2. 1-dimensional CCA on BRCA data

Code location: ``run/1_xcca_on_brca/``

##### Running SCCA on BRCA data 

- Run ``run_1_scca_on_brca.m`` in MATLAB.

##### Running GCCA on BRCA data

- Run ``run_1_gcca_on_brca.m`` in MATLAB. The code requires an input parameter indicated if the graph used in GCCA is based on prior knowledge ``run_1_gcca_on_brca('prior1')`` or inferred from data ``run_1_gcca_on_brca('no-prior')``. 

##### Summarizing results
- Run the Jupyter notebook ``summarize_results_1_xcca_brca.ipynb`` after completing the previous two steps.

----------------------------

#### 3. K-dimensional CCA on BRCA data

Code location: ``run/k_xcca_on_brca/``

##### Running SCCA on BRCA data 

- Run ``run_k_scca_on_brca.m`` in MATLAB.

##### Running GCCA on BRCA data

- Run ``run_k_gcca_on_brca.m`` in MATLAB. The code requires an input parameter indicated if the graph used in GCCA is based on prior knowledge ``run_k_gcca_on_brca('prior1')`` or inferred from data ``run_k_gcca_on_brca('no-prior')``. 

##### Summarizing results
- Run the Jupyter notebook ``summarize_results_k_xcca_brca.ipynb`` after completing the previous two steps.

---------------

#### 4. Survival prediction with K-dimensional CCA on BRCA data

Code location: ``run/k_xcca_on_brca/survival_prediction``

Run the Jupyter notebook ``1_predict_1yr_survival_classification.ipynb`` after generating the embeddings using the K-dimensional CCA above. 

----------




