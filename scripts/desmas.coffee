# Description:
#   Death! or Math!, a.k.a. Nodame bot
#
# Configuration:
#   None
#

class Desmas
  constructor: (@msg) ->

  find: (keyword, callback) ->
    @request(keyword) (error, response, body) =>
      return if error

      img = @pickup (@parse body)
      if img
        callback img

  request: (keyword) ->
    url = 'http://ajax.googleapis.com/ajax/services/search/images'
    @msg.http(url).query(@query(keyword)).get()

  query: (keyword) ->
    v: '1.0'
    q: keyword
    rsz: '8'
    safe: 'active'

  parse: (body) ->
    try
      json = JSON.parse body
      json.responseData?.results

  pickup: (images) ->
    if images?.length > 0
      (@msg.random images).unescapedUrl

desmas = (msg, keyword) ->
  new Desmas(msg).find keyword, (url) ->
    msg.send url

module.exports = (robot) ->
  robot.hear /(death|デス|デスよ)\s*[!！]*$/i, (msg) ->
    desmas msg, 'death metal'

  robot.hear /(math|マス|マスよ)\s*[!！]*$/i, (msg) ->
    desmas msg, 'mathematics'
