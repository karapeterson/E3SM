#!/bin/bash

cp env_run.xml env_run.xml.orig #save original xml file for reference
sed -i 's/<entry id="STOP_OPTION" value="ndays">/<entry id="STOP_OPTION" value="nyears">/g' env_run.xml 
sed -i 's/<entry id="STOP_N" value="5">/<entry id="STOP_N" value="25">/g' env_run.xml
sed -i 's/<entry id="RESUBMIT" value="0">/<entry id="RESUBMIT" value="3">/g' env_run.xml
sed -i 's/<entry id="RUN_TYPE" value="startup">/<entry id="RUN_TYPE" value="branch">/g' env_run.xml
sed -i 's,<entry id="RUN_REFDIR" value="ccsm4_init">,<entry id="RUN_REFDIR" value="/nscratch/arctic_tipping_point_results/ELR_E3SM_output_stash/master.A_WCYCL1850.ne4_oQU240.branch.tune.Golaz2019/run/">,g' env_run.xml
sed -i 's/<entry id="RUN_REFCASE" value="case.std">/<entry id="RUN_REFCASE" value="master.A_WCYCL1850.ne4_oQU240.branch.tune.Golaz2019">/g' env_run.xml
sed -i 's/<entry id="RUN_REFDATE" value="0001-01-01">/<entry id="RUN_REFDATE" value="0676-01-01">/g' env_run.xml
sed -i 's,<entry id="RUNDIR" value="/gscratch/$USER/acme_scratch/sandiatoss3/$CASE/run">,<entry id="RUNDIR" value="/nscratch/$USER/acme_scratch/sandiatoss3/$CASE/run">,g' env_run.xml
