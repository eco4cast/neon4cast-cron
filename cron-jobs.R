renv::restore()

library(cronR)
library(git2r)

home_dir <- "/home/rstudio/Documents/scripts"
log_dir <- "/efi_neon_challenge/log/cron"

noaa_download_repo <- "neon4cast-noaa-download"
neon_download_repo <- "neon4cast-neon-download"
aquatic_repo <- "neon4cast-aquatics"
terrestrial_repo <- "neon4cast-terrestrial"
beetle_repo <- "neon4cast-beetles"


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
cronR::cron_add(command = cmd, frequency = '0 */2 * * *', id = 'noaa_download')

## NEON Download
#cmd <- cronR::cron_rscript(rscript = file.path(home_dir, neon_download_repo, "download.R"),
#                           rscript_log = file.path(log_dir, "neon-download.log"),
#                           log_append = FALSE,
#                           workdir = file.path(home_dir, neon_download_repo))
#cronR::cron_add(command = cmd, frequency = 'daily', at = "6AM", id = 'neon_download')

## Aquatics

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, aquatic_repo,"aquatics_workflow.R"),
                           rscript_log = file.path(log_dir, "aquatics_workflow.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, aquatic_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "7AM", id = 'aquatics_workflow')

## Terrestrial_fluxes

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, terrestrial_repo,"terrestrial_workflow.R"),
                           rscript_log = file.path(log_dir, "terrestrial.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, terrestrial_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "8AM", id = 'terrestrial_workflow')


## Beetles

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, beetle_repo,"beetles_workflow.R"),
                           rscript_log = file.path(log_dir, "beetle.log"),
                           log_append = TRUE,
                           workdir = file.path(home_dir, beetle_repo))
cronR::cron_add(command = cmd, frequency = 'daily', at = "9AM", id = 'beetles_workflow')



cronR::cron_ls()


