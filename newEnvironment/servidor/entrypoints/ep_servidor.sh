#!/bin/bash

apt-get update
apt-get install -y node.js
apt-get install -y npm

#COPY entrypoints/SSR-master-server-main /SSR-master-server-main
git clone https://github.com/gisai/SSR-master-server.git
cd SSR-master-server
npm install -g nodemon@1.18.10
npm install
ip route change default via 10.100.0.10
npm start


