# Find a 2-condition scRNA-seq dataset on CELLxGENE
# that is small and not widely used in tutorials

# install.packages("BiocManager")
# BiocManager::install("cellxgenedp")

library(cellxgenedp)
library(dplyr)

db <- db(overwrite = FALSE)

# See what diseases are available
facets(db, "disease")

# Look at all datasets with their metadata
ds <- datasets(db)
colnames(ds)

# Find datasets that have a disease (not just "normal")
# and are relatively small (< 50K cells)
ds_small <- ds |>
  dplyr::filter(
    cell_count < 50000,
    cell_count > 1000
  )

nrow(ds_small)

# Check which of these have disease annotations
ds_small |>
  select(dataset_id, title, cell_count, disease, organism, assay) |>
  print(n = 30)

# ---- download-vpa-organoids ----
# Control vs VPA-treated dorsal forebrain organoids (26,499 cells)
vpa_dataset_id <- "3a8aec06-3309-4d37-b75d-c59f5f6d55a6" # selected from human examinatino ofds_small

vpa_file <- ds |>
  dplyr::filter(dataset_id == vpa_dataset_id) |>
  left_join(files(db), by = "dataset_id") |>
  dplyr::filter(filetype == "H5AD")

local_h5ad <- files_download(vpa_file, dry.run = FALSE)
cat("Downloaded to:", local_h5ad, "\n")

# Convert to SingleCellExperiment
# BiocManager::install("zellkonverter")
library(zellkonverter)
sce <- readH5AD(local_h5ad, use_hdf5 = TRUE, reader = "R")
sce
dim(sce)
library(SummarizedExperiment)
colnames(colData(sce))
table(colData(sce)$condition)

# Load data into memory (from HDF5-backed) so it can be saved as RDS
assay(sce, "X") <- as.matrix(assay(sce, "X"))
saveRDS(sce, here::here("analysis", "vpa_organoids_sce.rds"))
