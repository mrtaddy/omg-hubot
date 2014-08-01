# Description
#   kenchankunsan
#
# Commands:
#   hubot kenchankunsan me - generates kenchankunsan
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]

module.exports = (robot) ->
  robot.respond /kenchankunsan(?: me)?/i, (msg) ->
    msg.http("http://kenchankunsan.herokuapp.com/.txt")
      .get() (err, res, body) ->
        unless err
          msg.send body.replace(/\n/g, "")
