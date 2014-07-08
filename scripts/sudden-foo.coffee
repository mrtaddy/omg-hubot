# Description:
#   Declare sudden death or something
#
# Dependencies:
#   "sudden-death": "~0.1.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot 突然の* - declares sudden something
#

#
# Inspired by:
#   https://speakerdeck.com/naoya/kaizen-platform-inc-falsekai-fa-manezimento#31
#
# Similar bots:
#   https://www.npmjs.org/package/hubot-suddendeath
#

SuddenDeath = require 'sudden-death'

module.exports = (robot) ->
  robot.respond /(突然の.*)/i, (msg) ->
    msg.send (new SuddenDeath msg.match[1]).say()
