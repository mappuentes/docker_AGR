#!/bin/bash

service syslog-ng start
service frr start


vtysh << EOF
conf t
ip route 10.0.1.0/24 10.2.0.20
ip route 10.0.2.0/24 10.2.0.20
ip route 10.0.3.0/24 10.3.0.20
ip route 10.0.4.0/24 10.3.0.20
ip route 10.2.0.0/24 10.2.0.10
ip route 10.3.0.0/24 10.3.0.10
ip route 0.0.0.0/0 10.1.0.10
end
EOF




/bin/sleep infinity