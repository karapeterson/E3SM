
#clear all staged dirs
if [ "$1" == "" ]; then
  echo "Argument 1 (case num) not provided!" 
  exit 0
fi
if [ "$2" == "" ]; then
  echo "Argument 2 (scratch type) not provided!" 
  exit 0
fi
case_num=$1
SCRATCH_TYPE=$2
if [ $case_num = "all" ]; then
  echo "Deleting output for all cases..."
  rm -rf out*txt
  rm -rf /gpfs1/${USER}/acme_scratch/sandiatoss3/master.A_WCYCL1850.ne4_oQU240.sensitivity_*
  rm -rf /$SCRATCH_TYPE/${USER}/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_*
  rm -rf /$SCRATCH_TYPE/${USER}/acme_scratch/sandiatoss3/master.A_WCYCL1850.ne4_oQU240.sensitivity_*
  echo "...done."
else 
  echo "Deleting output for case" $case_num "..."
  rm -rf out_case$case_num.txt
  rm -rf /gpfs1/${USER}/acme_scratch/sandiatoss3/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
  rm -rf /$SCRATCH_TYPE/${USER}/acme_scratch/cases/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
  rm -rf /$SCRATCH_TYPE/${USER}/acme_scratch/sandiatoss3/master.A_WCYCL1850.ne4_oQU240.sensitivity_$case_num
  echo "...done."
fi

