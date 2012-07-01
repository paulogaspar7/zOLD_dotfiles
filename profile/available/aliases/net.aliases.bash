#!/usr/bin/env bash

cite about-alias
about-alias 'Networking related aliases'


# IP addresses
# alias ipout="dig +short myip.opendns.com @resolver1.opendns.com"
alias ip0en0="ipconfig getifaddr en0"
alias ip1en1="ipconfig getifaddr en1"
alias ips2="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"


# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"


# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""


# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

