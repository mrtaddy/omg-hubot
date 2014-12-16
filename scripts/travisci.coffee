# Description
#   A hubot script that notify about build results in Travis CI
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
#   POST /<hubot url>:<hubot port>/travisci/<room>
#
# Notes:
#  http://docs.travis-ci.com/user/notifications/#Webhook-notification
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
# Description
#   A Postman build and send message.
#
class Base
  constructor: (@req, @robot) ->
    @json = JSON.parse(@req.body.payload)

  room: ->
    @req.params.room || ""

  repository_owner_name: ->
    @json.repository.owner_name

  repository_name: ->
    @json.repository.name

  branch: ->
    @json.branch

  number: ->
    @json.number

  author_name: ->
    @json.author_name

  commit: ->
    @json.commit.substr(0, 7)

  build_url: ->
    @json.build_url

  compare_url: ->
    @json.compare_url

  repository: ->
    "#{@repository_owner_name()}/#{@repository_name()}@#{@branch()}"

  status: ->
    switch @json["status_message"]
      when "Pending"
        "started"
      else
        "#{@json["status_message"].toLowerCase()}"

  notice: ->
    "[Travis CI] Build #{@status()} \##{@number()} (#{@commit()}) of #{@repository()} by #{@author_name()} (#{@build_url()})"

  notify: ->
    @robot.send {room: @room()}, @notice()


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/travisci/:room", (req, res) ->
    try
      postman = new Base(req, robot)
      postman.notify()
      res.end "[Travis CI] Sending message"
    catch e
      res.end "[Travis CI] #{e}"
