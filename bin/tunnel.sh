#!/usr/bin/env bash

# Starts an SSH tunnel to a jump host, to allow access to AWS Redshift and DocDB databases
# using a PEM file for authentication. The tunnel is started in the background and can be
# stopped using the `tunnel.sh stop` command. The status of the tunnel can be checked using
# the `tunnel.sh status` command.
#
# Configuration is loaded from tunnel.conf in the same directory as this script.
#
# The configuration file should define the following variables:
#   DESTINATION - The SSH destination (e.g., ec2-user@
#   IDENTITY_FILE - The path to the SSH private key file (PEM file)
#   CONTROL_SOCKET - The path to the SSH control socket file
#   SERVICE_<name> - The local port, remote host, and remote port for each service to tunnel
#
# Usage:
#   tunnel.sh start [service_name]
#   tunnel.sh stop
#   tunnel.sh status
#   tunnel.sh list
#
# Example:
#   tunnel.sh start
#   tunnel.sh start redshift
#
# This will start SSH tunnels for the services defined in tunnel.conf.

# highlighting colours
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

# Load configuration from external file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/tunnel.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    printf "$red\n" "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Source the configuration file
source "$CONFIG_FILE"

# Runtime SSH options from configuration
destination="$DESTINATION"
identity_file=$IDENTITY_FILE
control_socket=$CONTROL_SOCKET #"${CONTROL_SOCKET/#\~/$HOME}"

# Build services array from configuration
declare -A services=()
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ $line =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue

    # Match SERVICE_* variables
    if [[ $line =~ ^SERVICE_([A-Z_]+)=\"(.*)\"$ ]]; then
        service_name="${BASH_REMATCH[1],,}"  # Convert to lowercase
        service_config="${BASH_REMATCH[2]}"
        services["$service_name"]="$service_config"
    fi
done < "$CONFIG_FILE"

# Show help message
#
# Accepts no arguments.
#
function help() {
    echo "Usage: $(basename $0) <command> [options]"
    echo ""
    echo "Available commands:"
    echo "  start   - Starts a new SSH tunnel and forwards all declared services."
    echo "  stop    - Stops the SSH tunnel."
    echo "  status  - Checks the status of the SSH tunnel."
    echo "  list    - List all available service aliases."
    echo "  help    - Show this help message"
    echo ""
    echo "Options:"
    echo "    Use 'start [service_name]' to start a tunnel for a specific service."
    echo ""
    echo "Configuration:"
    echo "    Edit $CONFIG_FILE to modify SSH settings and services."
}

# List all available service aliases
#
# Accepts no arguments.
#
function list_services()
{
    echo
    echo "Available services:"
    for key in "${!services[@]}"; do
        echo " • $key → ${services[$key]}"
    done
}

# Start the AWS dev tunnel
#
# @param $1 service - the service to tunnel to. If not provided, all services will be tunneled.
#
function start_tunnel()
{
    local service="$1"

    # Check if the tunnel is already running
    if [ -S "$control_socket" ]; then
        printf "\n$yellow\n" "The tunnel is already running!"
        exit 0
    fi

    echo
    echo "Starting SSH tunnel... "

    # Build the SSH command
    ssh_cmd=(ssh -M -S $control_socket -i $identity_file -fNT -o ExitOnForwardFailure=yes -o ServerAliveInterval=10 -o ServerAliveCountMax=3)

    # Append a port forwarding option for each service in the array, or
    # if a service is specified, only append the port forwarding option for that service.
    if [ -z "$service" ]; then
        for key in "${!services[@]}"; do
            echo " • $key → ${services[$key]}"
            ssh_cmd+=(-L ${services[$key]})
        done

    elif [[ -v services[$service] ]]; then
        echo " • $service → ${services[$service]}"
        ssh_cmd+=(-L ${services[$service]})
    fi

    ssh_cmd+=($destination)

    # Start the tunnel
    `${ssh_cmd[@]}`

    # Check if the tunnel started successfully
    if [ $? -eq 0 ]; then
        printf "$green\n" "Tunnel started successfully ✓"
    else
        printf "$red\n" "Failed to start tunnel ✗"
        exit 1
    fi
}

# Stop the tunnel if running
#
# Accepts no arguments.
#
function stop_tunnel()
{
    if [ ! -S "$control_socket" ]; then
        printf "\n$yellow\n" "The tunnel is not running (no socket)"
        exit 1
    fi

    echo
    echo "Stopping SSH tunnel..."

    ssh -S $control_socket -O "exit" $destination

    if [ $? -eq 0 ]; then
        printf "$green\n" "Stopped ✓"
    else
        printf "$red\n" "Tunnel failed to stop ✗"
        exit 1
    fi
}

# Check if the tunnel is running.
#
# Accepts no arguments.
#
function check_tunnel()
{
    if [ ! -S "$control_socket" ]; then
        printf "\n$yellow\n" "The tunnel is not running (no socket)"
        exit 1
    fi

    echo
    echo "Checking status of SSH tunnel... "

    ssh -S $control_socket -O "check" $destination

    if [ $? -eq 0 ]; then
        printf "$green\n" "Ok ✓"
    else
        printf "$red\n" "Tunnel is not running ✗"
        exit 1
    fi
}

# Run the command
case "$1" in
    "start")
        start_tunnel "${@:2}"
        ;;
    "stop")
        stop_tunnel
        ;;
    "list")
        list_services
        ;;
    "status")
        check_tunnel
        ;;
    "help"|"")
        help
        ;;
    *)
        echo "Error: Unknown command '$1'"
        help
        exit 1
        ;;
esac
