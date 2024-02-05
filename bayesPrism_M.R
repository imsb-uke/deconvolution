library(BayesPrism)
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
df_bulk <- t(df_bulk)

# single cell
df <- read.csv(ref_counts_path, row.names=1)
df_celltypes <- read.csv(ref_celltypes_path, row.names=1)
celltype_labels <- df_celltypes$cellType

scrna.filtered <-  select.gene.type(scrna, gene.type = "protein_coding")

scrna.filtered <- cleanup.genes(input=as.matrix(scrna),
                                  input.type="count.matrix",
                                  species="hs", 
                                  gene.group=c("Rb","Mrp","MALAT1", "other_Rb","chrM","chrX","chrY") ,
                                  exp.cells=5)

diff.exp.stat <- get.exp.stat(sc.dat=scrna.filtered[,colSums(scrna.filtered>0)>3],# filter genes to reduce memory use
                                     cell.type.labels=celltype_labels,
                                     cell.state.labels=celltype_labels,
                                     pseudo.count=0.1, #a numeric value used for log2 transformation. =0.1 for 10x data, =10 for smart-seq. Default=0.1.
                                     cell.count.cutoff=50, # a numeric value to exclude cell state with number of cells fewer than this value for t test. Default=50.
                                     n.cores=1 #number of threads
                                          )

sc.dat.filtered.pc.sig <- select.marker(sc.dat=scrna.filtered,
                                                stat=diff.exp.stat,
                                                pval.max=0.01,
                                                lfc.min=0.1)

myPrism <- new.prism(reference=sc.dat.filtered.pc.sig, 
                      mixture=df_bulk,
                      input.type="count.matrix", 
                      cell.type.labels = celltype_labels, 
                      cell.state.labels = celltype_labels,
                      key=NULL,
                      outlier.cut=0.01,
                      outlier.fraction=0.1)

bp.res <- run.prism(prism = myPrism, n.cores=50)
preds <- get.fraction (bp=bp.res,
            which.theta="final",
            state.or.type="type")

write.csv(preds, "bayesPrism_M_fractions.csv")