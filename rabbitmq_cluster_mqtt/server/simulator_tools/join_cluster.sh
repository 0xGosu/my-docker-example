#!/bin/bash

logfile="/tmp/joincluster.log"

echo "" > $logfile
echo "New Join Cluster Event on Date:" >> $logfile
date >> $logfile
echo "" >> $logfile

if [ -z "$CLUSTERED" ]; then
  echo "Nothing to do running as non-Clustered Server Instance" >> $logfile
else
  if [ -z "$CLUSTER_WITH" ]; then
    # If clustered, but cluster is not specified then start normally as this could be the first server in the cluster
    echo "Nothing to do running as Single Server Instance" >> $logfile
  else
    echo "Attempting to Join Cluster as Ram($RAM_NODE)" >> $logfile

    # This should attempt to Join a cluster master node from the yaml file
    if [ -z "$RAM_NODE" ]; then
      echo "Ensuring the RabbitMQ App Started" >> $logfile
      /usr/sbin/rabbitmqctl start_app >> $logfile
      echo "Attempting to Join as DISC node: /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH >> $logfile
    else
      echo "Ensuring the RabbitMQ App Started" >> $logfile
      /usr/sbin/rabbitmqctl start_app >> $logfile
      echo "Attempting to Join as RAM node: /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH >> $logfile
    fi
    echo "Done Join Cluster" >> $logfile
  fi

fi



