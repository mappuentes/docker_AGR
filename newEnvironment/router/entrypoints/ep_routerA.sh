#!/bin/bash

service syslog-ng start
service frr start

vtysh << EOF
conf t
log file /shared-volume/frr/frrRouterA.log
router ospf
network 10.100.0.0/24 area 0
network 10.200.0.0/24 area 0
network 10.1.0.0/24 area 0
end
EOF



/bin/sleep infinity