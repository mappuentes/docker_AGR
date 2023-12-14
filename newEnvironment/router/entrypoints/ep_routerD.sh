#!/bin/bash

service syslog-ng start
service frr start


vtysh << EOF
conf t
ip route 10.0.3.0/24 10.0.3.10
ip route 10.0.4.0/24 10.0.4.10
ip route 0.0.0.0/0 10.3.0.10
end
EOF




/bin/sleep infinity