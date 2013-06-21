# Migrate OpenEpi.jQueryMobile to Twitter Bootstrap and AngularJS

We envision OpenEpi as an example of a modern, extensible, modular single-page application that can consume algorithms running either in the client
or on the server. It will feature off-line data collection, as well as connected sync and real-time group collaboration.

It will serve as case study in modernizing JavaScript applications in a connected world, for an open source craving developing world.

## Sprint 1

* Convert index.jade to static HTML
* Reference Angular and Bootstrap scripts
* Restructure shell to use <tabs> and <pane>
* Rebuild module selector to use simple ng-repeat with DIVs, similar to Learnlocity
    -- Add search filter and grouping by category
* Adapt the module loader to conform to Angular's needs for dependency injection
* Layout the modules selector tab, module, and results tab first, ignoring history and templates
* Figure out how to use angular.element for generating the form fields dynamically
* Use Mocha or Jasmine for module algorithm tests in Node.js
* Try to use D3 or something for a sample output oohs and aahs

## Sprint 2

* Work on how App Catalog could actually be reused for the modules selector / loader
* Work on history and templates

## Sprint 3

* Can Angular UI Grid be used for the twoXtwo module?


