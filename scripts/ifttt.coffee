# Description
#   A hubot script that does the things
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
Deserializer = require '../node_modules/xmlrpc/lib/deserializer'
Serializer = require '../node_modules/xmlrpc/lib/serializer'
_ = require 'underscore'

class Postman
  constructor: (params, @robot) ->
    @struct = params[3]

  message: ->
    result = []
    result.push @struct.title if @struct.title
    result.push @struct.description if @struct.description
    result.join("\n")

  deliver: ->
    _.each @struct.categories, (category) =>
      @robot.send {room: category} , @message()

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/xmlrpc.php", (req, res) ->

    success = (value) ->
      body = Serializer.serializeMethodResponse(value)
      res.writeHead 200, { 'Content-Type': 'text/xml','Content-Length': body.length }
      res.end body

    failure = (value) ->
      xml = struct: {
        member: { name: "faultCode", value: { int: value } }
        member: { name: "faultString", value: { string: "Request was not successful." } }
      }
      body = Serializer.serializeFault(xml)
      res.writeHead 404, { 'Content-Type': 'text/xml','Content-Length': body.length }
      res.end body

    deserializer = new Deserializer()
    deserializer.deserializeMethodCall req, (err, methodName, params) ->
      if err
        failure("404")
        return

      switch methodName
        when "mt.supportedMethods"
          success("metaWeblog.getRecentPosts")
        when "metaWeblog.getRecentPosts"
          success({array: {data: ""}})
        when "metaWeblog.newPost"
          postman = new Postman(params, robot)
          postman.deliver()
          success("200")
        else
          failure("404")
