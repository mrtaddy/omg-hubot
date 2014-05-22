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
_ = require('underscore')

module.exports = (robot) ->
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 */1 * * *', () ->
    if process.env.HUBOT_HPING_URLS
      urls = process.env.HUBOT_HPING_URLS.split(/,/)
    else
      urls = []

    _.each urls, (url) ->
      robot.http(url).head() (err, res) ->
        error = true

        if err
          message = "#{url}: Respons timeout."
        else if res.statusCode != 200
          message = "#{url}: Bad http status #{res.statusCode}."
        else
          message = "#{url}: Alived."
          error = false

        if error
          robot.send {room: process.env.HUBOT_HPING_ROOM}, message
        else
          console.log message

  ).start()
