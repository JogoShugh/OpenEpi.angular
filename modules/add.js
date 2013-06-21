define({
	name:'Add',
	group:'Counts',
	title: 'Simple Add',
	titleShort: 'Add',
	inputFields:
	[
		{
			id: 'firstNumber',
			label: 'First Number',
			required: true,
			type: 'textarea',
			jqmType: 'textinput',
			minlength: 5,
			maxlength: 50,
			defaultValue: '1'
		}
		,{
			id: 'secondNumber',
			label: 'Second Number',
			required: true,
			type: 'text',
			jqmType: 'textinput',
			minlength: 5,
			maxlength: 50,
			defaultValue: '2'
		}
	]
	,
	calculate: function(viewModel, callback) { 
		callback( Number(viewModel.firstNumber()) + Number(viewModel.secondNumber()) );
	}
});