#Rscript prepare_data_DSTG.R
cd DSTG/DSTG
Rscript convert_data.R /Users/robin/Desktop/experiments/results/datasets/dstg_sc.rds /Users/robin/Desktop/experiments/results/datasets/dstg_st.rds /Users/robin/Desktop/experiments/results/datasets/dstg_scc.rds
#Rscript convert_data.R synthetic_data/counts.rds synthetic_data/test.rds synthetic_data/temp.rds

python train.py
cd ../../