# Summary

This is a rough draft version of [OpenEpi.com](http://www.openepi.com) done with jQueryMobile, and a bunch of other popular and powerful open-source libraries.

# How to run

I've only tested with FireFox and Chrome so far. In FireFox, you should be able to run `index.html` from a `file://` url, but in Chrome, you'll have to start chrome with `<pathtochrome>\chrome.exe --allow-file-access-from-files` to enable AJAX support from the file system. _(This is not optimal, so I will eventually not rely on this way of loading dynamic files)_

# Technical Implementation

Besides [jQuery Mobile](http://jquerymobile.com/), the libraries used so far are:

1. [RequireJS](http://requirejs.org) -- Asynchronous Module Definition (AMD)
2. [Knockback.js](http://kmalakoff.github.com/knockback/) -- Backbone.js + Knockout.js for magic bindings
3. [Jade](http://jade-lang.com/) -- HTML templates
4. [toastr](https://github.com/CodeSeven/toastr) -- toast style messages
5. [CoffeeScript](http://coffeescript.org/) -- _love JS, but gotta have my caffeine now..._
6. [Nodefront](http://karthikv.github.com/nodefront/) -- for CoffeeScript and Jade "compilation" to JavaScript and static HTML

# Screencast Walkthrough

I have a rough draft screencast up also, 1 hour long: [OpenEpi.com.jQueryMobile Architecture](http://www.screencast.com/users/JoshGough/playlists/OpenEpi.com.jQueryMobile%20Architecture)
It's divided into parts, mostly because I don't have my Jing registered yet :-D

1. Introduction
2. Technologies Overview
3. Jade / Html Shell
4. Module loading with RequireJS
5. CoffeeScript/ JS Application Shell
6. Wiring Up Components
7. Dynamic Form Building with Jade Templates
8. Creating a ViewModel from a Module's Input Fields
9. Model to UI Binding Magic with Knockback and Friends
10. Manipulating the Model and UI with Chrome's Debugger
11. Lazy-Loading an External Module on a Button Click
12. Thank You

# Next Steps

This is just a prototype. Some things on my mind:

1. Using proper Backbone concepts, like [Views](http://backbonejs.org/#View) and [Routers](http://backbonejs.org/#Router), etc
2. [Backbone Forms](https://github.com/powmedia/backbone-forms) looks better than my home-rolled `inputFields` approach.
3. Using [Backbone.sync for localStorage](http://documentcloud.github.com/backbone/docs/backbone-localstorage.html) to allow saving of form inputs to `localStorage`, and potentially to backend servers as well.
4. Does it actually need Knockback? Not really sure yet...

# How to compile from source

The app doesn't currently use Node.js to run, but if you want to modify and compile the JavaScript and HTML you'll need to install [Node.js](http://nodejs.org/) and [Nodefront](http://karthikv.github.com/nodefront/) in order to "compile" the Jade into static HTML.

Once you've installed that, you can type `make.sh` and it will regenerate index.html, etc from the jade files.
