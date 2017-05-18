#!/bin/bash

source common.sh .

pushd baseimage >> /dev/null
echo "Building new Docker Base image($username/$baseimagename)"
docker build --rm -t $username/$baseimagename .
popd >> /dev/null


