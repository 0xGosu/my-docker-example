#!/bin/bash

logfile="/tmp/rabbitnode.log"
firsttimefile="/tmp/firsttimerunning"

curhostname=`hostname`
echo "" > $logfile
echo "New Start Date:" >> $logfile
date >> $logfile
echo "" >> $logfile
echo "Running: rabbitmqctl add_vhost $curhostname" >> $logfile
/usr/sbin/rabbitmqctl add_vhost $curhostname >> $logfile

echo "Running: rabbitmqctl set_permissions -p $curhostname guest '.*' '.*' '.*'" >> $logfile
/usr/sbin/rabbitmqctl set_permissions -p $curhostname guest ".*" ".*" ".*"  >> $logfile
sleep 5
    
# For version 3.5.6 the first time running the cluster needs to enable the plugins
if [ -f $firsttimefile ]; then
  echo "First Time Running Enabling Plugins" >> $logfile
  /usr/sbin/rabbitmq-server -d &
  echo "Waiting for RabbitMQ Server to start" >> $logfile
  sleep 3
  echo "Enabling Plugins" >> $logfile
  /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_web_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs >> $logfile
  echo "Waiting for Plugins to finish" >> $logfile
  sleep 5

  # echo "Stopping the RabbitMQ using stop_app" >> $logfile
  # /usr/sbin/rabbitmqctl stop_app
  # echo "Stopping the RabbitMQ using stop" >> $logfile
  # /usr/sbin/rabbitmqctl stop

  # echo "Stopping the RabbitMQ Server" >> $logfile
  # kill -9 `ps auwwx | grep rabbitmq-server | awk '{print $2}'`
  # sleep 1

  echo "Done First Time Running Enabling Plugins" >> $logfile
  /usr/sbin/rabbitmq-plugins list
  rm -f $firsttimefile >> $logfile
  echo "Done Cleanup First Time File" >> $logfile

  
  # Allow the cluster nodes to wait for the master to start the first time
  if [ -z "$CLUSTERED" ]; then
    echo "Ignoring as this is the server node" >> $logfile
  else
    if [ -z "$CLUSTER_WITH" ]; then
      echo "Ignoring as this is the cluster master node" >> $logfile
    else
      echo "Waiting for the master node to start up" >> $logfile
      sleep 5
      echo "Done waiting for the master node to start up" >> $logfile
    fi
  fi
fi


if [ -z "$CLUSTERED" ]; then

  echo "Starting non-Clustered Server Instance" >> $logfile
  # if not clustered then start it normally as if it is a single server
  /usr/sbin/rabbitmq-server  >> $logfile
  echo "Done Starting non-Clustered Server Instance" >> $logfile
    
  # Tail to keep the foreground process active.
  tail -f /var/log/rabbitmq/*

else
  if [ -z "$CLUSTER_WITH" ]; then
    # If clustered, but cluster is not specified then start normally as this could be the first server in the cluster
    echo "Starting Single Server Instance" >> $logfile
    /usr/sbin/rabbitmq-server >> $logfile
  
    echo "Done Starting Single Server Instance" >> $logfile
  else
    echo "Starting Clustered Server Instance as a DETACHED single instance" >> $logfile
    /usr/sbin/rabbitmq-server -detached >> $logfile

    echo "Stopping App with /usr/sbin/rabbitmqctl stop_app" >> $logfile
    /usr/sbin/rabbitmqctl stop_app >> $logfile

    # This should attempt to join a cluster master node from the yaml file
    if [ -z "$RAM_NODE" ]; then
      echo "Attempting to join as DISC node: /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster rabbit@$CLUSTER_WITH >> $logfile
    else
      echo "Attempting to join as RAM node: /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH" >> $logfile
      /usr/sbin/rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH >> $logfile
    fi
    echo "Starting App" >> $logfile
    /usr/sbin/rabbitmqctl start_app >> $logfile

    echo "Done Starting Cluster Node" >> $logfile
  fi
    
  # Tail to keep the foreground process active.
  tail -f /var/log/rabbitmq/*

fi
