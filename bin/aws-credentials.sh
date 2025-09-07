#!/usr/bin/env bash
#
# When using AWS Single Sign-On (SSO) with the AWS CLI, the shared credentials file is not automatically generated.
# This script attempts to login using the configured SSO session profile and export the temporary credentials to
# the ~/.aws/credentials shared file.
#
# Setup your AWS SSO profile using the AWS CLI:
#   aws configure sso
#
# Your SSO profile will be stored in the ~/.aws/config file, it should look like this:
#   [profile dev]
#   sso_start_url = https://my-sso-portal.awsapps.com/start
#   sso_region = us-west-2
#   sso_account_id = 123456789012
#   sso_role_name = MySSORole
#
# Usage:
#   aws-credentials.sh <command> [options]
#
# Examples:
#   aws-credentials.sh export -p dev -c default --sso-login
#   aws-credentials.sh export --profile=dev --credentials-file-profile=default --sso-login
#   aws-credentials.sh clear --credentials-file-profile=default --sso-logout
#
# @author Brian Cowdery
# @since 5-May-2025

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

# Help message
help()
{
    echo "Exports authenticated AWS SSO login credentials to the shared ~/.aws/credentials file."
    echo "Setup your AWS SSO profile using the AWS CLI: aws configure sso"
    echo
    echo "Syntax: $(basename $0) <command> [options]"
    echo
    echo "Available commands:"
    echo "  export                          Export SSO credentials"
    echo "  clear                           Clear exported SSO credentials"
    echo
    echo "Options:"
    echo "  -h                              Show help"
    echo "  -p --profile                    SSO Profile name (Optional, uses default profile if not set)"
    echo "  -c --credentials-file-profile   Shared credentials file profile name (Optional, uses default profile if not set)"
    echo "  --sso-login                     Do an SSO login"
    echo "  --sso-logout                    Do an SSO logout"
    echo
    echo "Examples: "
    echo "  $(basename $0) export -p dev"
    echo "  $(basename $0) export -p dev -c default --sso-login"
    echo "  $(basename $0) export --profile=dev --credentials-file-profile=default --no-login"
    echo "  $(basename $0) clear --credentials-file-profile=default"
}

# Command to execute
command=""

# Command line options
sso_profile='default'
credentials_profile='default'
login=false
logout=false

# Check if first argument is a command
case "$1" in
    export|clear)
        command="$1"
        shift
        ;;
    help|-h)
        help
        exit
        ;;
    *)
        echo "${red}${bold}Error: Unknown command '$1', -h to show help.${reset}"
        exit 2
        ;;
esac

# Parse command line options
while getopts hndp:c:-: OPTION; do

    # support long options
    # https://stackoverflow.com/a/28466267/519360

    if [ "$OPTION" = "-" ]; then
        OPTION="${OPTARG%%=*}"			# extract long option name
        OPTARG="${OPTARG#"$OPTION"}"	# extract long option argument (may be empty)
        OPTARG="${OPTARG#=}"			# if long option argument, remove assigning `=`
    fi

    case "$OPTION" in
        p | profile						) sso_profile="${OPTARG}"			;;
        c | credentials-file-profile	) credentials_profile="${OPTARG}" 	;;
        sso-login                       ) login=true                        ;;
        sso-logout                      ) logout=true                       ;;

        h ) help
            exit
            ;;
        * ) echo "${red}${bold}Error: Invalid option --$OPTION, -h to show help.${reset}"
            exit 2
            ;;
    esac
done

shift $((OPTIND-1)) # remove parsed options and args from $@ list


# Login using the SSO profile configured in the ~/.aws/config file
#
# Accepts no arguments
#
sso_login()
{
    echo
    echo "🔑 ${bold}Initiating SSO login...${reset}"

    aws sso login --profile "$sso_profile"

    if [ $? -ne 0 ]; then
        echo
        echo "⚠️ ${red}Login failed ✗${reset}"
        exit 1;
    fi

    echo
    echo "✅ ${green}Login Ok!${reset}"
}

# Logout from the SSO session
#
# Accepts no arguments
#
sso_logout()
{
    echo
    echo "🔑 ${bold}SSO logout... "

    aws sso logout --profile "$sso_profile"

    if [ $? -ne 0 ]; then
        echo
        echo "⚠️ ${red}Logout failed ✗${reset}"
        exit 1;
    fi

    echo
    echo "👋 ${green}Bye bye.${reset}"
}

# Export SSO credentials to the shared credentials file
#
# Accepts no arguments.
#
export_credentials()
{
    echo
    echo "💼 ${bold}Exporting ${sso_profile} credentials...${reset}"

    # export credentials as local variables:
    # - AWS_ACCESS_KEY_ID
    # - AWS_SECRET_ACCESS_KEY
    # - AWS_SESSION_TOKEN
    eval "$(aws configure export-credentials --profile "$sso_profile" --format env-no-export)"

    # update the ~/.aws/credentials file
    aws configure set --profile "$credentials_profile" aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set --profile "$credentials_profile" aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set --profile "$credentials_profile" aws_session_token "$AWS_SESSION_TOKEN"

    echo
    echo "✅ ${green}Successfully exported to ${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials} as [${credentials_profile}]${reset}"
}

# Clear access keys from the shared credentials file
#
# Accepts no arguments.
#
clear_credentials()
{
    echo
    echo "🧹 ${bold}Clearing credentials...${reset}"

    # clear the ~/.aws/credentials file
    aws configure set --profile "$credentials_profile" aws_access_key_id ''
    aws configure set --profile "$credentials_profile" aws_secret_access_key ''
    aws configure set --profile "$credentials_profile" aws_session_token ''

    echo
    echo "✅ ${green}Successfully removed [${credentials_profile}] from ${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials}${reset}"
}

# Main script execution
main()
{
    # Optional login
    if [ "$login" == true ]; then
        sso_login
    fi

    # Run the command
    case "$command" in
        "export")
            export_credentials
            ;;
        "clear")
            clear_credentials
            ;;
    esac

    # Optional logout
    if [ "$logout" == true ]; then
        sso_logout
    fi
}

# Error handling
trap '"Script interrupted!"; exit 130' INT
trap '"Script failed on line $LINENO"; exit 1' ERR

# Run the main function
main "$@"
