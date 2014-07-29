# Description
#   A hubot script that does the things
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
parseString = require('xml2js').parseString
getRawBody = require('raw-body')
_ = require 'underscore'

class Xml
  constructor: (@xml) ->

  methodname: ->
    @xml.methodCall.methodName[0]

  username: ->
    @xml.methodCall.params[0].param[1].value[0].string[0]

  password: ->
    @xml.methodCall.params[0].param[2].value[0].string[0]

  description: ->
    @result ||= perse.call(@)
    @result["description"]

  title: ->
    @result ||= perse.call(@)
    @result["title"]

  categories: ->
    @result ||= perse.call(@)
    result = []
    _.each @result["categories"], (category) ->
      result.push category.string[0]
    result

  members = ->
    @xml.methodCall.params[0].param[3].value[0].struct[0].member

  perse = ->
    result = {}
    _.each members.call(@), (member) =>
      switch member.name[0]
        when 'description'
          result["description"] = member.value[0].string[0]
        when 'title'
          result["title"] = member.value[0].string[0]
        when 'categories'
          result["categories"] = member.value[0].array[0].data[0].value
    result


class Postman
  constructor: (@xml, @robot) ->

  message: ->
    result = []
    result.push @xml.title() if @xml.title()
    result.push @xml.description() if @xml.description()
    result.join("\n")

  deliver: ->
    _.each @xml.categories(), (category) =>
      @robot.send {room: category} , @message()

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/xmlrpc.php", (req, res) ->
    success = (val) ->
      body = """
        <?xml version=\"1.0\"?>
        <methodResponse>
          <params>
            <param>
              <value>#{val}</value>
            </param>
          </params>
        </methodResponse>
        """
      res.writeHead 200, { 'Content-Type': 'text/xml','Content-Length': body.length }
      res.end body

    failure = (val) ->
      body = """
        <?xml version="1.0"?>
        <methodResponse>
          <fault>
            <value>
              <struct>
                <member>
                  <name>faultCode</name>
                  <value><int>#{val}</int></value>
                </member>
                <member>
                  <name>faultString</name>
                  <value><string>Request was not successful.</string></value>
                </member>
              </struct>
            </value>
          </fault>
        </methodResponse>
        """
      res.writeHead 400, { 'Content-Type': 'text/xml','Content-Length': body.length }
      res.end body

    options = {
      length: req.headers['content-length']
      limit: '1mb'
    }

    callback = (err, body) ->
      parseString body, (err, result) ->
        xml = new Xml(result)

        switch xml.methodname()
          when "mt.supportedMethods"
            success("metaWeblog.getRecentPosts")
          when "metaWeblog.getRecentPosts"
            success("<array><data></data></array>")
          when 'metaWeblog.newPost'
            postman = new Postman(xml, robot)
            postman.deliver()
            success('<string>200</string>')
          else
            failure(400)

    getRawBody req, options, callback
