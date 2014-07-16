# Description:
#   Call members of the SEO team, in the random order
#
# Dependencies:
#   "underscore": ">= 1.6.0",
#
# Configuration:
#   SEO_MEMBERS
#
# Commands:
#   hubot seo [message] - post the message to all SEO team members
#

_ = require 'underscore'

members = process.env.SEO_MEMBERS?.split(/\s/) || []
mentions = ->
  ((_.shuffle members).map (name) -> "@#{name}").join(' ')

module.exports = (robot) ->
  robot.respond /seo\s*(.*)/i, (msg) ->
    msg.send "#{mentions()} #{msg.match[1]}"
