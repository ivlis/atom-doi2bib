{CompositeDisposable} = require 'atom'

module.exports = Doi2bib =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
            'doi2bib:convert': => @convert()

  deactivate: ->
    @subscriptions.dispose()



  convert: ->
    if editor = atom.workspace.getActiveTextEditor()

      notifications = atom.notifications
      doi = editor.getSelectedText()

      showError = (error) ->
        notifications.addError error

      insertBibitem = (bibitem) ->
        editor.insertText bibitem

      f = null

      if doi.match(/^10\..*/) and not doi.match(/\s+/)
        f = require './dxdoiorg'
      else if doi.match(/^\d{4}\.\d{4,5}$/) or doi.match(/^\S+\/\d{7}$/)
        f = require './arxivorg'
      else if doi.match(/\d{10}/) or doi.match(/\d{13}/)
        f = require './isbn'

      if f is null
        showError "Cannot find a valid id in the selection"
      else
        f doi, insertBibitem, showError
