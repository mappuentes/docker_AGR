#!/bin/bash

service syslog-ng start
service frr start

vtysh << EOF
conf t
ip route 10.100.0.0/24 10.100.0.10
ip route 10.200.0.0/24 10.200.0.10
ip route 0.0.0.0/0 10.1.0.20
end
EOF



/bin/sleep infinity