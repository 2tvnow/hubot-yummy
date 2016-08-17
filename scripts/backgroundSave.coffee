client = require('./redisLogIn').getClient()

module.exports = (robot) ->
  robot.respond /save$/, (res) ->
    res.reply "start background saving"
    client.bgsave  (err, reply) =>
      if err
        throw err
      else
        res.reply "background saving complete"