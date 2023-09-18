# Intelligent-forensics-for-the-automatic-anomaly-detection-in-distributed-infrastructures

The system is composed by a client (ubuntu 22.04 with iputils-ping and iproute2), 2 server (server_: ubuntu 22.04; temp: ubuntu 22.04 with iputils-ping, iproute2, nodejs, npm and other packet that still have their usefullness to be checked) and 2 routers (ubuntu 22.04 with iputils-ping, iproute2, coreutils, iptables, frr).
The routers have been set t0 work with the protocol ospf. For sake of semplicity, in this phase, the entire architecture have been inserted in a single area (area 0).


![architecture](./images/architecture_temp2.png)

To run the system:
1. run the docker engine (tested: by running docker desktop)
2. launch the command "docker-compose up -d"
3. access the server temp "docker exec -it intelligent-forensics-temp-1 bash". Add the route to the client network "ip route add 172.16.1.0/24 via 172.16.0.2", in which 172.16.0.2 is the interface of the router connected to the server (router2).
4. in another terminal, access the client "docker exec -it intelligent-forensics-client-1 bash". Add the route to the server network "ip route add 172.16.0.0/24 via 172.16.1.2", in which 172.16.1.2 is the interface of the router connected to the client (router1). Test the connection "ping 172.16.0.11" by pinging the server temp: it should fail:
```console
PING 172.16.0.11 (172.16.0.11) 56(84) bytes of data.
From 172.16.1.2 icmp_seq=2 Redirect Host(New nexthop: 172.16.1.1)
From 172.16.1.2 icmp_seq=3 Redirect Host(New nexthop: 172.16.1.1)
From 172.16.1.2 icmp_seq=4 Redirect Host(New nexthop: 172.16.1.1)
```
5. access the router1 "docker exec -it intelligent-forensics-router1-1 bash". Start frr "service frr start" and check its status "service frr status" is:
```console
 * Status of watchfrr: running
 * Status of zebra: running
 * Status of bgpd: running
 * Status of ospfd: running
 * Status of staticd: running
```
which means all the frr daemons chosen are running.
6. access the router2 "docker exec -it intelligent-forensics-router2-1 bash". Start frr "service frr start" and check its status "service frr status" is:
```console
 * Status of watchfrr: running
 * Status of zebra: running
 * Status of bgpd: running
 * Status of ospfd: running
 * Status of staticd: running
```
which means all the frr daemons chosen are running.
7. Now it's necessary to configure the protocol for both the router. Enter the vty bash with the command "vtysh". Enter the configuration with "conf t" and then the conf of the router "router ospf". Finally, insert the network connected to the router into the same area with "network <xx.xx.xx.xx/xx> area <x>".
     - router1: "network 172.16.2.0/24 area 0" "network 172.16.1.0/24 area 0" ( in conf t -> log file shared-volume/frr/frr.log )
        ***service frr start
        vtysh
        conf t
        log file shared-volume/frr/frr.log #need to be already present before this command
        router ospf 
        network 172.16.2.0/24 area 0
        network 172.16.1.0/24 area 0
        end***
     - router2: "network 172.16.2.0/24 area 0" "network 172.16.0.0/24 area 0"
        conf t
        router ospf
        network 172.16.2.0/24 area 0
        network 172.16.0.0/24 area 0
        end

     Finish this operation with "end"
After this operation, thanks to the daemon of ospf, the routers are going to exchange their routing tables. Verify it with the command "show ip route" that should give:
- router1:
```console
    K>* 0.0.0.0/0 [0/0] via 172.16.1.1, eth0, 00:02:52
    O>* 172.16.0.0/24 [110/20] via 172.16.2.3, eth1, weight 1, 00:00:54
    O   172.16.1.0/24 [110/10] is directly connected, eth0, weight 1, 00:01:29
    C>* 172.16.1.0/24 is directly connected, eth0, 00:02:52
    O   172.16.2.0/24 [110/10] is directly connected, eth1, weight 1, 00:01:37
    C>* 172.16.2.0/24 is directly connected, eth1, 00:02:52
```

- router2

```console
    K>* 0.0.0.0/0 [0/0] via 172.16.2.1, eth0, 00:02:41
    O   172.16.0.0/24 [110/10] is directly connected, eth1, weight 1, 00:01:00
    C>* 172.16.0.0/24 is directly connected, eth1, 00:02:41
    O>* 172.16.1.0/24 [110/20] via 172.16.2.2, eth0, weight 1, 00:00:55
    O   172.16.2.0/24 [110/10] is directly connected, eth0, weight 1, 00:01:02
    C>* 172.16.2.0/24 is directly connected, eth0, 00:02:41
```
8. Exit the vtysh with "exit" and check the route of the host with "ip route show":
- router1:
```console
    default via 172.16.1.1 dev eth0
    172.16.0.0/24 nhid 12 via 172.16.2.3 dev eth1 proto ospf metric 20
    172.16.1.0/24 dev eth0 proto kernel scope link src 172.16.1.2
    172.16.2.0/24 dev eth1 proto kernel scope link src 172.16.2.2
``` 
- router2:
```console
   default via 172.16.2.1 dev eth0
    172.16.0.0/24 dev eth1 proto kernel scope link src 172.16.0.2
    172.16.1.0/24 nhid 14 via 172.16.2.2 dev eth0 proto ospf metric 20
    172.16.2.0/24 dev eth0 proto kernel scope link src 172.16.2.3
```  
9. Now verify that the client can actually ping the server. Enter the client bash and "ping 172.16.0.11" to ping the server temp.


# advices
If the images gets modified by changing the dockerfiles, to be effective the image should be mounted again or simply deleted before using again "docker-compose up -d". Fast way is deleting the images.