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
            doi = editor.getSelectedText()
            url = "http://dx.doi.org/#{doi}"
            console.log url
            options =
                url: url
                headers:
                    Accept: 'text/bibliography; style=bibtex'

            request = require 'request'
            request options, (error, response, body) ->
                if error
                    console.error(error)
                else
                    bibitem = body.replace /},\ /g, "},\n\t"
                    editor.insertText(bibitem)
