# replication-fitness

The goal of replication-fitness is to fit the model from [Petrie
(2015)](https://doi.org/10.1016/j.jtbi.2015.07.003) using the Bayesian
framework using [Stan](https://mc-stan.org/) and
[R](https://www.r-project.org/).

## Usage

## Usage

Everything can be run interactively (launch the `.Rproj` file in
RStudio). Every script (except those that start with `test-`) 
can also be executed from a terminal as long as
the working directory is that of the `.Rproj` file, for example:

```
cd path/to/transmission-fitness.Rproj
Rscript data-plot/data-plot.R
```

Note that all the plots use a modified version of `ggdark` which is installed via `devtools::install_github("khvorov45/ggdark")`. CRAN's `ggdark` does not have the same functions. To use CRAN's `ggdark`, remove `verbose` argument to `dark_theme_bw`, replace `ggsave_dark` with `ggsave` and remove its `dark` argument.

## Directories

- `data` contains `.csv` files that serve as the data to be analysed.

- `data-plot` contains a script to generate data plots. The script
looks for `.csv` files in the `data` folder.

- `data-raw` contains files that need to be cleaned before moving into
`data`. The script cleans the data in `data-raw` and moves it to
`data` keeping the filenames.

- `fit` fits a model from the `model` folder to the datasets in the
`data` folder.

- `fit-diagnostic` diagnostics of model fits found in `fit`. The key is in `key.txt` inside the folder.

- `fit-plot` plots of results. The key is in `key.txt` inside the folder.

- `model` contains Stan model files. 

- `paper` contains the paper describing the model.

- `simulation` contains a script that simulates ideal data for the
model and verifies the model by fitting it to the simulated data.

## Simulation results
