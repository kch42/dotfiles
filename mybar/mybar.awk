#!/bin/awk -f

BEGIN {
	date=""
	cpu=""
	mem=""
	battery=""
	window=""
	wminfo=""
	redshift=""
	wifi=""
	
	cpu_pused=0
	cpu_ptotal=0
}
$1 == "date" {
	date = $2 " " $3 " " $4
}
$1 == "cpu" {
	used=$2+$3+$4+$7+$8;
	total=used+$5+$6;
	
	if(total - cpu_ptotal != 0) {
		tmp=int(100*(used-cpu_pused)/(total-cpu_ptotal));
	} else {
		tmp=0
	}
	if(tmp > 100) {
		tmp=0
	}
	cpu_pused=used
	cpu_ptotal=total
	
	if(tmp < 10) {
		sp = "  "
	} else if(tmp < 100) {
		sp = " "
	} else {
		sp = ""
	}
	f = int((tmp+5) / 10)
	tmp = "CPU:  " sp tmp "%"
	cpu = "\\u3" substr(tmp, 1, f) "\\u4" substr(tmp, 1+f, 10-f) "\\ur"
}
$1 == "window" {
	window=substr($0, 7, length($0)-6);
}
$1 == "mem" {
	if($2 < 10) {
		sp = "   "
	} else if($2 < 100) {
		sp = "  "
	} else if($2 < 1000){
		sp = " "
	} else {
		sp = ""
	}
	tmp = "Mem:" sp $2 "MB"
	f = int(($2 / 4096 * 10) + .5)
	mem = "\\u3" substr(tmp, 1, f) "\\u4" substr(tmp, 1+f, 10-f) "\\ur"
}
$1 == "bspwm" {
	#wminfo=substr($0, 7, length($0)-6)
	split(substr($0, 7, length($0)-6), info, ":")
	
	wminfo=" \\u5"
	sep=""
	for(i in info) {
		raw=info[i]
		k=substr(raw, 1, 1)
		v=substr(raw, 2, length(raw)-1)
		
		add = ""
		if(k=="u") add = "\\b2" v
		else if(k=="U") add = "\\u3\\b2" v
		else if(k=="f") add = "\\f1" v
		else if(k=="F") add = "\\f1\\u3" v
		else if(k=="o") add = v
		else if(k=="O") add = "\\u3" v
		
		if(add != "") {
			wminfo = wminfo sep add "\\fr\\u5\\br"
			sep = " "
		}
	}
	wminfo = wminfo "\\ur"
}
$1 == "redshift" {
	if($2 == "-x") {
		redshift = "\\u2"
	} else {
		redshift = ""
	}
}
$1 == "bat" {
	val=$3
	if($2 == "Full") {
		val=100
	}
	if($2 == "Charging") {
		tmp="-charging-"
	} else {
		tmp="Bat:"
		
		if(val < 10) {
			sp="    "
		} else if(val < 100) {
			sp="   "
		} else {
			sp="  "
		}
		tmp=tmp sp val "%"
	}
	f = int((val+5) / 10)
	battery = "\\u3" substr(tmp, 1, f) "\\u4" substr(tmp, 1+f, 10-f) "\\ur"
	if((val < 5) && ($2 != "Charging")) {
		battery="\\b2" battery "\\br"
	}
}
$1 == "wifi" {
	if($2 == "-") {
		wifi=""
	} else {
		tmp=$2
		if(length(tmp) > 10) {
			tmp=substr(tmp, 1, 8) ".."
		}
		
		while(length(tmp) < 10) {
			tmp=tmp " "
		}
		
		f = int(($3+5) / 10)
		wifi = "\\u3" substr(tmp, 1, f) "\\u4" substr(tmp, 1+f, 10-f) "\\ur"
	}
}
{
	print "\\l" wminfo "\\c" window "\\r" wifi "  " battery "  " mem "  " cpu "  " redshift "R\\ur  " date " "
	fflush()
}
