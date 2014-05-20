cronJob = require('cron').CronJob
exec = require('child_process').exec

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 18 * * 1,2,3,4,5', () ->
    robot.send {room: '#general'}, '夕会です'
  ).start()

  new cronJob('0 0 13 * * 1,2,3,4,5', () ->
    exec('curl -s http://damp-meadow-3338.herokuapp.com/', (err, stdout, stderr) ->
      robot.send {room: '#general'}, "お昼です。今日は#{stdout}です。"
    )
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

