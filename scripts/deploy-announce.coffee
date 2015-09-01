# Description:
#   Deploy announce to engineers


module.exports = (robot) ->
  engineers = process.env.ENGINEERS
  robot.hear /(.*デプロイします.*)/i, (msg) ->
    message  = engineers.split(/,/).join(' ')
    message += "\n" + msg.message.text
    message += "\n" + 'GoogleAnalyticsへの記入=> https://goo.gl/beOupj (日付切替キー: dt)'
    message += "\n" + 'デプロイはこちらから => https://omg-ci.ohmyglasses.jp:10080'
    msg.send message
