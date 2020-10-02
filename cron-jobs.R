renv::restore()

library(cronR)
library(git2r)



home_dir <- "/home/rstudio/Documents/scripts"
log_dir <- "/efi_neon_challenge/log/cron"

noaa_download_repo <- "neon4cast-noaa-download"
neon_download_repo <- "neon4cast-neon-download"
aquatic_repo <- "RCN_freshwater"
beetle_repo <- "NEON-community-forecast"

if(dir.exists(file.path(home_dir, noaa_download_repo))){
  if(!git2r::in_repository(file.path(home_dir, noaa_download_repo))){
    git2r::clone(paste0("https://github.com/eco4cast/",noaa_download_repo,".git"),
          local_path = file.path(home_dir, noaa_download_repo))
  }
}

if(dir.exists(file.path(home_dir, neon_download_repo))){
  if(!git2r::in_repository(file.path(home_dir, neon_download_repo))){
    git2r::clone(paste0("https://github.com/eco4cast/",neon_download_repo,".git"),
                          local_path = file.path(home_dir, neon_download_repo))
  }
}

if(dir.exists(file.path(home_dir, aquatic_repo))){
  if(!git2r::in_repository(file.path(home_dir, aquatic_repo))){
    git2r::clone(paste0("https://github.com/eco4cast/",aquatic_repo,".git"),
                          local_path = file.path(home_dir, aquatic_repo))
  }
}

if(dir.exists(file.path(home_dir, beetle_repo))){
  if(!git2r::in_repository(file.path(home_dir, beetle_repo))){
    git2r::clone(paste0("https://github.com/eco4cast/",beetle_repo,".git"),
                          local_path = file.path(home_dir, beetle_repo))
  }
}


## NOAA Download
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, noaa_download_repo, "launch_download_downscale.R"),
                    rscript_log = file.path(log_dir, "noaa-download.log"),
                    log_append = FALSE,
                    workdir = file.path(home_dir, noaa_download_repo))
cronR::cron_add(command = cmd, frequency = '0 */1 * * *', id = 'noaa_download')

## NEON Download
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, neon_download_repo, "download.R"),
                           rscript_log = file.path(log_dir, "neon-download.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, neon_download_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "6AM", id = 'neon_download')

## Aquatics
### Targets
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, aquatic_repo,"02_generate_targets_aquatics.R"),
                           rscript_log = file.path(log_dir, "aquatics-targets.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, aquatic_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "7AM", id = 'Aquatic_02_targets')

### Null forecast
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, aquatic_repo,"03_generate_null_forecast_aquatics.R"),
                           rscript_log = file.path(log_dir, "aquatics-forecast.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, aquatic_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "8AM", id = 'Aquatic_03_forecast')

## Beetles

### Targets
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, beetle_repo,"02_targets.R"),
                           rscript_log = file.path(log_dir, "beetle-targets.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, beetle_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "7am", id = 'Beetles_02_targets')

### Null forecast
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, beetle_repo,"03_forecast.R"),
                           rscript_log = file.path(log_dir, "beetle-forecast.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, beetle_repo))
cronR::cron_add(command = cmd, frequency = 'daily',  at = "8AM", id = 'Beetles_03_forecast')

cronR::cron_ls()


