#!/bin/bash

#Edit the following 5 values! 
start_case=16
end_case=25
E3SM_DIR=/home/kjpeter/E3SM_fork/E3SM
REPO_DIR=/home/kjpeter/ArcticTipping/gitlab/ArcticTippingPts
SCRATCH_TYPE=nscratch

for (( i=$start_case; i<=$end_case; i++ ))
do
  cd $E3SM_DIR
  echo "Starting case "$i "run..."
  source create_setup_build_submit_case_n.sh $i $E3SM_DIR $REPO_DIR/dakota/scripts/uniform_rv_sampling_e3sm $SCRATCH_TYPE >& out_case$i.txt
  echo "...done."
done
