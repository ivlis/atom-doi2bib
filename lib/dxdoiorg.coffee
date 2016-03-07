module.exports = (doi, onSuccess, onError) ->
  url = "http://dx.doi.org/#{doi}"
  options =
      url: url
      headers:
        Accept: 'text/bibliography; style=bibtex'
  bibitem = ''
  request = require 'request'
  request options, (error, response, body) ->
    if error
      onError("Request error")
    else if response.statusCode == 404
      onError("DOI cannot be found on server")
    else if response.statusCode == 200
      bibitem = body.replace /},\ /g, "},\n\t"
      onSuccess(bibitem.trim())
    else
      onError("Server returned an error")
      console.error response.statusCode
