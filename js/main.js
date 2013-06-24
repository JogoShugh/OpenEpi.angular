// Generated by CoffeeScript 1.6.2
(function() {
  require.config({
    baseUrl: '/app/js',
    paths: {
      'angular': '/app/lib/angular/angular',
      'angular-resource': '/app/lib/angular/angular-resource',
      'angular-twitter-bootstrap': '/app/lib/angular/ui-bootstrap-tpls-0.3.0',
      'angular-grid': '/app/lib/angular/ng-grid.min'
    },
    shim: {
      'angular': {
        exports: 'angular'
      },
      'angular-resource': {
        deps: ['angular']
      },
      'angular-twitter-bootstrap': {
        deps: ['angular']
      },
      'angular-grid': {
        deps: ['angular']
      },
      'underscore': {
        exports: '_'
      }
    }
  });

  require(['openEpi'], function(openEpi) {
    window.openEpi = openEpi;
    window.oe = function(moduleName, args) {
      return window.openEpi.exec(moduleName, args);
    };
    return ' todo:\nwindow.oe = (moduleName, args) ->\n  window.openEpi.exec moduleName, args, window.oe.addToHistory\nwindow.oe.addToHistory = false';
  });

}).call(this);
