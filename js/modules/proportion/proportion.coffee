define ->
	name:'Proportion'
	tags:['sample size']
	title: 'Simple Proportion'
	titleShort: 'Proportion'
	summary: 'Confidence limits for a single proportion'
	description: 'This module provides confidence limits for simple (binomial) proportions. Entering a numerator and denominator produces confidence limits calculated by several different methods. The numerator must be smaller than the denominator and both must be positive numbers.'
	inputFields: 
		numerator:
			label: 'Numerator'
			dataType: 'number'
			editorAttrs:
				value: '10'
		denominator:
			label: 'Denominator'
			dataType: 'number'
			editorAttrs:
				value: '20'
					
	calculate: (model, error, callback) ->
		callback(model.numerator / model.denominator)

	render: (result, callback, error) ->
		callback("<h4>" + result + "</h4>")