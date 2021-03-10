#!/bin/bash
ln -s /opt/demoenv/start.sh /bin/startdemoenv
ln -s /opt/demoenv/stop.sh /bin/stopdemoenv
ln -s /opt/demoenv/shutdown.sh /bin/shutdowndemoenv
cp /opt/demoenv/demoenv.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable demoenv.service
systemctl start demoenv.service
