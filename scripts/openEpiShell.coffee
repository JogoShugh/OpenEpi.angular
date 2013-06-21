define [
    'modules', 
    'templates',
    'backbone',
    'backbone-forms',
    'underscore',
    'toastr',
    'jquery',
    'jquery.mobile',
    'jquery.jade',
    'dateFormat'
], 
(
    modules,
    templates,
    Backbone,
    bbforms,
    _,
    toastr,
    $,
    jqm,
    jade,
    dateFormat
) ->

  log = (message) ->
    console.log message

  info = (message, options) ->
    toastr.info message, options

  success = (message, options) ->
    toastr.success message, options

  error = (message) ->
    toastr.error message
    console.log 'OpenEpi Error:' + message

  class OpenEpiShell
    constructor: ->    
      @moduleModels = {}
      @templateModules = @getTemplatesModules()
      @templatesListRendered = false
      @historyList = @getHistoryList()
      @historyListRendered = false

      toastr.options = positionClass : 'toast-bottom-right'

      $ =>
        h = $(window).height()
        $("#splash").css("height", h)
        $.mobile.loading('show')
        $('#bodyDiv').css('visibility','visible').hide().fadeIn('slow');
        $.mobile.loading('hide')

        $("#more").on
          popupbeforeposition: ->
            h = $(window).height()
            $("#more").css("height", h)

        $("#moreModule").on
          popupbeforeposition: ->
            h = $(window).height()
            $("#moreModule").css("height", h)            

        @renderModuleLinks()

        window.setTimeout ->
          $.mobile.changePage "#home"
        , 1750

    renderModuleLinks: ->
      info "Loaded all modules successfully..."
      moduleSelector = $("#moduleSelector")
      tmpl = templates['display-moduleList']
      mods = modules : modules
      html = $.jade(tmpl, mods)
      moduleSelector.append(html)
      that = @
      $('.moduleItem a').each ->
        item = $(@)
        moduleName = item.attr('data-moduleName')
        item.bind 'click', =>
          that.moduleLoad moduleName

      @templateModulesListRender()
      @historyListRender()

    exec: (moduleName, args, addToHistory) ->
      module = @getModule moduleName
      callback = (result) =>
        console.log result
        if addToHistory
          @historyAdd module, result.model, result

      error = (err) ->
        console.log 'Error:'
        console.log err
      if not module?
        error "Could not find module named: #{moduleName}"
        return
      module.calculate args, callback, error

    moduleLoad: (moduleName, formValue) ->
      modulePage = $("#module")
      module = @getModule moduleName
      if not module?
        return      
      moduleModel = @getModuleModel module
      if not moduleModel?
        return

      $("#resultsMissing").show()
      $("#resultsPane").hide()

      modulePage.find('.fields').each (i, el) =>
        fieldContainer = $(el)
        fieldContainer.empty()
        $("#moduleTitle").text(module.title)
        model = new moduleModel
        args = model: model        
        formModel = new Backbone.Form(args)
        if formValue?
          formModel.model.attributes = formValue
        form = formModel.render()
        fieldContainer.html(form.el)

        # Finallly, rebind the click handler for the "Calculate" button and
        # attach it to the calculate method of the current module
        modulePage.find('.calculate').each (i, el) =>
          command = $(el)
          command.unbind('click').bind 'click', =>
            formValue = form.getValue()      
            $.mobile.loading('show')
            module.calculate formValue, (result) =>
              @showResult result, module.render
              @historyAdd module, formValue, result
              $.mobile.loading('hide')
            , @error

        modulePage.find('.templateSave').each (i, el) =>
          command = $(el)
          command.unbind('click').bind 'click', =>
            formValue = form.getValue()
            @templatesAdd module, formValue
            stp = $('#saveTemplatePopup')
            stp.popup 'close'

        $("#moduleSummary").html(module.summary)
        $("#moduleDescription").html(module.description)
        authors = $("<div style='padding-left:5px'></div>")
        for authorType, authorCredit of module.authors
          authors.append("<div style='color:#333333'><b style='color:#555555'>#{authorType}:</b> #{authorCredit}</div>")
        $("#moduleAuthors").append(authors)
        $("#moduleInfo").collapsible()

        $.mobile.changePage("#module")
        modulePage.trigger('create') # enhance the controls, JQM style
        $('#history').trigger('create')

    getModule: (moduleName) ->
      module = modules[moduleName]
      if not module?
        error "Could not find module #{moduleName}"
        return null
      return module

    getModuleModel: (module) ->
      moduleModel = @moduleModels[module.name]
      if not moduleModel?
        moduleModel = Backbone.Model.extend(schema: module.inputFields)
        @moduleModels[module.name] = moduleModel
      return moduleModel

    showResult: (result, renderFn) ->
      resultPage = $('#results')
      resultData = $('#resultData')
      processing = $('#processing')
      resultData.hide()  
      processing.show()
      $("#resultsMissing").hide()
      $("#resultsPane").show()  
      $.mobile.changePage('#results')
      window.setTimeout ->
        processing.fadeOut().promise().done ->
          completeRender = (html) ->
            resultData.empty()
            resultData.append(html)
            resultData.fadeIn(200)
          renderFn(result, completeRender, error)
      , 200

    getTemplatesModules: () ->
      if window.localStorage.getItem('templateModules') == null
        window.localStorage.setItem('templateModules', JSON.stringify [])
      templateModules = JSON.parse window.localStorage.getItem('templateModules')
      return templateModules

    templatesAdd: (module, formValue) ->
      templateName = $('#templateName').val()
      templateModule = {templateName: templateName, moduleName: module.name, formValue: formValue, dateTime: new Date().format()}
      @templateModules.unshift templateModule
      window.localStorage.setItem('templateModules', JSON.stringify @templateModules)
      success "Template #{templateName} added"
      @templateModulesListRender()

    templateModulesListRender: ->
      templateModuleSelector = $("#templateModules")
      if (@templatesListRendered == false)
        tmpl = templates['display-templatesList']
        html = $.jade(tmpl, {})
        templateModuleSelector.append(html)
      
      $('#templateModulesList').empty()
      
      modObjs = {}
      $.extend true, modObjs, @templateModules
      mods = templateModules : modObjs
      log mods
      _.each mods.templateModules, (item) =>
        item.module = @getModule item.moduleName

      tmplItems = templates['display-templatesListItem']
      items = $.jade(tmplItems, mods)
      $('#templateModulesList').append(items)
      
      $('.templateModule').children('a').each (i, el) =>
        item = $(el)
        index = Number(item.attr('data-index'))
        templateModule = @templateModules[index]
        moduleName = templateModule.moduleName
        formValue = templateModule.formValue 
        item.bind 'click', =>
          @moduleLoad moduleName, formValue
      
      if @templatesListRendered
        try
          $('#templateModulesList').listview('refresh')
        catch ex
          console.log "Error:"
          console.log ex
      else  
        @templatesListRendered = true

      return

    getHistoryList: ->
      if window.localStorage.getItem('historyList') == null
        window.localStorage.setItem('historyList', JSON.stringify [])
      histList = JSON.parse window.localStorage.getItem('historyList')
      return histList

    historyAdd: (module, formValue, result) ->
      historyItem = 
        moduleName: module.name
        result:
          model: formValue # TODO TEMP HACK
          output: result.output
        dateTime: new Date().format()        
      @historyList.unshift historyItem
      window.localStorage.setItem('historyList', JSON.stringify @historyList)
      @historyListRender()

    historyListRender: ->
      historyItemsSelector = $("#historyListContainer")
      if @historyListRendered == false
        tmpl = templates['display-historyList']
        html = $.jade(tmpl, {})
        historyItemsSelector.append(html)      
      $('#historyList').empty()

      modObjs = {}
      $.extend true, modObjs, @historyList
      mods = historyList : modObjs
      log mods
      _.each mods.historyList, (item) =>
        module = @getModule item.moduleName
        item.module = module
        module.renderHistoryLabel item.result, (result) ->
          item.label = result
        module.renderHistoryResult item.result, (result) ->
          item.result = result

      tmplItems = templates['display-historyListItem']
      items = $.jade(tmplItems, mods)
      $('#historyList').append(items)
      
      $('.historyItem').children('a').each (i, el) =>
        item = $(el)
        index = Number(item.attr('data-index'))
        historyItem = @historyList[index]
        moduleName = historyItem.moduleName
        formValue = historyItem.result.model
        item.bind 'click', =>
          @moduleLoad moduleName, formValue
      try
        if @historyListRendered == true
          $('#historyList').listview('refresh')
        else
          #$('#historyList').listview()
          $('#historyList').listview('refresh')          
      catch ex
          console.log "Error listviewifying the list:"
          console.log ex
      @historyListRendered = true

  return OpenEpiShell