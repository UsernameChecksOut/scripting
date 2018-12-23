#!/usr/bin/env bash
#
# Author: UsernameChecksOut
#
# Creation date: 12/23/2018
#
# Purpose: This script will dig for the most common records (A, NS, MX, TXT, 
# DKIM, PTR), for a specified domain, from either a public NS (1)
# or an authorative one (2)
#


### Function defininitons below ###

# dig from a public NS
public_dig() {
        digg="dig +short @1.1.1.1"
	a_rec=$($digg A $domain)

	echo -e "Getting DNS records from a public resolver (1.1.1.1):\n"
        echo -e "\nDomain is: $domain\n"
        echo -e "Authoritative NS are: \n$($digg NS $domain)\n"
        echo -e "A record is: \n$($digg A $domain)\n"
        echo -e "MX records are: \n$($digg MX $domain)\n"
	echo -e "TXT records are: \n$($digg TXT $domain)\n"
	echo -e "DKIM record is: \n$($digg TXT \
		'default._domainkey.'$domain)\n"
	echo -e "PTR record (rDNS) is: \n$($digg -x $a_rec 2>/dev/null)\n"
}

# dig from an authoritative NS
local_dig() {
	ns=$(whois $domain 2>/dev/null | grep -i 'name server' | head -1 | cut -d: -f2 | \
		cut -d' ' -f2)
	
	# check if whois can get the NS (can't if unsupported TLD, for example)
	if [[ -z "$ns" ]]; then
		echo "Error: WHOIS for domain $domain failed - can't get" \
		"registered nameservers. Try to do a manual" \
		"whois to see what's the issue."
		
		exit 1
	fi
		
	digg="dig +short @$ns"
	a_rec=$($digg A $domain)

	echo "Using the following authoritative NS (provided by whois): $ns"
        echo -e "\nDomain is: $domain\n"
        echo -e "Authoritative NS are: \n$($digg NS $domain)\n"
        echo -e "A record is: \n$($digg A $domain)\n"
        echo -e "MX records are: \n$($digg MX $domain)\n"
        echo -e "TXT records are: \n$($digg TXT $domain)\n"
        echo -e "DKIM record is: \n$($digg TXT \
		'default._domainkey.'$domain)\n"
	echo -e "PTR record (rDNS) is: \n$(dig -x $a_rec @1.1.1.1 +short \
		2>/dev/null)\n"
}


### End Function definitions ###


### Start actual work ###


# Prompt for domain, check if it's empty

echo -ne "\nWhat's the domain? "

while read domain; do

	# check if domain is empty
	if [[ -z "$domain" ]]; then
		echo "Invalid domain. Try again"
		continue
	fi
	break
done


# Prompt for resolver

echo -e "\nWhat NS to use for dig? [1/2/3]:
1) Public (1.1.1.1)
2) Local (Authorative)
3) Exit \n"


# Call functions or exit

while : ; do
	read -s -n 1 nameserver
	case "$nameserver" in
		1)
			public_dig ; exit 0
			;;
		2)
			local_dig; exit 0
			;;
		3)
			echo "Exiting on user input"; exit 0
			;;
		*)
			echo "Invalid option. Please choose [1/2/3]."
			;;
	esac
done


exit 0
