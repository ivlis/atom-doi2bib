module.exports = (isbn, onSuccess, onError) ->
  url = "http://php.chimbori.com/_php/isbn/isbn-bibtex"

  options =
      url: url
      method: 'POST'
      headers:
        'cache-control': 'no-cache'
        'content-type': 'multipart/form-data'
      formData:
        isbn: isbn

  request = require 'request'
  request options, (error, response, body) ->
    if error
      onError("Request error")
    else if response.statusCode == 200
      if body.match /^@comment\{Error.*/
        onError('ISBN not found')
      else
        bibitem = body
        onSuccess(bibitem.trim())
    else
      onError("Server returned an error")
      console.error response.statusCode
