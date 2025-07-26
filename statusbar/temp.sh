#!/usr/bin/sh
# sensors | grep -A1 'Adapter: PCI adapter' | tail -n1 | awk '{print $2}' | sed s/+//g
cpu=$(sensors | grep -A2 'coretemp-isa-0000' | tail -n1 | awk '{print $4}' | sed s/+//g | sed s/°C//g)
ssd=$(sensors | grep -A1 'Adapter: PCI adapter' | tail -n1 | awk '{print $2}' | sed s/+//g | sed s/°C//g)
utp=$(sensors | grep -A3 'r8169_0_100:00-mdio-0' | tail -n2 | awk '{print $2}' | sed s/+//g | sed s/°C//g)
echo "󰍛 $cpu󰔄, 󰋊 $ssd󰔄, 󰛳 $utp󰔄"
# echo "$utp"
