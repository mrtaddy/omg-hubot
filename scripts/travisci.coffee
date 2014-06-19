# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>
class MessageBuilder
  constructor: (payload) ->
    @json = JSON.parse(payload)

  repository: ->
    "#{@json["repository"]["owner_name"]}/#{@json["repository"]["name"]}@#{@json["branch"]}"

  number: ->
    @json["number"]

  author_name: ->
    @json["author_name"]

  build_url: ->
    @json["build_url"]

  step: ->
    if @json["status_message"] == ""
      "Started"
    else
      @json["status_message"]

  text: ->
    "#{this.repository()} - \##{this.number()} #{this.step()} by #{this.author_name()} (#{this.build_url()})"

querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/travisci", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    message = new MessageBuilder(req.body.payload)
    robot.send user, message.text()
    res.end ""
