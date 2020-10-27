renv::restore()
library(cronR)

home_dir <- "/home/rstudio/Documents/scripts"
log_dir <- "/efi_neon_challenge/log/cron"

noaa_download_repo <- "neon4cast-noaa-download"
aquatic_repo <- "neon4cast-aquatics"
terrestrial_repo <- "neon4cast-terrestrial"
beetle_repo <- "neon4cast-beetles"
phenology_repo <- "neon4cast-phenology"

## NOAA Download
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, noaa_download_repo, "launch_download_downscale.R"),
                    rscript_log = file.path(log_dir, "noaa-download.log"),
                    log_append = FALSE,
                    workdir = file.path(home_dir, noaa_download_repo))
cronR::cron_add(command = cmd, frequency = '0 */2 * * *', id = 'noaa_download')

## Aquatics

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, aquatic_repo,"aquatics-workflow.R"),
                           rscript_log = file.path(log_dir, "aquatics_workflow.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, aquatic_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "7AM", id = 'aquatics-workflow')

## Terrestrial_fluxes

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, terrestrial_repo,"terrestrial-workflow.R"),
                           rscript_log = file.path(log_dir, "terrestrial.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, terrestrial_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "8AM", id = 'terrestrial-workflow')

## Beetles

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, beetle_repo,"beetles-workflow.R"),
                           rscript_log = file.path(log_dir, "beetle.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, beetle_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "9AM", id = 'beetles-workflow')

## Phenology

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, phenology_repo,"phenology-workflow.R"),
                           rscript_log = file.path(log_dir, "phenology.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, beetle_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "6PM", id = 'phenology-workflow')


## Ticks

# Not currently automated


cronR::cron_ls()


