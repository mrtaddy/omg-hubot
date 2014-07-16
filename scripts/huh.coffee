# Description:
#   WTF are you talking about?
#
# Configuration:
#   None
#
# Commands:
#   hubot huh? - show an image of huh?
#

module.exports = (robot) ->
  robot.respond /huh\?\s*(.*)/i, (msg) ->
    request = msg.http('http://api.tiqav.com/search.json').query(q: 'おまえは何を言っているんだ').get()
    request (error, response, body) ->
      unless error
        img = msg.random (JSON.parse body)
        extra = msg.match[1]
        if extra
          msg.send "http://tiqav.com/#{img.id}.#{img.ext}\n#{msg.match[1]}"
        else
          msg.send "http://tiqav.com/#{img.id}.#{img.ext}"
