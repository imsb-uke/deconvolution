library(MIND)
library(Biobase)
library(dplyr)
library(rjson)

config <- fromJSON(file="configs/glob_config.json")
workdir <- paste(config[["experiment_folder"]], "/results/datasets", sep="")
setwd(workdir)
files <- list.files()

subject_path <- FALSE

for (i in 1:length(files)){
    if (grepl("test", files[i], fixed=TRUE)){
            test_path <- files[i]}
    if (grepl("counts", files[i], fixed=TRUE)){
            ref_counts_path <- files[i]
        }
    if (grepl("celltypes", files[i], fixed=TRUE)){
            ref_celltypes_path <- files[i]
        }
    if (grepl("subject", files[i], fixed=TRUE)){
            subject_path <- files[i]
        }
}

# Bulk
df_bulk <- read.csv(test_path, row.names=1)
df_bulk <- as.matrix(df_bulk)

# single cell
df <- read.csv(ref_counts_path, row.names=1)
df <- as.matrix(df)

sc_meta <- read.csv(ref_celltypes_path, row.names=1)
subjects <- rep("donor1", dim(sc_meta)[1])
sc_meta$subject <- subjects
if (subject_path){
  df_subjects <- read.csv(subject_path, row.names=1)
  sc_meta$subject <- df_subjects[,1]
}
colnames(sc_meta) <- c("cellType", "SubjectName")
sc_meta$cellTypeID <- sc_meta$cellType
sc_meta$subjectID <- sc_meta$SubjectName
rownames(sc_meta) <- colnames(df)


prior = get_prior(sc = df, meta_sc = sc_meta)
frac = est_frac(sig = prior$profile, bulk = log2(1+df_bulk))

deconv = bMIND(bulk = log2(1+df_bulk[rownames(prior$profile),]), 
               frac = frac, profile = prior$profile, covariance = prior$covariance, ncore = 20)

for (i in 1:length(unique(sc_meta$cellType))){
    cell_type_label <- unique(sc_meta$cellType)[i]
    expr <- deconv$A[,i,]
    savename = paste0("results", "bMIND_expr_", cell_type_label, ".csv")
    write.csv(expr, savename)
}