#!/bin/awk -f

BEGIN {
	FS=":"
	essid="-"
	qual="0"
}
$1 == "Essid" {
	split($2, parts, " ")
	sep=""
	essid = ""
	for(i in parts) {
		essid = sep parts[i]
		sep="_"
	}
}
$1 == "Quality" {
	qual = $2
}
END {
	print "wifi " essid " " qual
}
