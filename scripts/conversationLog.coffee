moment = require('moment')
client = require('./redisLogIn').getClient()

module.exports = (robot) ->
  robot.respond /initialize database/, (res) ->
    conversation = robot.brain.get('conversation') or []
    i = 0
    loop
      if conversation[i].room is res.message.room
        conversation[i..i] = []
      else
        i++
      if i >= conversation.length
        break
    res.reply "chat history initialized!"

#  robot.respond /user list/, (res) ->
#    allUser = robot.brain.users()
#    res.send JSON.stringify allUser

  robot.hear /.*/, (res) ->
#    use hubot brain
    conversation = robot.brain.get('conversation') or []
    name = res.message.user.name
    text = res.message.text
    room = res.message.room
    nowTime = new Date().getTime()
    time = moment(nowTime).zone('+0800').format('YYYY-MM-DD HH:mm')
    message = name: name, text: text, time: time, room: room

    conversation.push(message)
    robot.brain.set 'conversation', conversation

#    use redis
    key = "#{name}:log:#{room}"
    client.incr "#{key}:counter", (err, reply) ->
      if err
        throw err
      else
        counter = "#{reply}"
        client.hmset "#{key}:#{counter}", "message", text, "time", time, (err, resss) ->
          if err
            throw err
          else
            word = text.replace(/[\s\(\)\<\>\&\|\"\'\;\`]/g, "");
            cp = require "child_process"
            cp.exec "ruby -E utf-8 ./wordSegment.rb #{word}", (error, stdout, stderr) ->
              if error
                res.send stderr
              else
                client.hset "#{key}:#{counter}", "segment", stdout


  robot.respond /log$/i, (res) ->
    conversation = robot.brain.get('conversation') or []

    logs = ""

    for log in conversation when log.room is res.message.room
      test = JSON.stringify(log)
      logs = "#{logs} #{test}\n"

    res.send logs

  robot.respond /log count (.*)/i, (res) ->
    conversation = robot.brain.get('conversation') or []
    name = res.match[1]
    logs = ""
    count = 0

    for log in conversation when log.room is res.message.room and log.name is name
      test = JSON.stringify(log)
      logs = "#{logs} #{test}\n"
      count++

    res.send logs + "count: " + count

  robot.respond /count (.*)/i, (res) ->
    conversation = robot.brain.get('conversation') or []
    name = res.match[1]
    count = 0

    for log in conversation when log.room is res.message.room and log.name is name
      count++

    res.send name + ": " + count

  robot.respond /count$/i, (res) ->
    conversation = robot.brain.get('conversation') or []
    counts = {}

    for log in conversation when log.room is res.message.room
      if !counts[log.name]
        counts[log.name] = 1
      else
        counts[log.name]++

    res.send JSON.stringify(counts)

  robot.respond /segment (.*)/i, (res) ->
    name = res.match[1]
    client.get "#{name}:log:#{res.message.room}:counter", (err, reply) ->
      count = "#{reply}"-1
      client.hget "#{name}:log:#{res.message.room}:#{count}", "segment", (err, rep) ->
        res.send "#{rep}"
#    conversation = robot.brain.get('conversation') or []
#    name = res.match[1]
#    word = ""
#
#    for log in conversation when log.room is res.message.room and log.name is name
#      word = "#{word} #{log.text}"
#    word = word.replace(/[\s\(\)\<\>\&\|\"\'\;\`]/g, "");
#
#    cp = require "child_process"
#    cp.exec "ruby -E utf-8 ./wordSegment.rb #{word}", (error, stdout, stderr) ->
#      if error
#        res.send stderr
#        cp.exit()
#      else
#        res.send stdout
#        cp.exit()



