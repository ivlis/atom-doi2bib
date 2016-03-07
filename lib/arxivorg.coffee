module.exports = (arxivId, onSuccess, onError) ->
    url = "http://export.arxiv.org/api/query?id_list=#{arxivId}"
    options =
        url: url

    parseXml = (xml) ->
        {parseString} = require 'xml2js'
        parseString xml, (err, result) ->
            console.dir result
            authors = (author.name[0] for author in result.feed.entry[0].author).join(' and ')
            title = result.feed.entry[0].title[0]
            year = result.feed.entry[0].published[0].match(/^(\d{4})-\d{2}-\d{2}T/)
            bibitem = "
@Unpublished{bib:#{arxivId},\n\t
    author = \"#{authors}\",\n\t
    title = \"#{title}\",\n\t
    year = \"#{year[1]}\",\n\t
    eprint = \"#{arxivId}\",\n\t
    archivePrefix = \"arXiv\"\n
}
            "
            onSuccess(bibitem)

    request = require 'request'
    request options, (error, response, body) ->
        if error
            onError("Request error")
        else if response.statusCode == 404
            onError("arXiv.org id cannot be found on server")
        else if response.statusCode == 200
            xml = body
            parseXml(xml)
        else
            onError("Server returned an error")
            console.error response.statusCode
