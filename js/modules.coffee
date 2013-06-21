define [
	'modules/stdMortRatio',
	'modules/ciMedian',
	'modules/proportion'
]
, (args...) -> 
  modules = {}
  for mod in args
    modules[mod.name] = mod

  for modName, mod of modules
    console.log mod
    mod.resetInputModel = ->
      delete mod.model if mod.model?
      model = {}
      for key in mod.inputFields
        model[key] = ''
      mod.model = model
    console.log mod.resetInputModel

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