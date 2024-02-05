from TAPE import Deconvolution
from configs.main_config import config
from configs.glob_config import config as glob_config
import scanpy as sc
import pandas as pd

sc_ref = sc.read(glob_config["reference"])
sc_ref.var_names_make_unique()
df = sc_ref.to_df()

bulk = pd.read_table(glob_config["test_dataset"], index_col=0)
bulk = bulk.loc[~bulk.columns.duplicated(keep="first")]

SignatureMatrix, CellFractionPrediction = Deconvolution(sc_ref, bulk, sep='\t', scaler='mms', samplenum=6000,
                                                        datatype='counts', genelenfile='./GeneLength.txt',
                                                        mode='high-resolution', adaptive=True, variance_threshold=0.98,
                                                        save_model_name=None,
                                                        batch_size=128, epochs=128, seed=1)

save_name = "results/tape_a_results.txt"
CellFractionPrediction.to_csv(save_name, sep="\t")