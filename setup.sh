#!/bin/bash

home_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ $(whoami) != 'root' ]; then
	echo "must be run as root to install to /usr/local/bin"
fi

if [ -w '/usr/local/bin' ]; then
	cp -frv "$home_dir"/usr/local/bin/* /usr/local/bin/
else
	echo 'unable to copy files to /usr/local/bin'
fi

echo "Done."
