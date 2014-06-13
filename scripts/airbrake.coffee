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
  constructor: (@json) ->

  project_name: ->
    @json["error"]["project"]["name"]

  error_message: ->
    @json["error"]["error_message"]

  file: ->
    @json["error"]["file"]

  line_number: ->
    @json["error"]["line_number"]

  request_url: ->
    @json["error"]["last_notice"]["request_url"]

  last_occurred_at: ->
    @json["error"]["last_occurred_at"]

  text: ->
    "Alert from #{this.project_name()} [#{this.last_occurred_at()}]\n#{this.request_url()}\n#{this.error_message()}\n#{this.file()}:#{this.line_number()}"

querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/airbrake", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    message = new MessageBuilder(req.body)
    robot.send user, message.text()
    res.end ""
