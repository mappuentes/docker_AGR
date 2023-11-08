#!/bin/bash

service syslog-ng start
service frr start


vtysh << EOF
conf t
log file /shared-volume/frr/frr2.log
router ospf 
network 172.16.2.0/24 area 0
network 172.16.0.0/24 area 0
end
EOF




/bin/sleep infinity