# Description:
#   Deploy announce to engineers


module.exports = (robot) ->
  engineers = process.env.ENGINEERS
  gaURL = process.env.GA_URL
  ciURL = process.env.CI_URL
  robot.hear /(.*デプロイします.*)/i, (msg) ->
    message  = engineers.split(/,/).join(' ')
    message += "\n" + msg.message.text
    message += "\n" + "GoogleAnalyticsへの記入=> #{gaURL} (日付切替キー: dt)"
    message += "\n" + "デプロイはこちらから => #{ciURL}"
    msg.send message
