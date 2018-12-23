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

        echo -e "\nDomain is: $domain\n"
        echo -e "Authoritative NS are: \n$($digg NS $domain)\n"
        echo -e "A record is: \n$($digg A $domain)\n"
        echo -e "MX records are: \n$($digg MX $domain)\n"
	echo -e "TXT records are: \n$($digg TXT $domain)\n"
	echo -e "DKIM record is: \n$($digg TXT \
		'default._domainkey.'$domain)\n"
	echo -e "PTR record (rDNS) is: \n$($digg -x $a_rec)\n"
}

# dig from an authoritative NS
# will do a whois to get the NS

local_dig() {
	ns=$(whois $domain | grep -i 'name server' | head -1 | cut -d: -f2 | \
		cut -d' ' -f2)
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
	echo -e "PTR record (rDNS) is: \n$(dig -x $a_rec @1.1.1.1 +short)\n"
}


### End Function definitions ###




# Prompt for domain and NS to use

echo -ne "\nWhat's the domain? "

read domain

echo -e "\nWhat NS to use for dig? [1/2/3]: \n \
1) Public (1.1.1.1) \n \
2) Local (Authorative) \n \
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
