module.exports = (robot) ->
  robot.respond /initialize database/, (msg) ->
    msg.reply "initialized!"
    robot.brain.remove 'restaurants'
    robot.brain.remove 'conversation'
    robot.brain.remove 'person_name'