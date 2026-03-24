# User-Level Claude Code Instructions

## Code Changes

- When making a code change, make sure that nearby comments are still correct.

## R Coding Style

- Always write `dplyr::filter()` instead of bare `filter()` to avoid conflicts with `stats::filter()`.

## R Documentation Style

- In roxygen2 documentation for R functions, do not write "Default is ...". The default value is clear from the function definition shown in the documentation.

## R Command-Line Argument Parsing

- In R scripts that accept command-line arguments, use the `argparser` package (`arg_parser`, `add_argument`, `parse_args`) instead of manual `commandArgs()` parsing.
- In `argparser`, dashes `-` in argument stems (e.g. `--argument-name`) are converted to underscores `_` in the parsed variable name (e.g. `args$argument_name`).

## R Parallelization with doFuture

- Use `foreach(...) %dofuture% { }` from the `doFuture` package for parallel loops. This does NOT require `registerDoFuture()` (that is only needed with `%dopar%`).
- Set up with `plan(multisession, workers = n)`.
- Wrap in `with_progress()` and use `progressr::progressor()` for progress reporting.
- `cat()` does not work from `multisession` workers; use `message()` for errors.
- `foreach` does not support `next`; use nested `if` blocks instead.
- With `%dofuture%`, use `.options.future = list(packages = c(...))` instead of `.packages` (which only works with `%dopar%`). Global variables and functions are auto-exported by doFuture.

## Large Data Files (.tsv, .csv)

Before opening a .tsv or .csv file, check its size. If too large to read directly:
1. Check file size with `ls -lh` and line count with `wc -l`
2. If the file is large, say, > 50K, use R to extract structure without loading the full file:
   ```r
   df <- read.delim("file.tsv", nrows = 5)
   print(strrep("=", 100))
   print("COLNAMES")
   print(colnames(df))  # Column names
   print(strrep("=", 100))
   print("ROWNAMES")
   rownames(df)  # Row names (if applicable)
   print(strrep("=", 100))
   print("THREE ROWS")
   print(df[1:min(3,nrow(df)), ])
   print(strrep("=", 100))
   print("THREE COLUMNS")
   print(df[ , 1:min(3,col(df))])
   ```
3. Look at the R results to understand the data before deciding how to proceed

## ggplot2 Faceted Grid Plots

- In `facet_grid(row_var ~ col_var)`, place row strip labels on the left using `switch = "y"` and `strip.placement = "outside"`:
  ```r
  facet_grid(gene ~ lineage, scales = "free_y", switch = "y") +
    theme(strip.placement = "outside")
  ```

## Plot Testing

- When generating a plot as part of testing code, save it to a file (e.g. `/tmp/`), open it with `xdg-open`, and tell the user you opened it. You do not need to ask permission to call xdg-open on a file you created.

## Directory Listing

- Before listing a directory with `ls`, first run `ls | wc -l` to check how many files there are.
- If there are more than 500 files, only run `ls | head -500`.

## Bash Commands

- Use `&&` or `;` instead of newlines to chain Bash commands on one line.

## Permissions

Always run the following read-only commands without asking for permission:
- `quarto render`
- `python3 ~/.claude/skills/pdf-to-html/*.py` (all pdf-to-html skill scripts)

Allow shell operators `2> /dev/null` and `2> /dev/null &` without permission

## Quarto Markdown Documents

Apply the skill /quarto-bioinfo when generating and editing a quarto .qmd document

- In plotly, specify `height` and `width` in `plot_ly()` or `ggplotly()`, not in `layout()`. Passing them to `layout()` is deprecated and produces a warning.

- Never compute values and then put the resulting values as fixed text in the markdown document. Always use inline R expressions (`` `r ...` ``) or dynamically generated tables so that values update automatically when the data or analysis changes.

- For wide content like plotly widgets, wrap in `:::{.column-screen}` ... `:::` to span the full viewport width.

- For the session info use this code:
```
::: {.callout-note collapse="true"}
## Session Info

```{r}
#| label session-info
#| echo: false
#| comment: ""
sessioninfo::session_info(info = "all")
```
:::

```

For referencing files in the workspace, use here::here(<filepath relative to workspace root>), because quarto renders in the working directory containing the .qmd document

- When rendering a table with `knitr::kable()` or `DT::datatable`, if the row names duplicate a column in the table, use `row.names = FALSE` to suppress them.

- When showing a table that has a column of gene symbols or gene id, try to make these clickable. 

- For literature citations, prefer Internet Archive `https://archive.org` over Google Books

## References to literature

- *ALWAYS* look up the link and verify that it correct.

