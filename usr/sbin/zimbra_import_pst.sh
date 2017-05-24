#!/bin/bash

inbox=$1
tdir=$2
email=$3

ls -1 "$tdir"/* | /usr/sbin/zimbra_import.pl "$inbox" "$email"

#IFS='\n'
#for file in $(ls -1 "$tdir"/*.eml); do
#  echo $file
#  #echo addMessage "$inbox" "'$file'" | /opt/zimbra/bin/zmmailbox -z -m "$email"
#done
