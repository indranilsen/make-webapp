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
nvar=0
lvar=0
args=()

while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			echo -n -e "webapp [OPTION]... [FILE]...

			This script creates a boilerplate for an AngularJS web app.	

			Options:
			-h, --help        Print usage information
			-n, --name        Name of project
			-l, --logfile     Specify directory for log file as parameter
			-s, --silent      Do not print log messages to standard output\n"
			exit
			;;
		--name | -n)
			shift
			projectName="${1}"
			if [ -z "$projectName" ]; then
				echo "Specify log file path."
				exit
			else
				nvar=1
			fi
			;;
		--silent | -s)
			silent=1
			;;
		--version | -v)
			echo "$version"
			exit
			;;
		--logfile | -l)
			shift
			LOG_FILE="${1}"
			if [ -z "$LOG_FILE" ]; then
				echo "Specify log file path."
				exit
			else
				lvar=1
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

# Installing homebrew dependencies
# --------------------
# Dependencies for running the webapp are installed using homebrew
# --------------------
installBrewDependencies() {
	for pkg in ${install[@]}
	do
		"$(brew install "$pkg")"
	done
}

# Log Messages
# --------------------
# Logs messags to standard output. Three types of messages
# can be logged:
#	e: error messages
#	m: general message
# 	l: activity log messages
#	n: unformatted, normal messages (not logged to log file)
# Each type is displayed differently. If the --silent flag
# and a log file directory is specied by --logfile /directory,
# then any log message will be piped to the log file.
# --------------------
log() {
	TAG=""
	TIMESTAMP="$(date +"%Y-%m-%d:%H:%M:%S")"
	cleanPrint=false
	local OPTIND;
	while getopts "e:m:l:n:" option
	do
		case "${option}" in
			m) TAG="$yellow[MSG] ";;	
			e) TAG="$red[ERR] ";;
			l) TAG="$cyan[LOG] ";;
			n) TAG=""; cleanPrint=true;;
			*) echo 'Incorrect log usage. Flag required.'; exit;;
		esac

		if [ $silent -eq 1 ] && [ cleanPrint = false ] && [ $lvar -eq 1 ]; then
				echo -e "${TAG:5}[$TIMESTAMP]:\n$OPTARG\n" >> $LOG_FILE
		else
			echo "$TAG$colorReset$OPTARG"
		fi
	done
}

# Checking Required Arguments
# --------------------
# Required arguments are checked. If they are not passed, the program exits gracefully.
# --------------------
checkReqArgs() {
	if [ $nvar -ne 1 ]; then
		log -e "Project name required"
		exit
	fi
}
# Making App Directories
# --------------------
# Makes the directories for app. The root folder is the project name specified by the user.
# --------------------
makeDirectories() {
	root="$(pwd)/$projectName"
	mkdir -p $root/{server,web/{css/{footer,header,main-content,page-overall,third-party},img/main-content,js/{controllers,directives,providers},partials}}
}

# ========================================
#	SETUP
# ========================================
#checkBrewDependencies
#installBrewDependencies

checkReqArgs
makeDirectories
