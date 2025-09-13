#!/usr/bin/env bash

# Starts an SSH tunnel to a jump host using a PEM file for authentication. The tunnel is
# started in the background and can be stopped using the `tunnel.sh stop` command. The status
# of the tunnel can be checked using the `tunnel.sh status` command.
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
#   tunnel.sh forwards
#
# Example:
#   tunnel.sh start
#   tunnel.sh start redshift
#
# This will start SSH tunnels for the services defined in tunnel.conf.

# Colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

# Formatting
bold=$(tput bold)
underline=$(tput smul)
dim=$(tput dim)

# Load configuration from external file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/tunnel.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "${red}${bold}Configuration file not found: $CONFIG_FILE ${reset}"
    exit 1
fi

# Source the configuration file
source "$CONFIG_FILE"

# Runtime SSH options from configuration
destination="$DESTINATION"
identity_file=$IDENTITY_FILE
control_socket=$CONTROL_SOCKET

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

# Help message
function help() {
    echo "Usage: $(basename $0) <command> [options]"
    echo
    echo "Available commands:"
    echo "  start    - Starts a new SSH tunnel and forwards all declared services."
    echo "  stop     - Stops the SSH tunnel."
    echo "  status   - Checks the status of the SSH tunnel."
    echo "  forwards - List local port forwards for this tunnel."
    echo "  help     - Show this help message"
    echo
    echo "Options:"
    echo "    Use 'start [service_name]' to start a tunnel for a specific service."
    echo
    echo "Configuration:"
    echo "    Edit $CONFIG_FILE to modify SSH settings and services."
}

# List all available local port forwards
#
# Accepts no arguments.
#
function list_forwards()
{
    echo
    echo "${bold}Local Port Forwards:${reset}"
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
        echo "${yellow}Tunnel is already running${reset}"
        exit
    fi

    echo
    echo "📡 ${bold}Starting SSH tunnel...${reset}"

    # Build the SSH command
    ssh_cmd=(ssh -M -S $control_socket -i $identity_file -fNT -o ExitOnForwardFailure=yes -o ServerAliveInterval=10 -o ServerAliveCountMax=3)

    # Append a port forwarding option for each service in the array, or
    # if a service is specified, only append the port forwarding option for that service.
    echo "Local Port Forwards:"

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
    if [ $? -ne 0 ]; then
        echo
        echo "🚫 ${red}${bold}Failed to start tunnel${reset}"
        exit 1
    fi

    echo
    echo "✅ ${green}Tunnel started successfully!${reset}"
}

# Stop the tunnel if running
#
# Accepts no arguments.
#
function stop_tunnel()
{
    if [ ! -S "$control_socket" ]; then
        echo "${red}${bold}Error: Tunnel is not running (no socket)${reset}"
        exit 1
    fi

    echo
    echo "✋ ${bold}Stopping SSH tunnel...${reset}"

    ssh -S $control_socket -O "exit" $destination

    if [ $? -ne 0 ]; then
        echo
        echo "🚫 ${red}${bold}Tunnel failed to stop${reset}"
        exit 1
    fi

    echo
    echo "✅ ${green}Stopped!${reset}"
}

# Check if the tunnel is running.
#
# Accepts no arguments.
#
function check_tunnel()
{
    if [ ! -S "$control_socket" ]; then
        echo "${red}${bold}Error: Tunnel is not running (no socket)${reset}"
        exit 1
    fi

    echo
    echo "🔍 ${bold}Checking status of SSH tunnel...${reset}"

    ssh -S $control_socket -O "check" $destination

    if [ $? -ne 0 ]; then
        echo
        echo "🚫 ${red}${bold}Tunnel is not running${reset}"
        exit 1
    fi

    echo
    echo "✅ ${green}Ok!${reset}"
}

# Main script execution
main()
{
    # Run the command
    case "$1" in
        "start")
            start_tunnel "${@:2}"
            ;;
        "stop")
            stop_tunnel
            ;;
        "forwards")
            list_forwards
            ;;
        "status")
            check_tunnel
            ;;
        "help"|"-h")
            help
            exit
            ;;
        *)
            echo "${red}${bold}Error: Unknown command '$1'${reset}"
            help
            exit 1
            ;;
    esac
}

# Error handling
trap '"Script interrupted!"; exit 130' INT
trap '"Script failed on line $LINENO"; exit 1' ERR

# Run the main function
main "$@"
