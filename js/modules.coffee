define [
	'modules/stdMortRatio',
	'modules/ciMedian',
	'modules/proportion'
]
, (args...) ->
  modules = {}
  modules[mod.name] = mod for mod in args

  for modName, mod of modules
    console.log mod
    mod.resetInputModel = ->
      delete mod.model if mod.model?
      model = {}
      for key, value of mod.inputFields
        model[key] = if value.defaultValue? then value.defaultValue else ''
      mod.model = model

  getModule = (moduleName) ->
    mod = modules[moduleName]
    if not mod?
      return null
    return mod

  allModules = ->
    return modules

  return {
    getModule: getModule
    allModules: allModules
  }