#remotes::install_github("rqthomas/cronR")
#remotes::install_deps()
library(cronR)

home_dir <- "/home/rstudio/Documents/scripts"
log_dir <- "/efi_neon_challenge/log/cron"

noaa_download_repo <- "neon4cast-noaa-download"
aquatic_repo <- "neon4cast-aquatics"
terrestrial_repo <- "neon4cast-terrestrial"
beetle_repo <- "neon4cast-beetles"
phenology_repo <- "neon4cast-phenology"
ticks_repo <- "neon4cast-ticks"

shared_utilities_repo <- "neon4cast-shared-utilities"

scoring_repo <- "neon4cast-scoring"
submissions_repo <- "neon4cast-submissions"

## NOAA Download
cmd <- cronR::cron_rscript(rscript = file.path(home_dir, noaa_download_repo, "launch_download_downscale.R"),
                    rscript_log = file.path(log_dir, "noaa-download.log"),
                    log_append = FALSE,
                    workdir = file.path(home_dir, noaa_download_repo),
                    trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/2889eaa2-cb7a-4e3b-b76e-b034e340295f")
cronR::cron_add(command = cmd, frequency = '0 */2 * * *', id = 'noaa_download')

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, noaa_download_repo, "launch_cfs_download_downscale.R"),
                           rscript_log = file.path(log_dir, "noaacfs-download.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, noaa_download_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/bccdd589-2c8d-49cc-8404-033d6c8ed12a")
cronR::cron_add(command = cmd, frequency = '0 */3 * * *', id = 'noaacfs_download')

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, noaa_download_repo, "run_stack_noaa.R"),
                           rscript_log = file.path(log_dir, "noaa-stack.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, noaa_download_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/b2122302-6996-4a08-ab1c-f7f29d04e160")
cronR::cron_add(command = cmd, frequency = 'daily', at = "4AM", id = 'noaa_stack')

## NEON Download

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, shared_utilities_repo, "neon_download_store.R"),
                           rscript_log = file.path(log_dir, "neon-download.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, shared_utilities_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/cb249e47-f56b-45da-af7f-9c0c47db1a6c")
cronR::cron_add(command = cmd,  frequency = 'daily', at = "4AM", id = 'neon_download')

## Phenocam Download

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, phenology_repo, "01_download_phenocam_data.R"),
                           rscript_log = file.path(log_dir, "phenology-download.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, phenology_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/f5d48d96-bb41-4c21-b028-930fa2b01c5a")
cronR::cron_add(command = cmd,  frequency = '0 */2 * * *', id = 'phenocam_download')

## Aquatics

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, aquatic_repo,"aquatics-workflow.R"),
                           rscript_log = file.path(log_dir, "aquatics.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, aquatic_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/1267b13e-8980-4ddf-8aaa-21aa7e15081c")
cronR::cron_add(command = cmd, frequency = 'daily', at = "7AM", id = 'aquatics-workflow')

## Beetles

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, beetle_repo,"beetles-workflow.R"),
                           rscript_log = file.path(log_dir, "beetle.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, beetle_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/ed35da4e-01d3-4750-ae5a-ad2f5dfa6e99")
cronR::cron_add(command = cmd, frequency = 'daily', at = "8AM", id = 'beetles-workflow')

## Terrestrial_fluxes

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, terrestrial_repo,"terrestrial-workflow.R"),
                           rscript_log = file.path(log_dir, "terrestrial.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, terrestrial_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/c1fb635f-95f8-4ba2-a348-98924548106c")
cronR::cron_add(command = cmd, frequency = 'daily', at = "9AM", id = 'terrestrial-workflow')

## Phenology

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, phenology_repo,"phenology-workflow.R"),
                           rscript_log = file.path(log_dir, "phenology.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, phenology_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/c274d8c1-080e-47b7-94ed-6ecf78a3de00")
cronR::cron_add(command = cmd, frequency = 'daily', at = "10PM", id = 'phenology-workflow')


## Ticks

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, ticks_repo,"ticks-workflow.R"),
                           rscript_log = file.path(log_dir, "ticks.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, ticks_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/09c7ab10-eb4e-40ef-a029-7a4addc3295b")
cronR::cron_add(command = cmd, frequency = "0 11 1 * *", id = 'ticks-workflow')

## Scoring 

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, submissions_repo, "process_submissions.R"),
                           rscript_log = file.path(log_dir, "process_submissions.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, submissions_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/dad902ab-4847-4303-bd61-c27de2a1b43a")
cronR::cron_add(command = cmd, frequency = 'hourly', id = 'process_submissions')

cmd <- cronR::cron_rscript(rscript = file.path(home_dir, scoring_repo, "scoring.R"),
                           rscript_log = file.path(log_dir, "scoring.log"),
                           log_append = FALSE,
                           workdir = file.path(home_dir, scoring_repo),
                           trailing_arg = "curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/1dd67f13-3a08-4a2b-86a3-6f13ab36baca")
cronR::cron_add(command = cmd, frequency = 'daily', at = "11 am", id = 'scoring')


cronR::cron_ls()


