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

  sendable: ->
    switch true
      when /ReferenceError: omg is not defined/.test(this.error_message())
        false
      when /ReferenceError: Can't find variable: omg/.test(this.error_message())
        false
      when /Uncaught ReferenceError: omg is not defined/.test(this.error_message())
        false
      when /ReferenceError: Can't find variable: \$/.test(this.error_message())
        false
      when /Uncaught ReferenceError: \$ is not defined/.test(this.error_message())
        false
      when /http:\/\/www.noc.west.ntt.co.jp\/deny_url.html/.test(this.file())
        false
      else
        true

  project_name: ->
    @json["error"]["project"]["name"]

  error_message: ->
    @json["error"]["error_message"]

  error_class: ->
    @json["error"]["error_class"]

  file: ->
    @json["error"]["file"]

  line_number: ->
    @json["error"]["line_number"]

  url: ->
    "https://#{process.env.HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@json["error"]["project"]["id"]}/groups/#{@json["error"]["id"]}"

  last_occurred_at: ->
    @json["error"]["last_occurred_at"]

  text: ->
    """
      [#{this.project_name()}] New alert for #{this.project_name()}: #{this.error_class()}
      #{this.error_message()}\n#{this.file()}:#{this.line_number()}
      #{this.url()}\n#{this.last_occurred_at()}
    """


querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/airbrake", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    message = new MessageBuilder(req.body)
    robot.send user, message.text() if message.sendable()
    res.end ""
