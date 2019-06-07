#!/bin/bash
# This is a script meant to let us test NRPE
# plugins we write

Status=$(mount | grep nfs4 | grep -c "")                 #the number of count

status="0"                                  # Change the status to test different alert states

if [ "$status" -ge "1" ]; then              #-lt = less than
    echo "STATUS:OK"
    exit 0;

  elif [ "$status" -lt "1" ]; then
    echo "STATUS:CRITICAL"
    exit 2;

  elif [ "$status" -lt "1" ] ; then
    echo "STATUS:WARNING"
    exit 1;

else
   echo "STATUS:UNKNOWN"
   exit 3;
fi
