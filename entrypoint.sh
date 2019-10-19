#!/bin/bash

python /artifacts/manage.py migrate
python /artifacts/manage.py loaddata /artifacts/fixtures/Tasks_Interval.json

#iperf3 -s -p 5202 -J --logfile ./log1.txt &
python -u /artifacts/manage.py runserver 0.0.0.0:8000


