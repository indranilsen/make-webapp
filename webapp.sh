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

blue=$(tput setaf 3)
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
	if [ $silent -eq 1 ]; then
		echo -e "[`date +"%Y-%m-%d:%H:%M:%S"`] $@" >> $LOG_FILE
	else
		echo "$pink[`date +"%Y/%m/%d:%H:%M:%S"`] $colorReset$@"
	fi
}

# ========================================
#	SETUP
# ========================================
#checkBrewDependencies
#installBrewDependencies

log "THIS IS A LOG MESSAGE"
