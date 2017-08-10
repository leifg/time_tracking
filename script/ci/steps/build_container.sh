#!/bin/sh

docker build --build-arg VERSION=${1} -t leifg/time_tracking .
