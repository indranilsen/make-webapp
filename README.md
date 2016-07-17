# make-webapp
This script creates a boilerplate project for an AngularJS web app.

## Installation

#### 1. Homebrew

Open terminal and type the following:
```
brew tap indranilsen/make-webapp
brew install make-webapp
```

Note that this adds the script to the user's ```PATH```

#### 2. Clone/Download
 After cloning or downloading, open terminal and ```cd``` into the **templater** directory. 
 
Before executing the script, change its permission:
 ```
 chmod +x make-webapp
 ```
 
To execute the script from any directory, add it to your ```PATH```:
```
cp -i /DIRECTORY_OF_SCRIPT/make-webapp /usr/local/bin
```

## Usage

Display usage information: ```make-webapp --help ``` or ```make-webapp -h```

Flags and arguments:

```
-h, --help                        Print usage information
-n, --name     [project_name]     Name of project
-t, --template					               Initialize project with a template and css
-l, --logfile  [path]             Specify path for log file as parameter
-s, --silent                      Do not print log messages to standard output
-v, --version                     Prints script version to standard output
```
**NOTE:**  
1. If you haven't added the script to your ```PATH``` you must ```cd``` to the script directory and execute by typing ```./make-webapp```  
2. A log file is created only when the ```--logfile [path]``` or ```-l [path]``` arguments are specifed. _[path]_ should be a valid directory. Do not specify logfile name. **Example:** ```make-webapp -l /Users/me/desktop```  
3. If ```-t``` or ```--template``` flags are not specified as script arguments, the user will be prompted to include template and then be prompted to include associated CSS.

## Features

* Creates an AngularJS project with modular architecture
* Adds the Gulp Task Runner to the project with gulp, config files and gulp tasks
* ```-t, --template``` flag creates a fully functional angular app with UI-Routing
 * Files (ex: index.html, etc.) are automatically populated and linked to each other
 * Directives and partials are used to modularize the application, and facilitate a move to Angular 2
* Automatically installs default node packages and prompts user for additional packages during execution
 * Default packages can be specified in the script in the ```nodeDevDependencies=()``` list
* Checks for dependencies to run the script and installs if something is missing, including **homebrew** and **node**
