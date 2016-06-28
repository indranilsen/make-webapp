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
#	VARIABLES
# ========================================
scriptName="${BASH_SOURCE[0]}"
scriptPath="$(cd "$(dirname "scriptName" )" && pwd)"
LOG_FILE="/Users/indranilsen/desktop/msg.log"
homebrewDependencies=("neil")

install=()

silent=false

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
	if [ $silent = true ]; then
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
