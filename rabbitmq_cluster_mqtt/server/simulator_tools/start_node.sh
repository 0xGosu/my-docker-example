#!/bin/bash

logfile="/tmp/manualstartscript.log"

if [ -z "$CLUSTERED" ]; then

  echo "Starting non-Clustered Server Instance" >> $logfile
  # if not clustered then start it normally as if it is a single server
  /usr/sbin/rabbitmq-server
  echo "Done Starting non-Clustered Server Instance" >> $logfile

else
  if [ -z "$CLUSTER_WITH" ]; then
    # If clustered, but cluster is not specified then start normally as this could be the first server in the cluster
    echo "Starting Single Server Instance" >> $logfile
    /usr/sbin/rabbitmq-server
    echo "Done Starting Single Server Instance" >> $logfile
  else
    echo "starting Clustered Server Instance as a DETACHED single instance" >> $logfile
    /usr/sbin/rabbitmq-server -detached
    echo "Stopping App with /usr/sbin/rabbitmqctl stop_app" >> $logfile
    /usr/sbin/rabbitmqctl stop_app

    # This should attempt to join a cluster master node from the yaml file
    if [ -z "$RAM_NODE" ]; then
      echo "Attempting to join as DISC node: /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
    else
      echo "Attempting to join as RAM node: /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH
    fi
    echo "Starting App" >> $logfile
    /usr/sbin/rabbitmqctl start_app

    echo "Done Starting Cluster Node" >> $logfile
  fi

fi



