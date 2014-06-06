# Description:
#   Deploy announce to engineers


module.exports = (robot) ->
  engineers = process.env.ENGINEERS.split(/,/)
  robot.hear /(.*デプロイ.*)/i, (msg) ->
    message = engineers.join(' ') + "\n" + msg.match[1]
    msg.send message
