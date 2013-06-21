// Generated by CoffeeScript 1.3.3
(function() {

  define(['modules', 'templates', 'backbone', 'backbone-forms', 'underscore', 'toastr', 'jquery', 'jquery.mobile', 'jquery.jade', 'dateFormat'], function(modules, templates, Backbone, bbforms, _, toastr, $, jqm, jade, dateFormat) {
    var OpenEpiShell, error, info, log, success;
    log = function(message) {
      return console.log(message);
    };
    info = function(message, options) {
      return toastr.info(message, options);
    };
    success = function(message, options) {
      return toastr.success(message, options);
    };
    error = function(message) {
      toastr.error(message);
      return console.log('OpenEpi Error:' + message);
    };
    OpenEpiShell = (function() {

      function OpenEpiShell() {
        var _this = this;
        this.moduleModels = {};
        this.templateModules = this.getTemplatesModules();
        this.templatesListRendered = false;
        this.historyList = this.getHistoryList();
        this.historyListRendered = false;
        toastr.options = {
          positionClass: 'toast-bottom-right'
        };
        $(function() {
          var h;
          h = $(window).height();
          $("#splash").css("height", h);
          $.mobile.loading('show');
          $('#bodyDiv').css('visibility', 'visible').hide().fadeIn('slow');
          $.mobile.loading('hide');
          $("#more").on({
            popupbeforeposition: function() {
              h = $(window).height();
              return $("#more").css("height", h);
            }
          });
          $("#moreModule").on({
            popupbeforeposition: function() {
              h = $(window).height();
              return $("#moreModule").css("height", h);
            }
          });
          _this.renderModuleLinks();
          return window.setTimeout(function() {
            return $.mobile.changePage("#home");
          }, 1750);
        });
      }

      OpenEpiShell.prototype.renderModuleLinks = function() {
        var html, mods, moduleSelector, that, tmpl;
        info("Loaded all modules successfully...");
        moduleSelector = $("#moduleSelector");
        tmpl = templates['display-moduleList'];
        mods = {
          modules: modules
        };
        html = $.jade(tmpl, mods);
        moduleSelector.append(html);
        that = this;
        $('.moduleItem a').each(function() {
          var item, moduleName,
            _this = this;
          item = $(this);
          moduleName = item.attr('data-moduleName');
          return item.bind('click', function() {
            return that.moduleLoad(moduleName);
          });
        });
        this.templateModulesListRender();
        return this.historyListRender();
      };

      OpenEpiShell.prototype.exec = function(moduleName, args, addToHistory) {
        var callback, module,
          _this = this;
        module = this.getModule(moduleName);
        callback = function(result) {
          console.log(result);
          if (addToHistory) {
            return _this.historyAdd(module, result.model, result);
          }
        };
        error = function(err) {
          console.log('Error:');
          return console.log(err);
        };
        if (!(module != null)) {
          error("Could not find module named: " + moduleName);
          return;
        }
        return module.calculate(args, callback, error);
      };

      OpenEpiShell.prototype.moduleLoad = function(moduleName, formValue) {
        var module, moduleModel, modulePage,
          _this = this;
        modulePage = $("#module");
        module = this.getModule(moduleName);
        if (!(module != null)) {
          return;
        }
        moduleModel = this.getModuleModel(module);
        if (!(moduleModel != null)) {
          return;
        }
        $("#resultsMissing").show();
        $("#resultsPane").hide();
        return modulePage.find('.fields').each(function(i, el) {
          var args, authorCredit, authorType, authors, fieldContainer, form, formModel, model, _ref;
          fieldContainer = $(el);
          fieldContainer.empty();
          $("#moduleTitle").text(module.title);
          model = new moduleModel;
          args = {
            model: model
          };
          formModel = new Backbone.Form(args);
          if (formValue != null) {
            formModel.model.attributes = formValue;
          }
          form = formModel.render();
          fieldContainer.html(form.el);
          modulePage.find('.calculate').each(function(i, el) {
            var command;
            command = $(el);
            return command.unbind('click').bind('click', function() {
              formValue = form.getValue();
              $.mobile.loading('show');
              return module.calculate(formValue, function(result) {
                _this.showResult(result, module.render);
                _this.historyAdd(module, formValue, result);
                return $.mobile.loading('hide');
              }, _this.error);
            });
          });
          modulePage.find('.templateSave').each(function(i, el) {
            var command;
            command = $(el);
            return command.unbind('click').bind('click', function() {
              var stp;
              formValue = form.getValue();
              _this.templatesAdd(module, formValue);
              stp = $('#saveTemplatePopup');
              return stp.popup('close');
            });
          });
          $("#moduleSummary").html(module.summary);
          $("#moduleDescription").html(module.description);
          authors = $("<div style='padding-left:5px'></div>");
          _ref = module.authors;
          for (authorType in _ref) {
            authorCredit = _ref[authorType];
            authors.append("<div style='color:#333333'><b style='color:#555555'>" + authorType + ":</b> " + authorCredit + "</div>");
          }
          $("#moduleAuthors").append(authors);
          $("#moduleInfo").collapsible();
          $.mobile.changePage("#module");
          modulePage.trigger('create');
          return $('#history').trigger('create');
        });
      };

      OpenEpiShell.prototype.getModule = function(moduleName) {
        var module;
        module = modules[moduleName];
        if (!(module != null)) {
          error("Could not find module " + moduleName);
          return null;
        }
        return module;
      };

      OpenEpiShell.prototype.getModuleModel = function(module) {
        var moduleModel;
        moduleModel = this.moduleModels[module.name];
        if (!(moduleModel != null)) {
          moduleModel = Backbone.Model.extend({
            schema: module.inputFields
          });
          this.moduleModels[module.name] = moduleModel;
        }
        return moduleModel;
      };

      OpenEpiShell.prototype.showResult = function(result, renderFn) {
        var processing, resultData, resultPage;
        resultPage = $('#results');
        resultData = $('#resultData');
        processing = $('#processing');
        resultData.hide();
        processing.show();
        $("#resultsMissing").hide();
        $("#resultsPane").show();
        $.mobile.changePage('#results');
        return window.setTimeout(function() {
          return processing.fadeOut().promise().done(function() {
            var completeRender;
            completeRender = function(html) {
              resultData.empty();
              resultData.append(html);
              return resultData.fadeIn(200);
            };
            return renderFn(result, completeRender, error);
          });
        }, 200);
      };

      OpenEpiShell.prototype.getTemplatesModules = function() {
        var templateModules;
        if (window.localStorage.getItem('templateModules') === null) {
          window.localStorage.setItem('templateModules', JSON.stringify([]));
        }
        templateModules = JSON.parse(window.localStorage.getItem('templateModules'));
        return templateModules;
      };

      OpenEpiShell.prototype.templatesAdd = function(module, formValue) {
        var templateModule, templateName;
        templateName = $('#templateName').val();
        templateModule = {
          templateName: templateName,
          moduleName: module.name,
          formValue: formValue,
          dateTime: new Date().format()
        };
        this.templateModules.unshift(templateModule);
        window.localStorage.setItem('templateModules', JSON.stringify(this.templateModules));
        success("Template " + templateName + " added");
        return this.templateModulesListRender();
      };

      OpenEpiShell.prototype.templateModulesListRender = function() {
        var html, items, modObjs, mods, templateModuleSelector, tmpl, tmplItems,
          _this = this;
        templateModuleSelector = $("#templateModules");
        if (this.templatesListRendered === false) {
          tmpl = templates['display-templatesList'];
          html = $.jade(tmpl, {});
          templateModuleSelector.append(html);
        }
        $('#templateModulesList').empty();
        modObjs = {};
        $.extend(true, modObjs, this.templateModules);
        mods = {
          templateModules: modObjs
        };
        log(mods);
        _.each(mods.templateModules, function(item) {
          return item.module = _this.getModule(item.moduleName);
        });
        tmplItems = templates['display-templatesListItem'];
        items = $.jade(tmplItems, mods);
        $('#templateModulesList').append(items);
        $('.templateModule').children('a').each(function(i, el) {
          var formValue, index, item, moduleName, templateModule;
          item = $(el);
          index = Number(item.attr('data-index'));
          templateModule = _this.templateModules[index];
          moduleName = templateModule.moduleName;
          formValue = templateModule.formValue;
          return item.bind('click', function() {
            return _this.moduleLoad(moduleName, formValue);
          });
        });
        if (this.templatesListRendered) {
          try {
            $('#templateModulesList').listview('refresh');
          } catch (ex) {
            console.log("Error:");
            console.log(ex);
          }
        } else {
          this.templatesListRendered = true;
        }
      };

      OpenEpiShell.prototype.getHistoryList = function() {
        var histList;
        if (window.localStorage.getItem('historyList') === null) {
          window.localStorage.setItem('historyList', JSON.stringify([]));
        }
        histList = JSON.parse(window.localStorage.getItem('historyList'));
        return histList;
      };

      OpenEpiShell.prototype.historyAdd = function(module, formValue, result) {
        var historyItem;
        historyItem = {
          moduleName: module.name,
          result: {
            model: formValue,
            output: result.output
          },
          dateTime: new Date().format()
        };
        this.historyList.unshift(historyItem);
        window.localStorage.setItem('historyList', JSON.stringify(this.historyList));
        return this.historyListRender();
      };

      OpenEpiShell.prototype.historyListRender = function() {
        var historyItemsSelector, html, items, modObjs, mods, tmpl, tmplItems,
          _this = this;
        historyItemsSelector = $("#historyListContainer");
        if (this.historyListRendered === false) {
          tmpl = templates['display-historyList'];
          html = $.jade(tmpl, {});
          historyItemsSelector.append(html);
        }
        $('#historyList').empty();
        modObjs = {};
        $.extend(true, modObjs, this.historyList);
        mods = {
          historyList: modObjs
        };
        log(mods);
        _.each(mods.historyList, function(item) {
          var module;
          module = _this.getModule(item.moduleName);
          item.module = module;
          module.renderHistoryLabel(item.result, function(result) {
            return item.label = result;
          });
          return module.renderHistoryResult(item.result, function(result) {
            return item.result = result;
          });
        });
        tmplItems = templates['display-historyListItem'];
        items = $.jade(tmplItems, mods);
        $('#historyList').append(items);
        $('.historyItem').children('a').each(function(i, el) {
          var formValue, historyItem, index, item, moduleName;
          item = $(el);
          index = Number(item.attr('data-index'));
          historyItem = _this.historyList[index];
          moduleName = historyItem.moduleName;
          formValue = historyItem.result.model;
          return item.bind('click', function() {
            return _this.moduleLoad(moduleName, formValue);
          });
        });
        try {
          if (this.historyListRendered === true) {
            $('#historyList').listview('refresh');
          } else {
            $('#historyList').listview('refresh');
          }
        } catch (ex) {
          console.log("Error listviewifying the list:");
          console.log(ex);
        }
        return this.historyListRendered = true;
      };

      return OpenEpiShell;

    })();
    return OpenEpiShell;
  });

}).call(this);
