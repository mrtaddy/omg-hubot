# Description
#   <description of the scripts functionality>
#
cronJob = require('cron').CronJob
_ = require 'underscore'

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 18 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '夕会です'
  ).start()

  new cronJob('0 0 13 * * 1,2,3,4,5', () ->
    shops = [
      {url: "http://tabelog.com/tokyo/A1315/A131501/13083224/", name: "和彩料理やまなか"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13003382/", name: "トラットリア ヨシダ"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13113876/", name: "臚雷亭（ローライテイ）"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13125061/", name: "銭場精肉店"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13117263/", name: "肉寿司 大井町店"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13057393/", name: "いさ美寿司"},
      {url: "http://tabelog.com/tokyo/A1315/A131501/13045985/", name: "豚骨醤油 蕾"}
    ]

    shop = (_.shuffle shops)[0]
    robot.send {room: '#general'}, "お昼です。今日は#{shop.name}(#{shop.url})です。"
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
    robot.send {room: '#seo'}, "SEOチーム朝会(10:15〜)です #{seo_project_hangout_url}"
  ).start()
  new cronJob('0 55 17 * * 1,2,3,4,5', () ->
    robot.send {room: '#seo'}, "SEOチーム夕会(18:00〜)です #{seo_project_hangout_url}"
  ).start()
