# Description:
#   Demonstrating Slack Attachments.
#
# Commands:
#   hubot demo-attachment - Demo Attachement

module.exports = (robot) ->
  robot.respond /demo-attachment$/i, (msg) =>
    fields = []
    fields.push
      title: "Field 1: Title"
      value: "Field 1: Value"
      short: true

    fields.push
      title: "Field 2: Title"
      value: "Field 2: Value"
      short: true

    payload =
      message: msg.message
      content:
        text: "Attachement Demo Text"
        fallback: "Fallback Text"
        pretext: "This is Pretext"
        color: "#FF0000"
        fields: fields

    robot.emit 'slack-attachment', payload
