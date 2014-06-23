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
    @json = req.body

  room = ->
    @query.room || ""

  project_name = ->
    @json["project"]["name"]

  story = ->
    "[#{capitalize.call(@, @json["primary_resources"][0]["story_type"])}] #{@json["primary_resources"][0]["url"]}|\##{@json["primary_resources"][0]["id"]} #{@json["primary_resources"][0]["name"]}"

  state = ->
    @json["highlight"]

  owners = ->
    @json["performed_by"]["name"]

  color = ->
    switch @json["highlight"]
      when "started"
        "#e0e2e5"
      when "finished"
        "#244062"
      when "delivered"
        "#f39300"
      when "accepted"
        "#649012"
      when "rejected"
        "#A3243D"

  capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice 1

  payload: ->
      message:
        room: room.call(@)
      content:
        pretext: story.call(@)
        text: project_name.call(@)
        color: color.call(@)
        fallback: ""
        fields: [
          {title: "State", value: capitalize.call(@, state.call(@)), short: true}
          {title: "Owners", value: capitalize.call(@, owners.call(@)), short: true}
        ]


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/pivotaltracker", (req, res) ->
    message = new MessageBuilder req
    robot.emit 'slack-attachment', message.payload()
    res.end "PivotalTracker notify done."
