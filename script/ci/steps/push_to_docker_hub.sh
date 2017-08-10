#!/bin/sh
docker login -u ${2} -p ${3}
docker tag leifg/time_tracking:latest leifg/time_tracking:${1}
docker push leifg/time_tracking:${1}
docker push leifg/time_tracking:latest
