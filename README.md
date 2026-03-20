# vpa.organoid.demo

Demo of LLM-assisted single-cell RNA-seq analysis using a dataset the LLM
has not seen extensively in training.

## The dataset

Single-cell RNA-seq of **control vs valproic acid (VPA)-treated human dorsal
forebrain organoids** (26,499 cells: 12,995 control, 13,504 VPA-treated).
VPA exposure during pregnancy is associated with increased autism spectrum
disorder risk, and this dataset explores VPA's effects on neural progenitor
cells and cortical development using brain organoids.

The data comes from:

> Yentür Z, Sarieva K, Branco L, Kagermeier T, Kulka C, Jarboui MA, Becker K,
> Mayer S. "Multiomics analysis identifies VPA-induced changes in neural
> progenitor cells, ventricular-like regions, and cellular microenvironment in
> dorsal forebrain organoids." *bioRxiv* (2025).
> [doi:10.1101/2025.06.24.661272](https://doi.org/10.1101/2025.06.24.661272)

## How we found and downloaded the data

We used the R package
[cellxgenedp](https://mtmorgan.github.io/cellxgenedp/) to query the
[CZ CELLxGENE Discover](https://cellxgene.cziscience.com/) portal for
small (1K--50K cells) single-cell RNA-seq datasets with a clear
two-condition comparison. We searched dataset titles for keywords like
"control", "treated", "knockout", and "vs", then selected this dataset
(CELLxGENE dataset ID `3a8aec06-3309-4d37-b75d-c59f5f6d55a6`).

The download script (`analysis/00_find_cellxgene_dataset.R`) does the
following:

1. Queries the CELLxGENE API via `cellxgenedp`
2. Downloads the dataset as an H5AD file
3. Converts it to a `SingleCellExperiment` object using `zellkonverter`
4. Saves it as `analysis/vpa_organoids_sce.rds`

## Reproduction

1. Install dependencies:
   ```r
   BiocManager::install(c("cellxgenedp", "zellkonverter",
                          "SingleCellExperiment", "SummarizedExperiment"))
   ```

2. Run the data discovery and download script:
   ```r
   source("analysis/00_find_cellxgene_dataset.R")
   ```

3. The saved RDS can then be loaded in subsequent analysis scripts:
   ```r
   sce <- readRDS(here::here("analysis", "vpa_organoids_sce.rds"))
   ```
