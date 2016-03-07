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

            if f is null
                showError "Cannot find a valid id in the selection"
            else
                f doi, insertBibitem, showError
