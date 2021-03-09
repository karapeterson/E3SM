#!/bin/bash -l

dprepro $1 user_nl_cam.template user_nl_cam
dprepro $1 user_nl_mpascice.template user_nl_mpascice
dprepro $1 user_nl_mpaso.template user_nl_mpaso
grep "config_ice_ocean_drag" user_nl_mpascice >& var1
awk {'print $3 }' var1 >& $2
