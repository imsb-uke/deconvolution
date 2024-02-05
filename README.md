# deconvolution
Runs deconvolution pipeline. 
Data and figures to reproduce all main figures are available in paper_figures together with instructions. 

DISSECT with usage instructions and tutorials is available at [https://github.com/imsb-uke/DISSECT](https://github.com/imsb-uke/DISSECT).

## Usage
Make sure to install individual packages of MuSiC, BayesPrism, TAPE and Scaden. DISSECT is configured by configs/main_config.py. All others methods are controlled by config/glob_config.py which requires path to single-cell and bulk datasets. It can be modified for each experiment.

## Requirements
```
scaden==1.1.2
scTAPE==1.1.0
MuSiC==1.0.0
BayesPrism==2.1.2
CibersortX docker

```

```
# Update config files
## dissect: configs/main_config.py, others: configs/glob_config.py

# Simulate
python simulate.py

# Prepare data to use with python and R. This will save files in the required format for each method.
python prepare_data.py
python prepare_data_others.py # For CibersortX, required format will be saved in the experiment directory under folder CS_datasets

# Run deconvolution
bash dissect.sh
Rscript music.R
python scaden.py
python tape_A.py
python tape_O.py
Rscript bayesPrism.R
Rscript bayesPrism_M.R
```
