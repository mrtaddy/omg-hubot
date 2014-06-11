# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

cronJob = require('cron').CronJob
gomiCalJp = require '53cal-jp-scraper'
moment = require 'moment'

city = process.env.GOMICAL_JP_CITY || '1130104'
area = process.env.GOMICAL_JP_AREA || '1130104154'
scraper = gomiCalJp({ city: city, area: area })

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 50 19 * * *', () ->
    day = moment().add('days', 1)
    dayString = day.format('YYYY-MM-DD')
    scraper.whatDate dayString, (err, data) ->
      gomi = if data.result[dayString] then data.result[dayString] + 'です。' else 'ゴミの収集がありません。'
      robot.send {room: '#general'}, day.format('YYYY-MM-DD dddd') + ' ' + 'の[' + data.meta.areaName + ']は' + gomi
  ).start()
