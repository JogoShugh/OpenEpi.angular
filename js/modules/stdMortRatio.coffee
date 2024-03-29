define ["require"], (require) ->
  name: "StdMortRatio"
  tags: ["counts"]
  title: "Standardized Mortality Ratio"
  titleShort: "Std.Mort.Ratio"
  summary: "Ratio of observed deaths in the study group to expected deaths in the general population"
  description: "The Standardized Mortality Ratio (SMR) is the ratio of observed to the expected number of deaths in the study population under the assumption that the mortality rates for the study population are the same as those for the general population. For nonfatal conditions, the Standardized Mortality Ratio is sometimes known as the Standardized Morbidity Ratio. Entering observed and expected number of cases (deaths) will result in the point estimate of SMR and the confidence intervals at the user's setting."
  inputFields:
    observedNumberOfCases:
      label: 'Observed number of cases'
      jqmType: 'textinput'
      editorAttrs:
        value: '4'
    expectedNumberOfCases:
      label: 'Expected number of cases'
      jqmType: 'textinput'
      editorAttrs:
        value: '3'

  calculate: (model, error, callback) ->

    console.log "calculate: about to load my own dependency on 'bigFatPowerAlgorithm' " + "using require...Hold on to your hats for a moment..."
    require ["modules/bigFatPowerAlgorithm"], (bigFatPowerAlgorithm) ->
      console.log "calculate: I have my bigFatPowerAlgorithm!"
      result = bigFatPowerAlgorithm.execute(Number(model.observedNumberOfCases), Number(model.expectedNumberOfCases))
      callback result
      
  render: (result, callback, error) ->
    callback("<h4>" + result + "</h4>")      