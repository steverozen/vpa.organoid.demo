# Plan: Quarto Analysis of Control vs VPA-Treated Organoid scRNA-seq

## Context

We downloaded a 2-condition scRNA-seq dataset (Yentür et al. 2025, bioRxiv) from CELLxGENE: human dorsal forebrain organoids, control vs VPA-treated, 26,499 cells. The purpose is to demo LLM-assisted analysis on a dataset the LLM hasn't seen extensively. The audience is biologists, so explanatory text is needed at each step.

## Output File

`analysis/02_ctrl_vs_vpa_analysis.qmd` → self-contained HTML

## Data Summary

- Input: `analysis/vpa_organoids_sce.rds` (SingleCellExperiment, 27,986 genes × 26,499 cells)
- Assay `"X"`: log1p-normalized expression (no raw counts available)
- `condition`: CTRL (12,995) vs VPA (13,504)
- `cell_type`: 5 types (progenitor, neuronal-restricted precursor, Cajal-Retzius, cerebral cortex neuron, unknown)
- `donor_id`: 2 donors (paired design — each donor has both conditions)
- `batch`, `cell_phase` available
- UMAP already computed in `reducedDims(sce, "X_umap")`

## Key Design Decisions

1. **Use existing annotations/UMAP** from the original authors — don't recompute
2. **Pseudobulk DE with limma-voom** (paired design blocking on donor): `expm1()` to back-transform, sum per donor×condition×cell_type, then edgeR/limma pipeline
3. **Caveat**: only 2 donors per condition — results are exploratory; state this clearly
4. **code-fold: true** — hide code by default for biologist audience
5. **All packages already installed** — no new installs needed

## Document Sections

### 1. YAML Header
- Follow CLAUDE.md conventions (author, date, page-layout: full, embed-resources, CSS override)
- Add: toc: true, code-fold: true, code-summary: "Show code"

### 2. Introduction (text only)
- What the experiment is (VPA = HDAC inhibitor, teratogen linked to autism)
- Paired design: 2 donors × 2 conditions
- What the analysis covers

### 3. Setup & Data Loading
- Load packages: SingleCellExperiment, SummarizedExperiment, edgeR, limma, ggplot2, plotly, patchwork, DT, dplyr, tidyr, ggrepel, fgsea, msigdbr, pheatmap, here, glue, scales
- Load SCE, print dims with inline R
- Define color palettes for cell types and conditions
- Helper: clickable gene symbol links to GeneCards

### 4. Experimental Design Overview
- Cross-tabulation tables: condition × donor_id, condition × cell_type
- Explain paired design in plain English

### 5. UMAP Visualizations
- UMAP colored by: cell_type, condition, donor_id, cell_phase
- Side-by-side UMAP split by condition (facet_wrap)
- At least one interactive plotly UMAP
- Explain what UMAP is for biologists

### 6. Cell Type Composition Analysis
- Stacked bar chart: cell type proportions per condition
- Broken down by donor (4 bars) to show consistency
- Table with exact numbers/percentages
- Highlight: progenitors increase, neurons decrease under VPA

### 7. Differential Expression (per cell type)
#### 7a. Pseudobulk aggregation
- Back-transform: `round(expm1(assay(sce, "X")))` → approximate counts
- Sum per donor × condition × cell_type → DGEList
- Explain pseudobulk rationale for biologists

#### 7b. limma-voom DE
- For each major cell type (progenitor, cortex neuron, neuronal-restricted precursor):
  - Design: `~donor_id + condition` (paired)
  - filterByExpr → calcNormFactors → voom → lmFit → eBayes → topTable
- Skip Cajal-Retzius and unknown (too few cells per donor)
- Combine results

#### 7c. DE Visualization
- Volcano plots per cell type (ggrepel for top genes)
- Summary table: # DE genes up/down per cell type (FDR < 0.05)
- Interactive DT table of top DE genes with clickable gene symbols
- Heatmap of top DE genes across pseudobulk samples

### 8. Gene Set Enrichment Analysis
- fgsea with msigdbr Hallmark + GO BP gene sets
- Rank genes by limma t-statistic per cell type
- Dot plot of top enriched pathways
- Explain GSEA concept for biologists

### 9. Known Biology Check
- Violin plots of known VPA-response / neural development genes split by condition and cell type
- Feature plots (UMAP colored by expression) for top DE genes

### 10. Draft Results
- Dynamically generated text using inline R
- Cell composition shifts, # DE genes, key pathways, top genes

### 11. Draft Methods
- Data source, software versions, statistical methods, pathway analysis

### 12. Session Info
- Collapsible callout per CLAUDE.md convention

## Packages (all installed)
edgeR, limma, SingleCellExperiment, SummarizedExperiment, ggplot2, plotly, patchwork, DT, dplyr, tidyr, ggrepel, fgsea, msigdbr, pheatmap, scales, glue, here, Matrix, sessioninfo, viridis

## Known Risks
1. **No raw counts**: back-transforming log1p is approximate but standard for CELLxGENE data; pseudobulk summation smooths rounding errors
2. **n=2 donors**: limited power; use empirical Bayes shrinkage; state results are exploratory
3. **Small cell groups**: Cajal-Retzius (287 cells) and unknown (463) — skip for cell-type-specific DE
4. **Memory**: 238 MB dense matrix; work per cell type where possible

## Verification
1. `quarto render analysis/02_ctrl_vs_vpa_analysis.qmd` should produce self-contained HTML
2. Check UMAP plots show expected clustering
3. Check DE tables have clickable gene links
4. Check Results/Methods drafts use inline R (not hardcoded numbers)
5. Verify HTML is self-contained (open in browser without network)
