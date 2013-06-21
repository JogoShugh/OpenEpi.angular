define [
	'../modules/stdMortRatio',
	'../modules/ciMedian',
	'../modules/proportion'
]
, (args...) -> 
	modules = {}
	modules[module.name] = module for module in args
	return modules