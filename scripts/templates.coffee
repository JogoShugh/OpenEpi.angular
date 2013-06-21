(->
  templateNames = ["input-text", "display-moduleList", "input-textarea", 'display-templatesList', 'display-templatesListItem', 'display-historyList', 'display-historyListItem']
  templateInsaneNames = ("text!../templates/" + name + ".jade" for name in templateNames)

  define templateInsaneNames, (args...) ->
    templates = {}
    templates[templateNames[i]] = args[i] for i in [0..args.length]
    return templates
)()