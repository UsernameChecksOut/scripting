#!/usr/bin/env bash

#  This script will dig for the most common records (A, NS, MX, TXT, DKIM, PTR),
#  for a specified domain, from either a public NS (1) or an authorative one (2)

echo -ne "\nWhat's the domain? "

read domain

echo -e "\nWhat NS to use for dig? [1/2]: \n \
1) Public (1.1.1.1) \n \
2) Local (Authorative) "

read -s -n 1 nameserver

public_dig() {
	if [[ "$nameserver" -eq "1" ]]; then
		dig="dig +short @1.1.1.1"
		
		echo -e "\nDomain is: $domain\n"
		echo -e "Authoritative NS are: \n$($dig NS $domain)\n"
		echo -e "A record is: \n$($dig A $domain)\n"
		echo -e "MX records are: \n$($dig MX $domain)\n"
		echo -e "TXT records are: \n$($dig TXT $domain)\n"
		echo -e "DKIM record is: \n$($dig TXT \
			'default._domainkey.'$domain)\n"
	fi
}

public_dig



#while read -s -n 1 nameserver; do
#    if [[ "$nameserver" -ne "1" && "$nameserver" -ne "2" ]]; then
#        echo -e "\nPlease select either 1 or 2\n"
#    elif [[ "$nameserver" -eq "1" ]]; then
#        dig +short @1.1.1.1 "$domain" A "$domain" NS "$domain" TXT \
#	"default._domainkey.""$domain" TXT
#	break
#    fi
#done



exit 0
