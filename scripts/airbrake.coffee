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

HUBOT_AIRBRAKE_SUBDOMAIN = process.env.HUBOT_AIRBRAKE_SUBDOMAIN || ""
class Base
  constructor: (@req, @robot) ->
    @json  = @req.body

  room: ->
    @req.params.room || ""

  error_id: ->
    @json.error.id

  error_message: ->
    @json.error.error_message

  error_class: ->
    @json.error.error_class

  environment: ->
    @json.error.environment

  project_name: ->
    @json.error.project.name

  request_url: ->
    @json.error.last_notice.request_url

  project_id: ->
    @json.error.project.id

  backtraces: ->
    @json.error.last_notice.backtrace.slice(0, 3)

  url: ->
    "https://#{HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@project_id()}/groups/#{@error_id()}"

  notice: ->
    "[Airbrake] New alert for #{@project_name()} (#{@environment()}): #{@error_class()} (#{@url()})"

  notify: ->
    @robot.send {room: @room()}, @notice()


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/airbrake/:room", (req, res) ->
    try
      postman = new Base(req, robot)
      postman.notify()
      res.end "[Airbrake] Sending message"
    catch e
      res.end "[Airbrake] #{e}"
