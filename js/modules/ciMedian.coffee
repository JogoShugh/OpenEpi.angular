define [], ->
  name:'ConfidenceInterval'
  tags:['continuous variables', 'sample size']
  title: 'Confidence Interval'
  titleShort: 'Median / %ile CI'
  summary: 'Confidence interval of median or other percentile for a sample size',
  description: 'This module calculates confidence interval around a selected percentile for a sample size given. Entering sample size and desired percentile will calculate 95% confidence interval as a default confidence limit. The user can change the confidence interval by typing in new value. Please note that the selected percentile should be within 1 - 100.'
  authors:
    Statistics: 'Minn M. Soe and Kevin M. Sullivan (Emory University)'
    Interface: "Andrew G. Dean (<a href='http://www.EpiInformatics.com' target='_blank'>EpiInformatics.com</a>), Roger A. Mir, and Joshua Gough (<a href='http://www.agilefromthegroundup.com/site/Home.aspx' target='_blank'>AgileFromTheGroundUp.com</a>)"
  inputFields:
    sampleSize:
      label: 'Sample Size'
      labelSm: 's'
      dataType: 'number'
      defaultValue: '100'
    median:
      label: 'Desired Percentile'
      labelSm: 'm'
      defaultValue: '50'
    confidenceLevel:
      label: 'Confidence Level (%)'
      labelSm: 'cl'
      dataType: 'number'
      defaultValue: '95'
   
  calculate: (model, error, callback) ->
    n = parseFloat model.sampleSize
    if n <= 0
      error "Sample size must be > 0"
      return

    median = parseFloat model.median

    if median <= 0 or median > 100
      error "Percentile value must be within the limits of 1-100%"
      return

    cscrit = 0
    pt = 0
    z = 0
    pt = parseFloat model.confidenceLevel

    cscrit = 15.137 if pt is 99.99
    cscrit = 13.831 if pt is 99.98
    cscrit = 12.116 if pt is 99.95
    cscrit = 10.828 if pt is 99.9
    cscrit = 9.550  if pt is 99.8
    cscrit = 7.879  if pt is 99.5
    cscrit = 6.635  if pt is 99
    cscrit = 5.412  if pt is 98
    cscrit = 3.841  if pt is 95
    cscrit = 2.706  if pt is 90
    cscrit = 2.072  if pt is 85
    cscrit = 1.642  if pt is 80
    cscrit = 1.323  if pt is 75
    cscrit = 1.074  if pt is 70
    cscrit = 0.873  if pt is 65
    cscrit = 0.708  if pt is 60
    cscrit = 0.571  if pt is 55
    cscrit = 0.455  if pt is 50
    cscrit = 0.357  if pt is 45
    cscrit = 0.275  if pt is 40
    cscrit = 0.206  if pt is 35
    cscrit = 0.148  if pt is 30
    cscrit = 0.102  if pt is 25
    cscrit = 0.064   if pt is 20
    
    if cscrit is 0 
      error "The selected confidence interval is not available, choose other ranges"
      return false
    
    z = Math.sqrt cscrit

    #rank calculation:
    np = 0
    p = 0
    p = median / 100
    if p is 0.5
      np = (n + 1) / 2
    else
      np = Math.round(n * p)

    #confidence limits and checking errors;
    ll = Math.round(n * p - z * (Math.sqrt(n * p * (1 - p))))
    ll = 0  if ll <= 0
    ul = Math.round(1 + n * p + z * (Math.sqrt(n * p * (1 - p))))
    ul = 0  if ul <= 0
    ul = n  if ul >= n

    resultModel = 
      model: model
      fields: @.inputFields
      n: n
      median: median
      pt: pt
      confidenceIntervalCategory: pt
      sampleSize: n
      output: 
        lowerLimit: ll
        rank: np
        upperLimit: ul

    callback resultModel

  renderData: (result, callback, error) ->
    data = {
      heading: "Confidence Interval for #{result.model.median}th percentile of sample size #{result.model.sampleSize}"
      columns: ['Method', 'Lower Limit', 'Rank', 'Uppert Limit']
      rows: [['Normal Approximation', result.output.lowerLimit, result.output.rank, result.output.upperLimit]]
    }
    callback data

  renderHistoryLabel: (result, callback, error) ->
    sampleSize = @.inputFields.sampleSize.labelSm
    median = @.inputFields.median.labelSm
    conf = @.inputFields.confidenceLevel.labelSm
    label = "#{sampleSize}:#{result.model.sampleSize} #{median}:#{result.model.median} #{conf}:#{result.model.confidenceLevel}"
    callback label

  renderHistoryResult: (result, callback, error) ->
    ll = result.output.lowerLimit
    np = result.output.rank
    ul = result.output.upperLimit
    label = "ll:#{ll} np:#{np} ul:#{ul}"
    callback label    
'''

//The text in the next variables will be inserted into the HTML document that comes up in response to the Exercise link
CalcCIMedian.Demo = "For non-Normal distribution, the median of the sample or population is preferable to the mean as a measure of location (Rank). Medians are also appropriate in other situations-for example, when measurements are on an ordinal scale. In a dataset of 100 diabetic patients, let's assume the median systolic blood pressure is 146 mmHg. Using this module, let's calculate 95% confidence interval of median value in the sample." +
        "<ul>" +
        "<li>First, enter the sample size (eg. 100), median value (eg. 50), and 95% confidence interval (eg. 95) in respective cells in Open Epi Median program, and click on Calculate. </li>" +
        "<li>In the new window screen, 95% confidence limits of Median position in the sample are seen as 40 - 61. This result is calculated from the normal approximation method of large sample size theory. </li>" +
        "<li>Then, after arranging observations (here, the systolic blood pressure) in increasing order, read the corresponding values of systolic blood pressure at 40th and 61th position. They are 95% confidence interval of median systolic blood pressure of the sample. </li>" +
        "</ul>";

CalcCIMedian.Exercises = "currently not available";

'''