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
querystring = require('querystring')

class MessageBuilder
  constructor: (req) ->
    @query = querystring.parse(req._parsedUrl.query)
    @json = JSON.parse(req.body.payload)

  room = ->
    @query.room || ""

  repository = ->
    "#{@json["repository"]["owner_name"]}/#{@json["repository"]["name"]}@#{@json["branch"]}"

  number = ->
    @json["number"]

  author_name = ->
    @json["author_name"]

  commit = ->
    @json["commit"].substr(0, 7)

  build_url = ->
    @json["build_url"]

  compare_url = ->
    @json["compare_url"]

  step = ->
    switch @json["status_message"]
      when "Pending"
        "Build started"
      when "Passed", "Fixed","Broken", "Still Failing", "Errored"
        "Build #{@json["status_message"].toLowerCase()}"
      else
        @json["status_message"]

  color = ->
    switch @json["status_message"]
      when "Passed", "Fixed"
        "good"
      when "Broken", "Still Failing", "Errored"
        "danger"
      else
        "#E3E4E6"

  text = ->
    "#{step.call(@)} #{build_url.call(@)}|\##{number.call(@)} (#{compare_url.call(@)}|#{commit.call(@)}) of #{repository.call(@)} by #{author_name.call(@)}"

  payload: ->
      message:
        room: room.call(@)
      content:
        text: text.call(@)
        color: color.call(@)
        fallback: text.call(@)
        pretext: ""


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/travisci", (req, res) ->
    message = new MessageBuilder req
    robot.emit 'slack-attachment', message.payload()
    res.end "Travis-CI webhook done."
