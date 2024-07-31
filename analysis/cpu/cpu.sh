#!/bin/bash

cat ${cpu_filename}.out | awk '/12时/ {print $8}' > ${cpu_filename}.read_bw.log
awk '
  BEGIN {
    sum = 0
    count = 0
  }
  /^%idle$/ {
    if (count > 0) {
      average = 100-(sum / count)
      print "Average %util:", average > "${cpu_filename.awk}.read_bw.log"
    }
    sum = 0
    count = s
    next
  }
  NF == 1 {
    sum += $1
    count += 1
  }
  END {
    if (count > 0) {
      average = 100-(sum / count)
      print "Average %util:", average > "${cpu_filename.awk}.read_bw.log"
    }
  }
' ${cpu_filename}.read_bw.log
cat ${io_filename}.out | awk '/nvme/ {print $3}' > ${io_filename}.read_bw.log