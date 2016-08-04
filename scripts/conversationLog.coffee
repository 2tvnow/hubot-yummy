moment = require('moment')

module.exports = (robot) ->

  robot.brain.getData

  robot.hear /.*/, (res) ->
    if  robot.brain.get('conversation') is null
      conversation = []
    else
      conversation = robot.brain.get('conversation')
    name =  res.message.user.name
    text = res.message.text
    room = res.message.room
    nowTime = new Date().getTime()
    time = moment(nowTime).zone('+0800').format('YYYY-MM-DD HH:mm')
    message = name: name, text: text, time: time,room: room

    conversation.push(message)
    robot.brain.set 'conversation',conversation
  #      conversation = robot.brain.get('conversation') or []
  #      res.send JSON.stringify(conversation)

  robot.respond /log$/i, (res) ->
    if  robot.brain.get('conversation') is null
      conversation = []
    else
      conversation = robot.brain.get('conversation')

    logs = ""

    for log in conversation when log.room is res.message.room
      test = JSON.stringify(log)
      logs = "#{logs} #{test}\n"

    res.send logs

  robot.respond /log count (.*)/i, (res) ->
    if  robot.brain.get('conversation') is null
      conversation = []
    else
      conversation = robot.brain.get('conversation')
    name = res.match[1]
    logs = ""
    count = 0

    for log in conversation when log.room is res.message.room and log.name is name
      test = JSON.stringify(log)
      logs = "#{logs} #{test}\n"
      count++

    res.send logs+"count: "+count
