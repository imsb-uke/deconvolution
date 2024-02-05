from TAPE import Deconvolution
from configs.main_config import config
from configs.glob_config import config as glob_config
import scanpy as sc
import pandas as pd
import pickle

import os
os.set_wd(config["experiment_folder"])

sim_path = config["reference"]

sc_ref = sc.read(sim_path)
sc_ref.var_names_make_unique()
df = sc_ref.to_df()

bulk = pd.read_table(glob_config["test_dataset"], index_col=0)
bulk = bulk.loc[~bulk.columns.duplicated(keep="first")]

SignatureMatrix, _ = Deconvolution(sim_path, bulk, sep='\t', scaler='mms',
                                                        datatype='counts', genelenfile='./GeneLength.txt',
                                                        mode='high-resolution', adaptive=True, variance_threshold=0.98,
                                                        save_model_name=None,
                                                        batch_size=128, epochs=128, seed=1)

save_name = "results/tape_a_expr.pkl"

for cell_type in list(SignatureMatrix.keys()):
    save_name = os.path.join(f"results", "tape_a_{cell_type}.csv")
    SignatureMatrix[cell_type].to_csv(save_name)