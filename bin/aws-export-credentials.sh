#!/usr/bin/env bash
#
# When using AWS Single Sign-On (SSO) with the AWS CLI, the shared credentials file is not
# automatically generated. This script attempts to login using the configured SSO session
# profile and export the temporary credentials to the ~/.aws/credentials shared file.
#
# Usage:
#   aws-export-credentials.sh -p <profile> -c <credentials_profile>
#
# Examples:
#   aws-export-credentials.sh -p dev -c default
#   aws-export-credentials.sh --profile=dev --credentials-file-profile=default --no-login
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

help()
{
    echo "Exports authenticated AWS SSO login credentials to the shared ~/.aws/credentials file."
    echo
    echo "Syntax: $(basename $0) -p <profile> -c <credentials-profile>"
    echo "Options:"
    echo "  -h                              Show help"
    echo "  -p --profile                    SSO Profile name (Optional, uses default profile if not set)"
    echo "  -c --credentials-file-profile   Shared credentials profile name (Optional, uses default profile if not set)"
    echo "  -n --no-login                   No-login, skip SSO authentication and export existing tokens (Optional)"
    echo
    echo "Examples: "
    echo "  ./$(basename $0) -p dev"
    echo "  ./$(basename $0) -p dev -c default"
	echo "  ./$(basename $0) -profile=dev -credentials-file-profile=default --no-login"
}

while getopts hnp:c:-: OPTION; do    	# -h, -n, -p with arg, -c with arg, and "--" with arg

	# support long options
	# https://stackoverflow.com/a/28466267/519360

	if [ "$OPTION" = "-" ]; then
		OPTION="${OPTARG%%=*}"			# extract long option name
		OPTARG="${OPTARG#"$OPTION"}"	# extract long option argument (may be empty)
		OPTARG="${OPTARG#=}"			# if long option argument, remove assigning `=`
	fi

    case "$OPTION" in
		n | no-login					) no_login=true						;;
        p | profile						) sso_profile="${OPTARG}"			;;
		c | credentials-file-profile	) credentials_profile="${OPTARG}" 	;;

		h ) help
			exit;;
        \?) echo "Error: Invalid option, -h to show help."
			exit 2;;
		* ) echo "Error: Invalid option --$OPTION, -h to show help."
			exit 2;;
    esac
done

shift $((OPTIND-1)) # remove parsed options and args from $@ list

main()
{
	# login with the sso profile
	if [ "$no_login" != true ]; then

		echo "Initiating SSO login... "
		aws sso login --profile "$sso_profile"

		if [ $? -ne 0 ]; then
			printf "$red\n" "SSO Login failed ✗"
			exit 1;
		fi

		printf "$green\n" "Ok ✓"
	fi

	# export credentials as local envars
	# - AWS_ACCESS_KEY_ID
	# - AWS_SECRET_ACCESS_KEY
	# - AWS_SESSION_TOKEN
	echo "Exporting ${sso_profile} credentials... "
	eval "$(aws configure export-credentials --profile "$sso_profile" --format env-no-export)"

	# update the ~/.aws/credentials file
	aws configure set --profile "$credentials_profile" aws_access_key_id "$AWS_ACCESS_KEY_ID"
	aws configure set --profile "$credentials_profile" aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
	aws configure set --profile "$credentials_profile" aws_session_token "$AWS_SESSION_TOKEN"

	printf "$green\n" "Successfully exported to ${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials} as ${credentials_profile} ✓"
}

main;
