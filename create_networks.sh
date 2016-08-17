#!/bin/bash
#   Copyright 2016 Kumulus Technologies <info@kumul.us>
#   Copyright 2016 Robert Starmer <rstarmer@gmail.com>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.source ~/admin.rc

tenant=`openstack project list -f csv --quote none | grep admin | cut -d, -f1`

neutron net-create public --tenant-id ${tenant} --router:external --provider:network_type flat --provider:physical_network physnet1 --shared
#if segmented network{vlan,vxlan,gre} --provider:segmentation_id ${1}
neutron subnet-create public 10.1.10.0/24 --tenant-id ${tenant} --allocation-pool start=10.1.10.80,end=10.1.10.99 --dns-nameserver 8.8.8.8 --disable-dhcp
# --host-route destination=10.0.0.0/8,nexthop=10.1.10.254

neutron net-create private --tenant-id ${tenant}
neutron subnet-create private 192.168.100.0/24 --tenant-id ${tenant} --dns-nameserver 8.8.8.8 --name private


neutron router-create pub-router --tenant-id ${tenant}
neutron router-gateway-set pub-router public
neutron router-interface-add pub-router private

