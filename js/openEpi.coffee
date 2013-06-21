define 'openEpi', ['modules', 'angular', 'angular-twitter-bootstrap'], (modules) ->
  openEpi = angular.module('openEpi', ['ui.bootstrap'])

  onError = (message) ->
    console.log 'Error: '
    console.log message

  getModule = (moduleName) ->
    module = modules.getModule(moduleName)
    if not module?
      error "Could not find module named #{moduleName}"
      return null
    return module

  openEpi.config ['$routeProvider', ($routeProvider) ->
    $routeProvider.when('/', {templateUrl: 'partials/modules.html', controller: 'ModulesController'})
    $routeProvider.when('/module/:moduleName', {templateUrl: 'partials/module.html', controller: 'ModuleController'})
    $routeProvider.otherwise({redirectTo: '/'})
  ]

  openEpi.controller 'ModulesController', ['$rootScope', '$scope', '$location',
    ($rootScope, $scope, $location) ->
      $scope.modules = modules

      $scope.moduleLoad = (moduleName) ->
        $location.path '/module/' + moduleName

      $scope.moduleFilter = (module, filterTerm) ->
        return true if not filterTerm?
        return true if module.title.toLowerCase().indexOf(filterTerm.toLowerCase()) > -1
        for tag in module.tags
          return true if tag.toLowerCase().indexOf(filterTerm.toLowerCase()) > -1
        return false

      $scope.detailsTitle = (detailsShown) ->
        return "More Info" if not detailsShown
        return "Less Info"
  ]

  openEpi.controller 'ModuleController', ['$rootScope', '$scope', '$routeParams', '$location',
    ($rootScope, $scope, $routeParams, $location) ->
      module = getModule $routeParams.moduleName
      module.resetInputModel()
      $scope.module = module
      $scope.hasResult = false
      $scope.result = {
        resultPaneActive: false
      }

      $scope.getDefaultValue = (field) ->
        return field.defaultValue if field.defaultValue?
        return ''

      $scope.calculate = ->
        module.calculate module.model, onError, (result) ->
          module.renderData result, (data) ->
            $scope.hasResult = true
            $scope.result = data
            $scope.result.resultPaneActive = true

      $scope.clear = ->
        module.resetInputModel()
  ]

  angular.bootstrap document, ['openEpi']

  return openEpi



