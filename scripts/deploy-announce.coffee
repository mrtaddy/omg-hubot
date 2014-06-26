# Description:
#   Deploy announce to engineers


module.exports = (robot) ->
  engineers = process.env.ENGINEERS
  robot.hear /(.*デプロイします.*)/i, (msg) ->
    message = engineers.split(/,/).join(' ') + "\n" + msg.message.text
    msg.send message
