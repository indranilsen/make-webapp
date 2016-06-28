#!/bin/bash
# ========================================
#	HEADER
# ========================================

# Author: Indranil Sen
# 
# This script creates a boilerplate for an
# AngularJS web app.

version="1.0.0"

# ========================================
#	FLAGS
# ========================================

# Defaults
silent=0
saveLog=0
args=()

while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			echo 'usage'
			exit
			;;
		--silent | -s)
			silent=1
			;;
		--logfile | -l)
			shift
			LOG_FILE="${1}"
			if [ -z "$LOG_FILE" ]; then
				echo "Specify log file path."
				exit
			fi
			saveLog=1
			;;
	esac
	shift
done

# ========================================
#	VARIABLES
# ========================================
scriptName="${BASH_SOURCE[0]}"
scriptPath="$(cd "$(dirname "scriptName" )" && pwd)"

homebrewDependencies=("neil")
install=()

if [ $saveLog -eq 0 ]; then LOG_FILE=$(pwd)"/msg.log"; fi

blue=$(tput setaf 4)
cyan=$(tput setaf 6)
red=$(tput setaf 1)
pink=$(tput setaf 5)
yellow=$(tput setaf 3)
colorReset=$(tput sgr0)
# ========================================
#	FUNCTIONS
# ========================================

# Checking for homebrew dependencies
# --------------------
# Dependencies for running the webapp are listed in the
# arrays. If not found, the dependices are installed.
# --------------------

checkBrewDependencies() {
	for pkg in ${homebrewDependencies[@]}
	do
		if [ $(which $pkg 2>/dev/null) ]; then
			continue
		else
			echo $pkg not installed
			install+=("$pkg")
		fi
	done
}

installBrewDependencies() {
	for pkg in ${install[@]}
	do
		"$(brew install "$pkg")"
	done
}

log() {
	TAG=""
	TIMESTAMP="$(date +"%Y-%m-%d:%H:%M:%S")"
	# e:error, m:message, l:log
	while getopts "e:m:l:" option
	do
		case "${option}" in
			m) TAG="$yellow[MSG] ";;	
			e) TAG="$red[ERR] ";;
			l) TAG="$cyan[LOG] ";;
			*) echo 'Incorrect log usage. Flag required.'; exit;;
		esac

		if [ $silent -eq 1 ]; then
				echo -e "${TAG:5}[$TIMESTAMP]:\n$OPTARG\n" >> $LOG_FILE
			else
				echo "$TAG$colorReset$OPTARG"
		fi
	done
}

# ========================================
#	SETUP
# ========================================
#checkBrewDependencies
#installBrewDependencies

log -m "THIS IS A LOG MESSAGE"
