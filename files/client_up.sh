#!/bin/sh
# A modified script adapt for minivtun
# 
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2015 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

# This script will be executed when client is up.
# All key value pairs in ShadowVPN config file will be passed to this script
# as environment variables, except password.

PID=$(cat $pidfile 2>/dev/null)
loger() {
	echo "$(date '+%c') up.$1 minivtun[$PID] $2"
}


# Get original gateway
gateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')
loger info "The default gateway: via $gateway"

# Get uci setting
route_mode=$(uci get minivtun.@minivtun[-1].route_mode 2>/dev/null)
route_file=$(uci get minivtun.@minivtun[-1].route_file 2>/dev/null)

# Save uci setting
uci set minivtun.@minivtun[-1].route_mode_save=$route_mode
uci commit minivtun

# mode 3 is "no change for route"
if [ "$route_mode" != 3 ]; then
	# Turn on NAT over VPN
	iptables -t nat -A POSTROUTING -o $intf -j MASQUERADE
	iptables -I FORWARD 1 -i $intf -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
	iptables -I FORWARD 1 -o $intf -j ACCEPT
	loger notice "Turn on NAT over $intf"

	# Change routing table
	suf="dev $intf"
	ip route add $server via $gateway
	if [ "$route_mode" != 2 ]; then
		ip route add 0.0.0.0/1 dev $intf
		ip route add 128.0.0.0/1 dev $intf
		loger notice "Default route changed to VPN tun"
		suf="via $gateway"
	fi

	# Load route rules
	if [ "$route_mode" != 0 -a -f "$route_file" ]; then
		grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $route_file >/tmp/minivtun_routes
		sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/minivtun_routes | ip -batch -
		loger notice "Route rules have been loaded"
	fi
fi

loger info "Script $0 completed"
