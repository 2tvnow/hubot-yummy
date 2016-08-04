module.exports = (robot) ->
  robot.respond /initialize database/, (msg) ->
    msg.reply "initialized!"
    robot.brain.set 'restaurants' ,{}
    robot.brain.set 'conversation' ,[]
    robot.brain.set 'person_name' ,{}