# EjadTech VNC Smart Shutdown

This is a bash script for internal usage at EjadTech.

The script role is to shutdown the server if there is no vnc activity for a specific amount of time.

The script uses `netstat` command which needs to be installed. On ubuntu you can install it by installing `net-tools` package:
```
# apt install net-tools
```

Usage: (# = As root user)
```
# mkdir /etc/vnc
# cd /etc/vnc
# git clone https://github.com/ejad-tech/vnc-smart-shutdown.git smart-shutdown
# crontab -e
```
Add this line:
```
* * * * *       /etc/vnc/smart-shutdown/check-connections.sh >> /etc/vnc/smart-shutdown/check-connections.log 2&>1
```

By default the script shutdowns the server after 30 minutes of inactivity and listens to open connections at port 5901.
