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
    robot.send {room: '#general'}, "お昼です。今日は#{shop.name}( #{shop.url} )です。"
  ).start()

  # For SEO Renewal project
  seo_project_hangout_url = process.env.SEO_PROJECT_HANGOUT_URL
  new cronJob('0 10 10 * * 1,2,3,4,5', () ->
    robot.send {room: '#seo'}, "SEOチーム朝会(10:15〜)です #{seo_project_hangout_url}"
  ).start()
  new cronJob('0 55 17 * * 1,2,3,4,5', () ->
    robot.send {room: '#seo'}, "SEOチーム夕会(18:00〜)です #{seo_project_hangout_url}"
  ).start()
