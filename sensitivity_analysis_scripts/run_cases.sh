#!/bin/bash

#Edit the following 5 values! 
start_case=1
end_case=25
E3SM_DIR=/home/kjpeter/E3SM_fork/E3SM
SCRATCH_TYPE=nscratch

for (( i=$start_case; i<=$end_case; i++ ))
do
  cd $E3SM_DIR
  echo "Starting case "$i "run..."
  source create_setup_build_submit_case_n.sh $i $E3SM_DIR $E3SM_DIR/sensitivity_analysis_dakota_scripts $SCRATCH_TYPE >& out_case$i.txt
  echo "...done."
done
