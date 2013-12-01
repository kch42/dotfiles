#!/bin/sh

update_wminfo() {
	bspc control --subscribe | while read line; do
		echo "bspwm $line"
	done
}

update_time() {
	while true; do
		date '+date %a. %Y-%b-%d %H:%M'
		sleep 1
	done
}

update_mem() {
	while true; do
		awk '
$1 == "MemTotal:" { total=$2; }
$1 == "MemFree:" { free=$2; }
$1 == "Buffers:" { buf=$2; }
$1 == "Cached:" { cache=$2; }
END { print "mem " int((total - free - buf - cache) / 1024); }' < /proc/meminfo 
		sleep 2
	done
}

update_cpu() {
	while true; do
		grep '^cpu\s' < /proc/stat
		sleep 2
	done
}

update_bat() {
	while true; do
		battery -f "bat %s %d"
		sleep 2
	done
}

update_wifi() {
	while true; do
		wicd-cli -y -d | ~/mybar/wifi.awk
		sleep 2
	done
}

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

update_wminfo > "$BAR_FIFO" &
update_time > "$BAR_FIFO" &
update_mem > "$BAR_FIFO" &
update_cpu > "$BAR_FIFO" &

if test $(hostname) = "kch42-notebook"; then
	update_bat > "$BAR_FIFO" &
	update_wifi > "$BAR_FIFO" &
fi

xtitle -sf 'window %s' > "$BAR_FIFO" &

cat "$BAR_FIFO" | ~/mybar/mybar.awk | bar
