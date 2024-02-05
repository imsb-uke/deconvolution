# Contains code to reproduce figures in DISSECT

## Works best with a conda enrvironment
1. Create a conda environment
```conda create -n dissect_figures_env python=3.9.6```

2. Activate the envionment
```conda activate dissect_figures_env```

3. Install requirements
```pip install -r requirements.txt```

4. Run notebooks within each figure directory. Also includes associated supplementary figures, organized as below.

For each figure and related supplementary figure, notebooks and data are put in subdirectories, as follows:
```
├── fig2
│   ├── 2A-C.ipynb
│   ├── S1A-B.ipynb
│   └── S2A-B.ipynb
│   ├── data
│   ├── plots
├── fig3
│   ├── 3A-C.ipynb
│   ├── 3D-E.ipynb
│   ├── S3.ipynb
│   ├── S4A-B.ipynb
│   ├── data
│   └── plots
├── figS5
│   ├── S5.ipynb
│   ├── data
│   └── plots
├── figS6
│   ├── S6.ipynb
│   ├── data
│   └── plots
├── figS7
│   ├── S7.ipynb
│   ├── data
│   └── plots
└── requirements.txt
```

