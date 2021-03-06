#!/bin/bash
# display current tcp/udp sockets state
# https://bbs.archlinux.org/viewtopic.php?pid=1505825#p1505825

set -e

ss -s

netstat -aptueW --numeric-host --numeric-ports 2>/dev/null |
awk '
NR > 2 {
    format = "%-8s %-15s %-25s %-25s %-10s %-22s\n"

    gsub("0\\.0\\.0\\.0", "*")
    gsub("127\\.0\\.0\\.1", "local")

    if ($1 ~ "^udp") {
        printf(format, $1, "-", $4, $5, $6, $8)
    }
    else if ($1 ~ "^tcp" ) {
        if ($6 == "LISTEN") $6 = "." $6
        else if ($6 == "ESTABLISHED") $6 = ":" $6

        printf(format, $1, $6, $4, $5, $7, $9)
    }
}
' | sort -b -k1,1r -k2,2 -k3,3