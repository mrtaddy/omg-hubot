# Description
#   A hubot script that notify to every time a new error occurs in Airbrake
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_AIRBRAKE_SUBDOMAIN
#
# Commands:
#   None
#
# URLS:
#   POST /<hubot>/airbrake/<room>
#
# Notes:
#  https://help.airbrake.io/kb/integrations/webhooks
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
# Description
#   A Postman build and send message.

HUBOT_AIRBRAKE_SUBDOMAIN = process.env.HUBOT_AIRBRAKE_SUBDOMAIN
_ = require 'underscore'

class Base
  constructor: (req, robot) ->
    @_room = req.params.room
    @json  = req.body
    @robot = robot

  room: ->
    @_room || ""

  url: ->
    "https://#{HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@json["error"]["project"]["id"]}/groups/#{@json["error"]["id"]}"

  error_id: ->
    @json["error"]["id"]

  error_message: ->
    @json["error"]["error_message"]

  file: ->
    "#{@json["error"]["file"]}:#{@json["error"]["line_number"]}"

  last_occurred_at: ->
    @json["error"]["last_occurred_at"]

  environment: ->
    @json["error"]["environment"]

  times_occurred: ->
    @json["error"]["times_occurred"]

  project_name: ->
    @json["error"]["project"]["name"]

  request_url: ->
    @json["error"]["last_notice"]["request_url"]

  backtraces: ->
    @json["error"]["last_notice"]["backtrace"].slice(0, 3)


class Slack extends Base
  pretext: ->
    "[Airbrake] New alert for #{@project_name()} (#{@environment()}) - #{@times_occurred()} occurrences #{@url()}|##{@error_id()}"
  fields: ->
    results = [{title: @error_message()}]
    results.concat(_.map @backtraces(), (backtrace) -> { value: "» #{backtrace.replace(/\[[A-Z_]+\]\//,'')}" })

  text: ->
    if @request_url()
      "Errors on #{@request_url()}"
    else
      ""

  payload: ->
    message:
      room: @room()
    content:
      pretext: @pretext()
      text: @text()
      color: "danger"
      fallback: ""
      fields: @fields()

  deliver: ->
    @robot.emit 'slack-attachment', @payload()


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/airbrake/:room", (req, res) ->
    try
      postman = new Slack(req, robot)
      postman.deliver()
      res.end "[Airbrake] Sending message"
    catch e
      res.end "[Airbrake] #{e}"
