#!/bin/bash

cp env_batch.xml env_batch.xml.orig #save original xml file for reference
#The following ensures we are submitting to the priority queue.
sed -i 's,</submit_args>,<arg flag="--qos" name="priority"/>\n</submit_args>,g' env_batch.xml
