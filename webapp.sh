#!/bin/bash
# ========================================
# Author: Indranil Sen
# 
# This script creates a boilerplate for an
# AngularJS web app.

version="1.0.0"

# ========================================

# Script location
scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Checking for homebrew dependencies
# --------------------
# Dependencies for running the webapp are listed in the
# arrays. If not found, the dependices are installed.
# --------------------
homebrewDependencies=("neil")

install=()

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

checkBrewDependencies
installBrewDependencies
