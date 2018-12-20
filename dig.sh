#!/usr/bin/env bash

# This script will dig for a specified IP, from a specified nameserver, or
# 1.1.1.1 if left blank

echo -ne "\nWhat's the domain? "

read domain

echo -e "\nWhat NS to use for dig? [1/2]: \n \
1) Public (1.1.1.1) \n \
2) Local "

read nameserver


exit 0
