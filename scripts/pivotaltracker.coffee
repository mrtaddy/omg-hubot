# Description
#   A hubot script that notify about status in Pivotal Tracker
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   POST /<hubot>/pivotaltracker/<room>
#
# Notes:
#    See also:
#    http://www.pivotaltracker.com/help/integrations?version=v5#activity_web_hook
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
class Base
  constructor: (@req, @robot) ->
    @json = @req.body

  room: ->
    @req.params.room || ""

  id: ->
    @json["primary_resources"][0]["id"]

  story_name: ->
    @json["primary_resources"][0]["name"]

  url: ->
    @json["primary_resources"][0]["url"]

  project_name: ->
    @json.project.name

  message: ->
    @json.message

  highlight: ->
    @json.highlight

  short_story_name: ->
    if @story_name().length > 20
      "#{@story_name().substr(0, 20)}..."
    else
      @story_name()

  notice: ->
    "[PivotalTracker] #{@project_name()}: #{@message()} - #{@short_story_name()} (#{@url()})"

  notify: ->
    @robot.send {room: @room()}, @notice()

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/pivotaltracker/:room", (req, res) ->
    try
      postman = new Base(req, robot)
      postman.notify()
      res.end "[PivotalTracker] Sending message"
    catch e
      res.end "[PivotalTracker] #{e}"
