#!/bin/bash

# wikidig
# Script to fetch short summary about stuffs from Wikipedia.
#
# Last modified: 24 July 2014.
# By: Stijn Wouters.
VERSION="0.1.0"

BOLD=`tput bold`
END=`tput sgr0`

# usage information
read -d '' USAGE <<EOF
$0-${VERSION}

usage:
    $0 <keywords>

option
    -h --help       Show this help message.
    -v --version    Show version info.
EOF

# parse command line
while [[ -n "$1" ]];
do
    case "$1" in
        '-h' | '--help')
            printf "${USAGE}\n"
            shift
            ;;
        '-v' | '--version')
            printf "$0-${VERSION}\n"
            shift
            ;;
        -*)
            printf "Unknown option $1\n"
            exit 1
            ;;
        *)
            [[ -n "${KEYWORDS}" ]] && KEYWORDS="${KEYWORDS} $1" || KEYWORDS="$1"
            shift
            ;;
    esac
done

# exit earlier if no keywords provided
[[ -z "${KEYWORDS}" ]] && exit 1

WIKI=`dig +short txt "${KEYWORDS}".wp.dg.cx`

# remove quotes
WIKI=`echo "${WIKI}" | sed -e 's/^"//' -e 's/"$//'`

# get source url and remove from summary
SOURCE=`echo "${WIKI}" | grep -oe 'https\?://.*$' --color=never`
WIKI=`echo "${WIKI}" | sed -e 's/https\?:\/\/.*$//'`

cat <<EOF
${BOLD}Keywords:${END} ${KEYWORDS}

${BOLD}Summary:${END}
${WIKI}

${BOLD}Source:${END} ${SOURCE}
EOF

exit 0
