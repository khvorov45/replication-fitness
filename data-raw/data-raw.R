# Cleaning of the raw files
# Arseniy Khvorov
# Created 2019/10/29
# Last edit 2019/10/29

library(readxl)
library(readr)
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(purrr))

data_folder <- "data"
data_raw_folder <- "data-raw"

extract_info <- function(allinfo) {
  str_match(
    allinfo, "^[[:alnum:]]+-(\\d{1,3})WT?\\d{1,3}V([[:alpha:]]{3})-F(\\d+)$"
  )
}

read_sheet <- function(name, path) {
  suppressMessages(read_xlsx(path, sheet = name)) %>%
    slice(-1) %>%
    rename("day" = "...1") %>%
    pivot_longer(-day, names_to = "allinfo", values_to = "value") %>%
    mutate(
      wildtype_prop = extract_info(allinfo)[, 2] %>% as.numeric(),
      wildtype_prop = wildtype_prop / 100,
      ferret_type = extract_info(allinfo)[, 3] %>%
        recode("Don" = "donor", "Rec" = "recipient"),
      ferret = extract_info(allinfo)[, 4] %>% as.numeric(),
      day = as.numeric(day),
      measurement = recode(
        name, "TCID50" = "tcid50", "PYRO" = "pyro", "RealTime" = "pcr"
      ),
      value = case_when(
        value %in% c(-1, -2, -3) ~ NA_real_,
        value == -4 ~ 0,
        measurement == "pyro" ~ value / 100,
        TRUE ~ value
      )
    )
}

read_workbook <- function(path, sheet_names) {
  map_dfr(sheet_names, read_sheet, path)
}

convert_to_wide <- function(data) {
  data %>%
    select(-allinfo) %>%
    pivot_wider(names_from = "measurement", values_from = "value")
}

save_data <- function(data, name, data_folder) {
  write_csv(data, file.path(data_folder, paste0(name, ".csv")))
}

tabulate_indicators <- function(data_long) {
  out <- table(
    round(data_long$value, 0),
    data_long$measurement,
    useNA = "ifany"
  )
  out[rownames(out) %in% c("-1", "-2", "-3", "-4") | is.na(rownames(out)), ]
}

xl_files <- file.path(data_raw_folder, c("d197n.xlsx", "h273y.xlsx"))

data_list <- map(xl_files, read_workbook, c("TCID50", "RealTime", "PYRO"))
names(data_list) <- str_replace(basename(xl_files), ".xlsx", "")

tabulate_indicators(data_list$d197n)
tabulate_indicators(data_list$h273y)

data_wide_list <- map(data_list, convert_to_wide)

iwalk(data_wide_list, save_data, data_folder)
