# Description
#   <description of the scripts functionality>
#
cronJob = require('cron').CronJob
_ = require 'underscore'
yaml = require 'js-yaml'
fs = require 'fs'

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 13 * * 1,2,3,4,5', () ->
    shops = yaml.safeLoad(fs.readFileSync('shops.yaml'))['shops']
    shop = (_.shuffle shops)[0]
    robot.send {room: 'general'}, "お昼です。今日は#{shop.name}( #{shop.url} )です。"
  ).start()

  # For Backoffice project
  backoffice_hangout_url = process.env.BACKOFFICE_HANGOUT_URL
  new cronJob('0 00 10 * * 1,2,3,4,5', () ->
    robot.send {room: 'backoffice'}, "@channel backoffice チーム朝会です #{backoffice_hangout_url}"
  ).start()
  new cronJob('0 45 17 * * 1,2,3,4,5', () ->
    robot.send {room: 'backoffice'}, "@channel backoffice チーム夕会です #{backoffice_hangout_url}"
  ).start()

  # For EC project
  ec_hangout_url = process.env.EC_HANGOUT_URL
  new cronJob('0 04 10 * * 1,2,3,4,5', () ->
    robot.send {room: 'ec'}, "@channel ec チーム朝会まであと10分です。今日の作業予定を書きましょう！"
  ).start()
  new cronJob('0 14 10 * * 1,2,3,4,5', () ->
    robot.send {room: 'ec'}, "@channel ec チーム朝会です(10:15 〜) #{ec_hangout_url}"
  ).start()
  new cronJob('0 39 17 * * 1,2,3,4,5', () ->
    robot.send {room: 'ec'}, "@channel ec チーム夕会まであと10分です。今日の作業進捗を書きましょう！"
  ).start()
  new cronJob('0 49 17 * * 1,2,3,4,5', () ->
    robot.send {room: 'ec'}, "@channel ec チーム夕会です(17:50 〜) #{ec_hangout_url}"
  ).start()
