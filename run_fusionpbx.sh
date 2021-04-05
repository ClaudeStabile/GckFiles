#!/bin/bash
#
#
# Fusion PBX docker Fromt Debian buster
#
docker run -e TZ="Europe/Zurich" -v /data/ATTACHEMENTS/FUSIONPBX:/attachements --name fusionpbx -h homepbx.free-solutions.org -p 192.168.0.128:9443:443 -p 192.168.0.128:5060:5060/tcp -p 192.168.0.128:5061:5061/tcp -p 192.168.0.128:5065:5065/tcp -p 192.168.0.128:5060:5060/udp -p 192.168.0.128:5061:5061/udp -p 192.168.0.128:5065:5065/udp -p 192.168.0.128:5080:5080/tcp -p 192.168.0.128:5081:5081/tcp -p 192.168.0.128:5080:5080/udp -p 192.168.0.128:5081:5081/udp -p 192.168.0.128:8021:8021 -p 192.168.0.128:8085:8085 -p 192.168.0.128:8081:8081 -p 192.168.0.128:8082:8082 -p 192.168.0.128:10535-10999:10535-10999/udp -it fusionpbx:version2

