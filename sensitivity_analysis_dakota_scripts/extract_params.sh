#!/bin/bash

#edit the following 3 values! 
start_case=126
end_case=150
offset=125 

for (( i=$start_case; i<=$end_case; i++ ))
do
  echo "Starting processing for test_dir "$i "run..."
  cd test_dir.$i
  let j=$i-$offset
  cp params.in.$j p.csv 
  sed -i 's/x.*//' p.csv
  sed -i -r 's/.{20}//' p.csv
  sed -i '1d' p.csv
  sed -i '11,25d' p.csv
  tr -d '\n' < p.csv >& p$i.csv
  rm p.csv 
  echo "...done" 
  cd ..
done
