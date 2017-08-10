#!/bin/sh

set -e

base_dir=$(dirname $0)

if [ ! -f .version ]; then
  echo "No version change, skip deployment"
else
  VERSION=$(cat .version)
  echo "Replace Version"
  ${base_dir}/steps/replace_version.sh ${VERSION}

  echo "Build Release"
  ${base_dir}/steps/build_release.sh

  echo "Build Run Container"
  ${base_dir}/steps/build_container.sh ${VERSION}

  echo "Push to Docker Hub"
  ${base_dir}/steps/push_to_docker_hub.sh ${VERSION} ${DOCKER_USER} ${DOCKER_PASS}

  echo "Push to Hyper"
  ${base_dir}/steps/push_to_hyper.sh ${VERSION} ${CIRCLE_BUILD_NUM}
fi
