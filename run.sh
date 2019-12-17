#!/usr/bin/env bash

# Exit on failure
set -e

# Be verbose
set -x

# Set defaults
CUPSADMIN=${CUPSADMIN:=admin}
CUPSPASSWORD=${CUPSPASSWORD:=admin}

# Add user
if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
    adduser --system --ingroup lpadmin --no-create-home $CUPSADMIN
fi

# Set password
echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

# Setup configuration
mkdir -p /config

# Persistent printer configuration
if [ -f /config/printers.conf ]; then
    cp /config/printers.conf /etc/cups/printers.conf
else
    touch /etc/cups/printers.conf
    cp /etc/cups/printers.conf /config/printers.conf
fi

# Persisent cups configuration
if [ ! -f /config/cupsd.conf ]; then
    # Baked-in config file changes
    sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf
    sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf
    echo 'ServerAlias *' >> /etc/cups/cupsd.conf
    echo 'DefaultEncryption Never' >> /etc/cups/cupsd.conf
else
    cp /config/printers.conf /etc/cups/printers.conf
fi

# Notify script, will run forked
function inotify() {
    # Stop being verbose
    set +x
    while true; do
        # Check for modified files in /etc/cups and copy them to /config
        inotifywatch -e modify -t 1 /etc/cups 2>/dev/null | grep total &>/dev/null && \
        cp -u /etc/cups/{cupsd,printers}.conf /config 2>/dev/null
    done
}
inotify &

# Start cups in foreground
exec /usr/sbin/cupsd -f
