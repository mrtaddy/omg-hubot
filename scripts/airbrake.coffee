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
    @json["error"]["project"]["name"]

  error_id = ->
    @json["error"]["id"]

  error_message = ->
    @json["error"]["error_message"]

  error_class = ->
    @json["error"]["error_class"]

  file = ->
    "#{@json["error"]["file"]}:#{@json["error"]["line_number"]}"

  url = ->
    "https://#{process.env.HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@json["error"]["project"]["id"]}/groups/#{@json["error"]["id"]}"

  last_occurred_at = ->
    @json["error"]["last_occurred_at"]

  payload: ->
    message:
      room: room.call(@)
    content:
      pretext: "[#{project_name.call(@)}] #{url.call(@)}|\##{error_id.call(@)} New alert for #{project_name.call(@)}: #{error_class.call(@)}"
      text: error_message.call(@)
      color: "danger"
      fallback: ""
      fields: [
        {title: "File", value: file.call(@)}
        {title: "Last occurred at", value: last_occurred_at.call(@)}
      ]

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/airbrake", (req, res) ->
    message = new MessageBuilder(req)
    robot.emit 'slack-attachment', message.payload()
    res.end "Airbrake webhook done."
