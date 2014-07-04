# Instructions

This application is written in nodejs with coffeescript.

It provides the following api with https:

* POST /v1/sign_in
  * Example: https://localhost:3000/v1/sign_in
  * Input: { user: "", pwd: "" }
  * Output: { token: "auth-token" }

* POST /vi/sign_out
  * Example: https://localhost:3000/v1/sign_in
  * Header: "x-token: auth-token"

* GET /v1/grades
  * Example: https://localhost:3000/v1/grades
  * Header: "x-token: auth-token"
  * Input: "country=country_a"
  * Output: return user list group by grades in JSON

* GET /v1/files
  * Example: https://localhost:3000/v1/files
  * Header: "x-token: auth-token"
  * Input: "folder=subdir1"
  * Output: return files under a directory in JSON

* GET /v1/system_status
  * Example: https://localhost:3000/v1/system_status
  * Header: "x-token: auth-token"
  * Output: return system status in JSON

# Installation

* install nodejs 
    http://nodejs.org/

* install coffeescript
    http://coffeescript.org/#installation
    npm install -g coffee-script

* install jasmine-node for unittest
    https://github.com/mhevery/jasmine-node
    npm install jasmine-node -g

* install mysql 

# Configuration
    The configuration for the app could be found in:
        config.json -- for normal app
        configut.json -- for unittest

    It contains the information for how to access the database and also debug logging info.

# Notes about mysql
    This app expects a connection to a mysql database.
    The default setting for the app to the database is:
        
        "host": "localhost",
        "user": "sampleapp", 
        "password": "secret",
        "port": "3306",
        "database": "sampleapp"

    Please modify them if needed

# Starting the application
* npm install 
    To install the required module
* cake db:reset
    To reset the database
* cake db:seed
    To seed the database with some default values
* npm start

# Run unittest
* jasmine-node --coffee spec

# Examples
  Examples are provided under the example folder

