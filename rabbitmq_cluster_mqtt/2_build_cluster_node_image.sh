#!/bin/bash

source common.sh .

pushd server >> /dev/null
echo "Building new Docker Cluster image($username/$nodeimagename)"
docker build --rm -t $username/$nodeimagename .
popd >> /dev/null


