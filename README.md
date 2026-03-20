# recount3SRP150473

Analysis of mouse visual cortex neuronal cell-type RNA-seq data from
[SRA study SRP150473](https://www.ncbi.nlm.nih.gov/sra/?term=SRP150473)
using the [recount3](https://bioconductor.org/packages/recount3/) Bioconductor package.

This dataset contains 140 paired-end Illumina HiSeq 2500 runs
of mouse visual cortex neurons.

## Reproduction

1. Install recount3:
   ```r
   BiocManager::install("recount3")
   ```

2. Render the analysis:
   ```bash
   quarto render analysis/01_download_and_explore.qmd
   ```
