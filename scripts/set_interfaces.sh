#!/bin/bash
# This script sets the default /etc/network/interfaces config back in place

errcho() { echo "$@" 1>&2; }

# Read command-line parameters
while getopts ":h" opt; do
        case "$opt" in
                h)
                        HELP=true
                        ;;
                \?)
                        errcho "Invalid option: -$OPTARG"
                        exit 1
                        ;;
                 :)
                        errcho "Option -$OPTARG requires an argument."
                        exit 1
                        ;;

        esac
done

if [[ $HELP == true ]]
then
        echo "set_interfaces.sh -- Overwrite /etc/network/interfaces file with RaspiPass bridged config"
        echo
        echo "*** NOTE: To be run with sudo, or as root"
        echo
        echo "USAGE: set_interfaces.sh [OPTIONS]"
        echo
        echo "Option            Meaning"
        echo "-h                This help text"
        exit 0
fi

echo "Restoring default /etc/network/interfaces file..."
echo "# Generated by RaspiPass set_interfaces.sh" > /etc/network/interfaces
echo "# This file describes the network interfaces available on your system" >> /etc/network/interfaces
echo "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# The loopback network interface" >> /etc/network/interfaces
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Configure eth0 and wlan0" >> /etc/network/interfaces
echo "allow-hotplug eth0" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet manual" >> /etc/network/interfaces
echo "auto wlan0" >> /etc/network/interfaces
echo "iface wlan0 inet manual" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Configure bridge and add eth0" >> /etc/network/interfaces
echo "auto br0" >> /etc/network/interfaces
echo "iface br0 inet dhcp" >> /etc/network/interfaces
echo "    bridge_ports eth0" >> /etc/network/interfaces
echo "    bridge_stp on" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Load iptables rules before bringing up interfaces" >> /etc/network/interfaces
echo "pre-up iptables-restore < /raspi_secure/firewall.rules" >> /etc/network/interfaces
echo "Done - restart networking or reboot to re-read configuration."
