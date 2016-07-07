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
passedArgs=()

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
		--version | -v)
			echo "$version"
			exit
			;;
		--name | -n)
			passedArgs+=("n")
			shift
			projectName="${1}"
			if [ -z "$projectName" ]; then
				echo "Specify project name."
				exit
			fi
			;;
		--logfile | -l)
			passedArgs+=("l")
			shift
			LOG_FILE="${1}"
			if [ -z "$LOG_FILE" ]; then
				echo "Specify path to log file."
				exit
			fi
			if [ ! -d "$LOG_FILE" ]; then
				echo "Invalid path."
				exit
			fi
			saveLog=1
			;;
		--silent | -s)
			passedArgs+=("s")
			silent=1
			;;
	esac
	shift
done

# ========================================
#	VARIABLES
# ========================================
scriptName="${BASH_SOURCE[0]}"
scriptPath="$(cd "$(dirname "scriptName" )" && pwd)"

root="$(pwd)/$projectName"

homebrewDependencies=("neil")
install=()

nodeDevDependencies=("gulp" "gulp-inject" "gulp-concat" "gulp-uglify" "gulp-clean-css" "gulp-autoprefixer" "gulp-notify" "gulp-jshint")
nodeProdDependencies=()

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

# Checking for Homebrew Dependencies
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

# Installing Homebrew Dependencies
# --------------------
# Dependencies for running the webapp are installed using homebrew
# --------------------
installBrewDependencies() {
	for pkg in ${install[@]}
	do
		"$(brew install "$pkg")"
	done
}

# Installing Node Dependencies
# --------------------
# Dev and prod dependencies are installed using npm
# --------------------
installNpmDependencies() {
	for devPkg in ${nodeDevDependencies[@]}
	do
		"$(npm install --save-dev "$devPkg")"
	done

	for prodPkg in ${nodeProdDependencies[@]}
	do
		"$(npm install --save "$prodPkg")"
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

		shift

		if [ $silent -eq 1 ] && [ cleanPrint = false ] && [ $lvar -eq 1 ]; then
				echo -e "${TAG:5}[$TIMESTAMP]:\n$@\n" >> $LOG_FILE
		else
			echo "$TAG$colorReset$@"
		fi
	done
}

# Checking Required Arguments
# --------------------
# Required arguments are checked. If they are not passed, the program exits gracefully.
# --------------------
checkReqArgs() {
	required=('n:Project name required.')
	valid=0
	for ((i = 0; i < ${#required[@]}; i++))
	do
		flag="${required[$i]:0:1}"
		msg="${required[$i]:2}"

		for ((j = 0; j < ${#passedArgs[@]}; j++))
		do
			if [ $flag == ${passedArgs[$j]} ]; then
				((valid++))
				break
			fi
		done
	done

	if [ $valid -eq ${#required[@]} ]; then
		log -m "All required args are specified"
	fi
}

# Prompt User for Packages
# --------------------
# Aks the user to install additional node packages
# --------------------
promptAdditionalPackageInstall() {
	read -p "Install additional dev packages? (press return to continue) " val

	if [ ! -z "$val" ]; then
		if [[ $val == *[',']* ]]; then
			IFS=',' read -r -a packages <<< "$val"
		elif [[ $val == *[', ']* ]]; then
			IFS=', ' read -r -a packages <<< "$val"
		elif [[ $val == *[' ']* ]]; then
			IFS=' ' read -r -a packages <<< "$val"
		fi
	fi

	if [ ${#packages[@]} -gt 0 ]; then
		for pkg in ${packages[@]}
		do
			nodeDevDependencies+=("$pkg")
		done
	fi
}

# Making App Directories
# --------------------
# Makes the directories for app. The root folder is the project name specified by the user.
# --------------------
makeDirectories() {
	mkdir -p $root/{server,web/{css/{footer,header,main-content,page-overall,third-party},img/main-content,js/{controllers,directives,providers},partials}}
}

# Adding Content to Files
# --------------------
# Adding content to gitignore file
# --------------------
addGitIgnore() {
	cat <<- EOF
			
			###################
			#  MAC OS files
			###################
			.DS_Store
			.AppleDouble
			.LSOverride

			# Icon must end with two \r
			Icon


			# Thumbnails
			._*

			# Files that might appear in the root of a volume
			.DocumentRevisions-V100
			.fseventsd
			.Spotlight-V100
			.TemporaryItems
			.Trashes
			.VolumeIcon.icns

			# Directories potentially created on remote AFP share
			.AppleDB
			.AppleDesktop
			Network Trash Folder
			Temporary Items
			.apdisk

			####################
			# windows OS files
			####################
			# Windows image file caches
			Thumbs.db
			ehthumbs.db

			# Folder config file
			Desktop.ini

			# Recycle Bin used on file shares
			$RECYCLE.BIN/

			# Windows Installer files
			*.cab
			*.msi
			*.msm
			*.msp

			# Windows shortcuts
			*.lnk
		EOF
}

# --------------------
# Adding content to index.html
# --------------------
addIndexHTML() {
	read -r -d '' content <<- "EOF"
		<!DOCTYPE html>\n
		<html>\n
		<head>\n
			\t<meta charset="utf-8">\n
			\t<title>[Insert Title]</title>\n
			\t<link rel="stylesheet" href="css/styles-main.css" type="text/css" media="all">\n
		</head>\n\n

		<body>\n\n\n

		</body>\n\n

		<html>
		EOF

	echo -e $content
}

# --------------------
# Adding content to styles-main.js
# --------------------
addStylesMainCSS() {
	cat <<- EOF
		/* General page styles */
		@import url('page-overall/style.css');
		
		/* 3rd party */
		@import url('third-party/[INSERT FILE NAME].css');

		/* <header> styles */
		@import url('header/style.css');

		/* <main> and its children styles */
		@import url('main-content/style.css');

		/* <footer> styles */
		@import url('footer/style.css');

		EOF
}

# --------------------
# Adding content to gulpfile.js
# --------------------
addGulpFile() {
	printf "var config = require(\'./config.js\');\n"
	for devPkg in ${nodeDevDependencies[@]}
	do
		var="var $devPkg = require('$devPkg');"
		if [[ $var == *['-']* ]]; then
			var="var ${devPkg#*-} = require('$devPkg');"
		fi
		echo $var
	done
}

# --------------------
# Adding content to config.js
# --------------------
addGulConfigFile() {
	echo -e "var config = {\n\n}\n\nmodule.exports = config;"
}

# Making Files
# --------------------
# Adding different files to the project and concatenating 
# content to them.
# --------------------
addFiles() {
	touch $root/.gitignore
	touch $root/README.md
	
	touch $root/web/index.html
	
	touch $root/web/css/styles-main.css
	touch $root/web/css/header/style.css
	touch $root/web/css/main-content/style.css
	touch $root/web/css/footer/style.css
	touch $root/web/css/page-overall/style.css
	
	touch $root/web/js/app.js

	addGitIgnore > $root/.gitignore
	addIndexHTML > $root/web/index.html
	addStylesMainCSS > $root/web/css/styles-main.css
}

# Adding Gulp Task Runner to Project
# --------------------
# Adding gulpfile.js, congig.js package.json, 
# and installing dependencies. In addition, gulpfile.js 
# is populated with variables referencing the packages 
# that are installed as dev dependencies.
# --------------------
gulpSetup() {
	touch $root/web/gulpfile.js
	touch $root/web/config.js

	addGulpFile > $root/web/gulpfile.js
	addGulConfigFile > $root/web/config.js

	cd $root/web
	npm init
	installNpmDependencies
	cd ..
}

# ========================================
#	SETUP
# ========================================
#checkBrewDependencies
#installBrewDependencies

checkReqArgs
makeDirectories
promptAdditionalPackageInstall
addFiles
gulpSetup