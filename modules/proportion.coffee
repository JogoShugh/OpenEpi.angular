define ->
	name:'Proportion',
	group:'Sample Size',
	title: 'Simple Proportion',
	titleShort: 'Proportion',
	inputFields: 
		numerator:
			label: 'Numerator'
			jqmType: 'textinput'
			dataType: 'number'
			editorAttrs:
				value: '10'
		denominator:
			label: 'Denominator'
			jqmType: 'textinput'
			dataType: 'number'
			editorAttrs:
				value: '20'
					
	calculate: (model, callback, error) ->
		callback(model.numerator / model.denominator)

	render: (result, callback, error) ->
		callback("<h4>" + result + "</h4>")