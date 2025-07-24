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
#   aws-export-credentials.sh -p <profile> -c <credentials_profile>
#
# Examples:
#   aws-export-credentials.sh -p dev -c default
#   aws-export-credentials.sh --profile=dev --credentials-file-profile=default --no-login
#   aws-export-credentials.sh --credentials-file-profile=default --clear
#
# @author Brian Cowdery
# @since 5-May-2025

# colors
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

# variables
sso_profile='default'
credentials_profile='default'
no_login=false
delete=false

help()
{
    echo "Exports authenticated AWS SSO login credentials to the shared ~/.aws/credentials file."
    echo
    echo "Syntax: $(basename $0) -p <profile> -c <credentials-profile>"
    echo "Options:"
    echo "  -h                              Show help"
    echo "  -s --sso-configure              Launch the SSO configuration wizard"
    echo "  -p --profile                    SSO Profile name (Optional, uses default profile if not set)"
    echo "  -c --credentials-file-profile   Shared credentials profile name (Optional, uses default profile if not set)"
    echo "  -n --no-login --no-logout       No-login, skip SSO login and logout when exporting or deleting credentials"
    echo "  -d --delete                     Delete shared credentials profile entry"
    echo
    echo "Examples: "
    echo "  ./$(basename $0) -p dev"
    echo "  ./$(basename $0) -p dev -c default"
    echo "  ./$(basename $0) -profile=dev -credentials-file-profile=default --no-login"
    echo "  ./$(basename $0) --credentials-file-profile=default --delete"
}

while getopts hndp:c:-: OPTION; do

    # support long options
    # https://stackoverflow.com/a/28466267/519360

    if [ "$OPTION" = "-" ]; then
        OPTION="${OPTARG%%=*}"			# extract long option name
        OPTARG="${OPTARG#"$OPTION"}"	# extract long option argument (may be empty)
        OPTARG="${OPTARG#=}"			# if long option argument, remove assigning `=`
    fi

    case "$OPTION" in
        n | no-login | no-logout		) no_login=true						;;
        p | profile						) sso_profile="${OPTARG}"			;;
        c | credentials-file-profile	) credentials_profile="${OPTARG}" 	;;
        d | delete						) delete=true						;;

        h ) help
            exit;;
        \?) echo "Error: Invalid option, -h to show help."
            exit 2;;
        * ) echo "Error: Invalid option --$OPTION, -h to show help."
            exit 2;;
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
    echo "Initiating SSO login... "

    aws sso login --profile "$sso_profile"

    if [ $? -ne 0 ]; then
        printf "$red\n" "Login failed ✗"
        exit 1;
    fi

    printf "$green\n" "Login Ok ✓"
}

# Logout from the SSO session
#
# Accepts no arguments
#
sso_logout()
{
    echo
    echo "SSO logout... "

    aws sso logout --profile "$sso_profile"

    if [ $? -ne 0 ]; then
        printf "$red\n" "Logout failed ✗"
        exit 1;
    fi

    printf "$green\n" "Bye 👋"
}

# Export SSO credentials to the shared credentials file
#
# Accepts no arguments.
#
export_credentials()
{
    echo
    echo "Exporting ${sso_profile} credentials... "

    # export credentials as local variables:
    # - AWS_ACCESS_KEY_ID
    # - AWS_SECRET_ACCESS_KEY
    # - AWS_SESSION_TOKEN
    eval "$(aws configure export-credentials --profile "$sso_profile" --format env-no-export)"

    # update the ~/.aws/credentials file
    aws configure set --profile "$credentials_profile" aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set --profile "$credentials_profile" aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set --profile "$credentials_profile" aws_session_token "$AWS_SESSION_TOKEN"

    printf "$green\n" "Successfully exported to ${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials} as ${credentials_profile} ✓"
}

# Clear access keys from the shared credentials file
#
# Accepts no arguments.
#
delete_credentials()
{
    echo
    echo "Clearing credentials... "

    # clear the ~/.aws/credentials file
    aws configure set --profile "$credentials_profile" aws_access_key_id ''
    aws configure set --profile "$credentials_profile" aws_secret_access_key ''
    aws configure set --profile "$credentials_profile" aws_session_token ''

    printf "$green\n" "Successfully deleted ${credentials_profile} from ${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials} ✓"
}

main()
{
    # safety dance
    if [ -z "$sso_profile" ]; then
        echo "Error: SSO profile is not set. Use -p or --profile to specify the SSO profile."
        exit 1;
    fi

    if [ -z "$credentials_profile" ]; then
        echo "Error: Credentials profile is not set. Use -c or --credentials-file-profile to specify the credentials profile."
        exit 1;
    fi

    # Clear credentials from the shared file
    # If no-login is set, skip the SSO logout step
    if [ "$delete" == true ]; then
        if [ "$no_login" == false ]; then
            sso_logout
        fi

        delete_credentials
    fi

    # Export credentials to the shared file
    # If no-login is set, skip the SSO login step
    if [ "$delete" == false ]; then
        if [ "$no_login" == false ]; then
            sso_login
        fi

        export_credentials
    fi
}

main;
