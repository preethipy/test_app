#!/bin/bash

set -eu

if [[ -d ~/config ]]
then
	if [[ -d ~/config/ip_vol ]]
	then
		echo "ip_vol exists"
	else
		mkdir ~/config/ip_vol
	fi
	if [[ -d ~/config/defect_dojo ]]
	then
		echo "defect_dojo exits"
	else
		mkdir ~/config/defect_dojo
	fi
else
	mkdir -p ~/config/ip_vol &&
	mkdir ~/config/defect_dojo
fi

# Has to be altered if the various pipelines will have various configurations
if [[ ! -e ~/config/Config.yaml ]]
then
	touch ~/config/Config.yaml
else
	echo "Pipeline Config exists"
fi
if [[ ! -e ~/config/defect_dojo/dd_conf.yaml ]]
then
	touch ~/config/defect_dojo/dd_conf.yaml
else
	echo "defect-dojo config exists"
fi

# $kubeconfig is env variable passed from git secrets
if [[ -d ~/kubeconfig ]]
then
	if [[ -e ~/kubeconfig/config ]]
	then
		echo "file exists"
	else
		touch ~/kubeconfig/config
	fi
else
	mkdir ~/kubeconfig &&
	touch ~/kubeconfig/config
fi

gpg --quiet --batch --yes --decrypt --passphrase="$EXKEY" --output ~/trigger/secrets ~/trigger/secrets.gpg &&

tar -xf ~/trigger/secrets -C ~/trigger/ &&

mv ~/trigger/config ~/kubeconfig/ &&
mv ~/trigger/Config.yaml ~/config/ &&
mv ~/trigger/dd_conf.yaml ~/config/defect_dojo/
