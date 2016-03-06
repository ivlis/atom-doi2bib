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
        notifications = atom.notifications

        if editor = atom.workspace.getActiveTextEditor()
            doi = editor.getSelectedText()
            
            # TODO: Make the matches more correct
            if not doi.match(/^10\..*/) or doi.match(/.*\s.*/)
                notifications.addError("Selected text does not seem like a DOI")
                return null

            url = "http://dx.doi.org/#{doi}"
            options =
                url: url
                headers:
                    Accept: 'text/bibliography; style=bibtex'

            request = require 'request'
            request options, (error, response, body) ->
                if error
                    console.error(error)
                else if response.statusCode == 404
                    notifications.addError("DOI cannot be found on server")
                else if response.statusCode == 200
                    bibitem = body.replace /},\ /g, "},\n\t"
                    editor.insertText(bibitem)
                else
                    notifications.addError("Server returned an error")
                    console.console.error response.statusCode
