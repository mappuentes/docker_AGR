#!/bin/sh

fluentd -c fluentd/etc/fluent.conf &

ip route add default via 10.200.0.10

sleep infinity