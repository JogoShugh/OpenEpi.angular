# Summary

As demonstrated during the unconference day of Open Source Bridge 2013, this is a rough draft 
version of [OpenEpi.com](http://www.openepi.com) ported to Twitter Bootstrap, AngularJS, and RequireJS. 
It's a second attempt at porting the software. The last time, I did it with Backbone and jQuery Mobile, 
plus about 10 other libraries that I had to add! This time, I love that so few additional libraries are needed.

# How to run

* Install Node.js, if you don't already have it, from [http://www.nodejs.org](http://www.nodejs.org)
* Clone or download the repository and navigate to the directory in a bash prompt
* If you don't have CoffeeScript installed, type `npm install -g coffee-script`
* Type `npm install` to install the dependencies
* Run `./build.sh` to recompile the CoffeeScript (just in case I forgot to check in the JavaScript files)
* Run `./run.sh` to run the server
* Navigate to [http://localhost:8081/app/index.html](http://localhost:8081/app/index.html) in your browser.

# CoffeeStand

You can also use CoffeeStand to watch the entire folder and have it recompile coffee files when you change them.

To do this type `npm install -g coffeestand`, and then either run `. ./watchCoffee.sh` or simply type `coffeestand &`.
