module.exports = (arxivId, onSuccess, onError) ->
  url = "http://export.arxiv.org/api/query?id_list=#{arxivId}"
  options =
      url: url

  xml2bibtex = (error, xml) ->
    # console.dir xml
    if error
      onError "Error parsing xml from arXiv.org"
    else if not xml.feed.entry[0].title
      onError "arXiv.org id does not exist"
    else
      authors = (author.name[0] for author in xml.feed.entry[0].author).join(' and ')
      title = xml.feed.entry[0].title[0]
      year = xml.feed.entry[0].published[0].match(/^(\d{4})-\d{2}-\d{2}T/)
      bibitem = "
      @Unpublished{bib:#{arxivId},\n\t
        author = \"#{authors}\",\n\t
        title = \"#{title}\",\n\t
        year = \"#{year[1]}\",\n\t
        eprint = \"#{arxivId}\",\n\t
        archivePrefix = \"arXiv\"\n
      }"
      onSuccess(bibitem)

  request = require 'request'
  request options, (error, response, body) ->
    if error
      onError "Request error"
    else if response.statusCode != 200
      onError "arXiv.org returned an error"
    else
      {parseString} = require 'xml2js'
      parseString body, xml2bibtex
