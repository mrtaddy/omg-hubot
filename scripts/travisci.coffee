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
Postman = require "./postman"
module.exports = (robot) ->
  robot.router.post "/#{robot.name}/travisci/:room", (req, res) ->
    try
      postman = Postman.create(req, robot)
      postman.notify()
      res.end "[Travis CI] Sending message"
    catch e
      res.end "[Travis CI] #{e}"
