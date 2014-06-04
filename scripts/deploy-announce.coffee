# Description:
#   Deploy announce to engineers

module.exports = (robot) ->
  engineers = ["fukajun", "kazunari-takahashi", "kei-s", "libkazz", "sanemat"]
  robot.hear /(.*デプロイ.*)/i, (msg) ->
    message = engineers.join(' ') + "\n" + msg.match[1]
    msg.send message
