FROM tranvietanh1991/rabbitclusterbase
MAINTAINER V.Anh Tran tranvietanh1991@gmail.com

# Create directories
RUN mkdir /opt/rabbit && \
    mkdir /opt/simulator && \
    mkdir /opt/simulator/tools

# Add the files from the local repository into the container
ADD rabbitmq.config rabbitmq-env.conf /etc/rabbitmq/
ADD erlang.cookie       /var/lib/rabbitmq/.erlang.cookie
ADD startclusternode.sh debugnodes.sh /opt/rabbit/
ADD tl rl rst           /bin/

# Add the simulator tooling
ADD simulator_tools/*.sh   /opt/simulator/tools/

# Set the file permissions in the container
# Set ownership permissions on files in the container
RUN chmod 644 /etc/rabbitmq/rabbitmq.config && \
    chmod 644 /etc/rabbitmq/rabbitmq-env.conf && \
    chmod 400 /var/lib/rabbitmq/.erlang.cookie && \
    chmod 777 /opt/rabbit/startclusternode.sh && \
    chmod 777 /opt/rabbit/debugnodes.sh && \
    chmod 777 /bin/tl && \
    chmod 777 /bin/rl && \
    chmod 777 /bin/rst && \
    chmod 777 /opt/simulator && \
    chmod 777 /opt/simulator/tools && \
    chmod 777 /opt/simulator/tools/start_node.sh && \
    chmod 777 /opt/simulator/tools/stop_node.sh && \
    chmod 777 /opt/simulator/tools/join_cluster.sh && \
    chmod 777 /opt/simulator/tools/leave_cluster.sh && \
    chmod 777 /opt/simulator/tools/reset_first_time_running.sh && \
    chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie 

# Expose ports inside the container to the host
EXPOSE 1883 8883 5672 15672 15675 25672 4369 9100 9101 9102 9103 9104 9105

# Run this to debug the cluster nodes by allowing ssh login
#CMD /opt/rabbit/debugnodes.sh

# Run this to autostart the cluster nodes
CMD /opt/rabbit/startclusternode.sh

