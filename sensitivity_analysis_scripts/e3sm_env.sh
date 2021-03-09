#!/bin/bash
 
#module unload openmpi-intel/1.10
#module unload intel/16.0
#module purge
 
 
alias ncview='/projects/ccsm/ncview/ncview'
export NCVIEW_PATH=/projects/ccsm/ncview
 
# defaults for configure (HOMME, PIO)
export SVN_EDITOR=vi
 
# NCL variables
alias ncln='ncl -n' # turns off the (0) output
export NCL_ROOT=/projects/ccsm/ncl-6.4.0
export NCARG_ROOT=/projects/ccsm/ncl-6.4.0
export NCARG_COLORMAP_PATH=/home/elroesl/nclplots/ncl_colormaps
 
# NCO 
export NCO_PATH=/projects/ccsm/nco
 
# ACME/E3SM necessities for ACMEv0 and v1 (via B.Hillman 06Aug2017)
source /projects/sems/modulefiles/utils/sems-modules-init.sh
 
# Need netcdf path for E3SMv0, and add to PATH 07Mar2018
export NETCDF_PATH=/projects/sems/install/toss3/sems/tpl/netcdf/4.4.1/intel/16.0.2/openmpi/1.10.5/exo_parallel
export PNETCDF_PATH=/projects/ccsm/pnetcdf1.2.0-intel
 
export PATH=$NCL_ROOT:$NCO_PATH/bin:$NCARG_ROOT/bin:$NETCDF_PATH/bin:$NETCDF_PATH/lib:$PNETCDF_PATH/bin:$PATH
# Need to run SAM on TOSS3 08Nov2017
export LD_LIBRARY_PATH=/opt/intel/16.0/compiler/lib/intel64_lin:$NETCDF_PATH/lib:$LD_LIBRARY_PATH
export NETCDF_INCLUDES=/projects/ccsm/tpl/netcdf/4.3.2/intel/13.0.1/openmpi/1.6.5/include
export NETCDF_LIBS=/projects/ccsm/tpl/netcdf/4.3.2/intel/13.0.1/openmpi/1.6.5/lib
export NETCDFROOT=/projects/ccsm/tpl/netcdf/4.3.2/intel/13.0.1/openmpi/1.6.5
export PNETCDFROOT=/projects/ccsm/tpl/netcdf/4.3.2/intel/13.0.1/openmpi/1.6.5
 
export http_proxy=http://wwwproxy.sandia.gov:80
export https_proxy=http://wwwproxy.sandia.gov:80

