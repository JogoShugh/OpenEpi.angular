require.config({
  baseUrl: '/app/js',
  paths: {
    'angular': '/app/lib/angular/angular',
    'angular-resource': '/app/lib/angular/angular-resource',
    'angular-twitter-bootstrap': '/app/lib/angular/ui-bootstrap-tpls-0.3.0'
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
    }
    'underscore': {
      exports: '_'
    }
  }
})

require ['openEpi'], (openEpi) ->
  window.openEpi = openEpi
  window.oe = (moduleName, args) ->
    window.openEpi.exec moduleName, args

  ''' todo:
  window.oe = (moduleName, args) ->
    window.openEpi.exec moduleName, args, window.oe.addToHistory
  window.oe.addToHistory = false
  '''



