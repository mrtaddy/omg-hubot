cronJob = require('cron').CronJob

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 18 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '夕会です'
  ).start()

  new cronJob('0 0 13 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, 'お昼です'
  ).start()

  new cronJob('0 15 10 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '朝会です'
  ).start()

  new cronJob('0 30 10 * * 4', () ->
    robot.send {room: '#general'}, 'コードレビューです'
  ).start()

  new cronJob('0 30 10 * * 5', () ->
    robot.send {room: '#general'}, 'エンジニア週次です'
  ).start()

