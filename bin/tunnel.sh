#!/usr/bin/env bash

# Starts an SSH tunnel to a jump host, to allow access to AWS Redshift and DocDB databases
# using a PEM file for authentication. The tunnel is started in the background and can be
# stopped using the `tunnel.sh stop` command. The status of the tunnel can be checked using
# the `tunnel.sh status` command.
#
# Usage:
#   tunnel.sh start [redshift|docdb]
#   tunnel.sh stop
#   tunnel.sh status
#
# Example:
#   tunnel.sh start
#
# This will start an SSH tunnel from local port 5439 to the remote Redshift cluster and DocDB instance
# on ports 5439 and 27017 respectively, using the specified PEM file for authentication.

# highlighting colours
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'


ssh -i "~/.ssh/aws-dev-jumpbox.pem" \
	-L 5439:development.cbpdnejrkweo.us-east-1.redshift.amazonaws.com:5439 \
	-L 27017:stlr-dev-docdb.cluster-cyxapbpvkba7.us-east-1.docdb.amazonaws.com:27017 \
	ec2-user@52.22.138.17 -N
