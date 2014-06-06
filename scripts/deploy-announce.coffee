# Description:
#   Deploy announce to engineers


module.exports = (robot) ->
  engineers = process.env.ENGINEERS
  robot.hear /(.*デプロイ.*)/i, (msg) ->
    message = engineers.split(/,/).join(' ') + "\n" + msg.match[1]
    msg.send message
