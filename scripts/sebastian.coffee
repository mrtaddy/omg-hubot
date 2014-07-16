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

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 18 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '夕会です'
  ).start()

  new cronJob('0 0 13 * * 1,2,3,4,5', () ->
    robot.http('http://damp-meadow-3338.herokuapp.com/').get() (err, res, body) ->
      unless err
        robot.send {room: '#general'}, "お昼です。今日は#{body}です。"
  ).start()

  new cronJob('0 15 10 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '朝会です'
  ).start()

  new cronJob('0 30 10 * * 5', () ->
    robot.send {room: '#general'}, 'エンジニア週次です'
  ).start()

  # For SEO Renewal project
  seo_project_hangout_url = process.env.SEO_PROJECT_HANGOUT_URL
  new cronJob('0 10 10 * * 1,2,3,4,5', () ->
    robot.send {room: '#seo'}, "SEOチーム朝会(10:15〜)です #{seo_team_hangout_url}"
  ).start()
  new cronJob('0 55 17 * * 1,2,3,4,5', () ->
    robot.send {room: '#seo'}, "SEOチーム夕会(18:00〜)です #{seo_team_hangout_url}"
  ).start()
