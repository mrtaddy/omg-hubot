# Description:
#   Call members of the SEO team, in the random order
#
# Configuration:
#   SEO_MEMBERS
#
# Commands:
#   hubot seo [message] - post the message to all SEO team members
#

members = process.env.SEO_MEMBERS?.split(/\s/) || []
mentions = ->
  ((members.sort -> Math.random() - Math.random()).map (name) -> "@#{name}").join(' ')

module.exports = (robot) ->
  robot.respond /seo\s*(.*)/i, (msg) ->
    msg.send "#{mentions()} #{msg.match[1]}"
