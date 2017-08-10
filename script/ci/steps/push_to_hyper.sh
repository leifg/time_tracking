#!/bin/sh

NEW_VERSION=$1
BUILD_NUM=$2
STARTING_TIMEOUT=2

### To be deleted
PRODUCTION_COOKIE=dsfasdfasdfasdfsadf
FASTBILL_EMAIL=leif@leif.io
FASTBILL_TIMEZONE=Europe/Berlin
FASTBILL_TOKEN=5ae5f7ede2fc908ee976401141e262bc7jIgq2oMn0TQaVkrN9qCmeVFQakrNfph
SECRET_KEY_BASE=wYmWM8FKq66vzfkfzMdmdHxWs13h/Z08V+PUVA/BzpRCIMHVeD0L6W+agyvc0Y1i
### End

NEW_CONTAINER_NAME=timetracking${BUILD_NUM}
echo "Starting New Container ${NEW_CONTAINER_NAME}"

hyper run -d \
  --size=s2 \
  -e PORT=8080 \
  -e REPLACE_OS_VARS=true \
  -e PRODUCTION_COOKIE=${PRODUCTION_COOKIE}  \
  -e FASTBILL_EMAIL=${FASTBILL_EMAIL} \
  -e FASTBILL_TIMEZONE=${FASTBILL_TIMEZONE} \
  -e FASTBILL_TOKEN=${FASTBILL_TOKEN} \
  -e SECRET_KEY_BASE=${SECRET_KEY_BASE} \
  -p 8080:8080 --name  ${NEW_CONTAINER_NAME} \
  leifg/time_tracking:${NEW_VERSION}

echo "Waiting for container to be running"

sleep ${STARTING_TIMEOUT}
NEW_RUNNING_CONTAINER_ID=$(hyper ps --format "{{.ID}}" -f "name=${NEW_CONTAINER_NAME}")

if [[ -z ${NEW_RUNNING_CONTAINER_ID} ]]; then
  echo "Container could not start"
  echo ""
  echo "Logs:"
  hyper logs --tail=all ${NEW_CONTAINER_NAME}
  echo ""
  echo "Cleaning Up"
  hyper rm ${NEW_CONTAINER_NAME}
  exit 2
fi

RUNNING_CONTAINER_ID=$(hyper fip ls | grep timetrackingip | awk '{print $3}')
PUBLIC_IP=$(hyper fip ls | grep timetrackingip | awk '{print $1}')

if [[ ! -z ${RUNNING_CONTAINER_ID} ]]; then
  container_name=$(hyper ps -a --format "{{.Names}}" -f "id=${RUNNING_CONTAINER_ID}")
  echo "Switching Off ${container_name}"
  hyper fip detach ${RUNNING_CONTAINER_ID}
fi

echo "Making ${NEW_CONTAINER_NAME} public"
hyper fip attach ${PUBLIC_IP} ${NEW_CONTAINER_NAME}

if [[ ! -z ${RUNNING_CONTAINER_ID} ]]; then
  container_name=$(hyper ps -a --format "{{.Names}}" -f "id=${RUNNING_CONTAINER_ID}")
  echo "Shutting Down ${container_name}"
  hyper stop ${RUNNING_CONTAINER_ID}
  hyper rm ${RUNNING_CONTAINER_ID}
fi
