from TAPE import Deconvolution
from configs.main_config import config
from configs.glob_config import config as glob_config
import scanpy as sc
import pandas as pd

sim_path = config["reference"]
real_path = config["test_dataset"]
real_data_type = config["test_dataset_type"]
if real_data_type=="h5ad":
    real_path = [file for file in "results/CS_datasets/" if "test" in file][0]
savename = "results/scaden_results.txt"
var_cutoff = 0.1
processed_path = "results/scaden_processed.h5ad"
model_dir = "results/scaden_model"

sc_ref = sc.read(glob_config["reference"])
sc_ref.var_names_make_unique()
df = sc_ref.to_df()

bulk = pd.read_table(glob_config["test_dataset"], index_col=0)
bulk = bulk.loc[~bulk.columns.duplicated(keep="first")]

SignatureMatrix, CellFractionPrediction = Deconvolution(sc_ref, bulk, sep='\t', scaler='mms', samplenum=6000,
                                                        datatype='counts', genelenfile='./GeneLength.txt',
                                                        mode='overall', adaptive=False, variance_threshold=0.98,
                                                        save_model_name=None,
                                                        batch_size=128, epochs=128, seed=1)

save_name = "results/tape_o_results.txt"
CellFractionPrediction.to_csv(save_name, sep="\t")