#!/bin/bash

# Based on the model described here:
# http://docs.hpcloud.com/#helion/operations/remove_node.html
source ~/admin.rc
compute_nodes=`nova service-list | grep nova-compute | awk '/|/ {print $6}' | tr '\r' ','`
echo "which compute node do you want to delete from: $compute_nodes"
read -r NODE
if [ "${compute_nodes/$NODE}" = "$compute_nodes" ] ; then
  echo "sorry, I did not get one of the hosts in $compute_nodes"
  echo "please re-run the script."
  exit 1
else
  echo "removing nova_compute and neutron_*bridge/switch agents and stopping the services on $NODE"
  # disable service
  nova_agent=`nova service-list | grep nova-compute | grep $NODE | awk '/|/ {print $2}'`
  nova service-disable --reason "node being removed" $NODE nova-compute
  ssh $NODE 'docker stop nova_compute'
  nova service-delete $nova_agent

  # disable neutron agents
  neutron_agents=`neutron agent-list | grep 'openvswitch\|linuxbridge'| grep centos | awk '/|/ {print $2}'`
  neutron agent-update --admin-state-down $agent
  ssh $NODE 'docker stop neutron_linuxbridge_agent'
  ssh $NODE 'docker stop neutron_openvswitch_agent'
  neutron agent-delete $agent
fi
