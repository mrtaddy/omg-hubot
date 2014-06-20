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

  commit: ->
    @json["commit"].substr(0, 7)

  build_url: ->
    @json["build_url"]

  step: ->
    switch @json["status_message"]
      when "Pending"
        "✍ Build started"
      when "Passed", "Fixed"
        "☀ Build #{@json["status_message"].toLowerCase()}"
      when "Broken", "Still Failing"
        "☂ Build #{@json["status_message"].toLowerCase()}"
      else
        "☢ Unknown build status"

  text: ->
    """
      #{this.step()} \##{this.number()} (#{this.commit()}) of #{this.repository()} by #{this.author_name()}
      #{this.build_url()}
    """

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
