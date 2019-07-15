#/bin/bash

MAILBX=dor.meir999@gmail.com
echo ====================TCAT Working Hours Report============================
last -x -d -s `date +%Y-%m-01` | mail -s "TCAT Monthly Working Hours Report" $MAILBX
last -x -d -s `date +%Y-%m-01`
echo ====================TCAT Working Hours Report============================
