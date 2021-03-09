#!/bin/bash

case_num="$1"
BASE_DIR="$2"
DAKOTA_FILES_DIR="$3"
SCRATCH_TYPE="$4"

if [ "$1" == "" ]; then
  echo "Case number argument not provided!" 
  exit 0
fi
if [ "$2" == "" ]; then
  echo "BASE_DIR argument not provided!" 
  exit 0
fi
if [ "$3" == "" ]; then
  echo "DAKOTA_FILES_DIR argument not provided!" 
  exit 0
fi
if [ "$4" == "" ]; then
  echo "SCRATCH_TYPE argument not provided!" 
  exit 0
fi
echo "scratch_type = " $SCRATCH_TYPE
cd $BASE_DIR
echo "Sourcing E3SM environment script..."
source e3sm_env.sh
echo "...done."
echo "Entering cime/scripts directory..."
cd $BASE_DIR/cime/scripts
echo "...done."
echo "Creating newcase "$case_num "..."
./create_newcase --res ne4_oQU240 --compset A_WCYCL1850 --project FY180068P --case /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num --walltime 26:00:00 --pecount 96
echo "...done."
echo "Entering case directory for case "$case_num "..."
cd /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
echo "...done."
echo "Modifying env_run.xml for case "$case_num "..."
if [ "$SCRATCH_TYPE" == "gscratch" ]; then
  cp $BASE_DIR/modify_env_run_xml_gscratch.sh /gscratch/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
  source modify_env_run_xml_gscratch.sh 
fi
if [ "$SCRATCH_TYPE" == "nscratch" ]; then
  cp $BASE_DIR/modify_env_run_xml_nscratch.sh /nscratch/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
  source modify_env_run_xml_nscratch.sh 
fi
echo "...done."
#IKT: comment out the following 4 lines if not submitting to priority queue 
echo "Modifying env_batch.xml for case "$case_num "..."
cp $BASE_DIR/modify_env_batch_xml.sh /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
source modify_env_batch_xml.sh 
echo "...done."
echo "Running case setup for case "$case_num "..."
./case.setup 
echo "...done."
echo "Creating sym links to restart files and copying rpointer files into run directory for case "$case_num "..."
cd /$SCRATCH_TYPE/$USER/acme_scratch/sandiatoss3/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num/run/
echo "PWD = " $PWD 
ln -s /gscratch/arctic_tipping_point_results/ELR_E3SM_output_stash/master.A_WCYCL1850.ne4_oQU240.branch.tune.Golaz2019/run/*676*.nc  .
cp /gscratch/arctic_tipping_point_results/ELR_E3SM_output_stash/master.A_WCYCL1850.ne4_oQU240.branch.tune.Golaz2019/run/rpointer*  .
echo "...done."
echo "Moving back to case directory for case "$case_num "..."
cd /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
echo "...done."
echo "Copying user_nl files from "$DAKOTA_FILES_DIR "to present dir for case "$case_num "..."
cp $DAKOTA_FILES_DIR/test_dir.$case_num/user_nl_cam /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
cp $DAKOTA_FILES_DIR/test_dir.$case_num/user_nl_mpaso /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
cp $DAKOTA_FILES_DIR/test_dir.$case_num/user_nl_mpascice /$SCRATCH_TYPE/$USER/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
echo "...done."
echo "Build case directory for case "$case_num "..."
./case.build
echo "...done."
echo "Submit case directory for case "$case_num "..."
./case.submit --mail-user $USER@sandia.gov --mail-type all
echo "...done."

