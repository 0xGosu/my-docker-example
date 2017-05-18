#!/bin/bash

logfile="/tmp/leavecluster.log"

echo "" > $logfile
echo "New Leave Cluster Event on Date:" >> $logfile
date >> $logfile
echo "" >> $logfile

if [ -z "$CLUSTERED" ]; then
  echo "Nothing to do running as non-Clustered Server Instance" >> $logfile
else
  if [ -z "$CLUSTER_WITH" ]; then
    # If clustered, but cluster is not specified then start normally as this could be the first server in the cluster
    echo "Nothing to do running as Single Server Instance" >> $logfile
  else
    echo "Attempting to Leave Cluster as Ram($RAM_NODE)" >> $logfile
    # This should attempt to Leave a cluster master node from the yaml file
    if [ -z "$RAM_NODE" ]; then
      echo "Attempting to Leave as DISC node: /usr/sbin/rabbitmqctl stop_app" >> $logfile
      /usr/sbin/rabbitmqctl stop_app >> $logfile
      echo "Resetting node with: /usr/sbin/rabbitmqctl reset" >> $logfile
      /usr/sbin/rabbitmqctl reset >> $logfile
    else
      echo "Attempting to Leave as DISC node: /usr/sbin/rabbitmqctl stop_app" >> $logfile
      /usr/sbin/rabbitmqctl stop_app >> $logfile
      echo "Attempting to Leave as RAM node: /usr/sbin/rabbitmqctl reset" >> $logfile
      /usr/sbin/rabbitmqctl reset >> $logfile
    fi
    echo "Done Attempting to Leave Cluster" >> $logfile
  fi

fi



