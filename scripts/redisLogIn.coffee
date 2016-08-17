Url   = require "url"
Redis = require "redis"

Client=null

module.exports.getClient = () ->
  if Client
    console.log(" Client has already existed")
    return Client

  redisUrl = if process.env.REDISTOGO_URL?
    redisUrlEnv = "REDISTOGO_URL"
    process.env.REDISTOGO_URL
  else if process.env.REDISCLOUD_URL?
    redisUrlEnv = "REDISCLOUD_URL"
    process.env.REDISCLOUD_URL
  else if process.env.BOXEN_REDIS_URL?
    redisUrlEnv = "BOXEN_REDIS_URL"
    process.env.BOXEN_REDIS_URL
  else if process.env.REDIS_URL?
    redisUrlEnv = "REDIS_URL"
    process.env.REDIS_URL
  else
    'redis://localhost:6379'

  if redisUrlEnv?
    console.log "hubot-redis-brain: Discovered redis from #{redisUrlEnv} environment variable"
  else
    console.log "hubot-redis-brain: Using default redis on localhost:6379"


  info   = Url.parse redisUrl, true
  client = if info.auth then Redis.createClient(info.port, info.hostname, {no_ready_check: true}) else Redis.createClient(info.port, info.hostname)

  if info.auth
    client.auth info.auth.split(":")[1], (err) ->
      if err
        console.log "hubot-redis-brain: Failed to authenticate to Redis"
      else
        console.log "hubot-redis-brain: Successfully authenticated to Redis"

  client.on "connect", ->
    console.log "hubot-redis-brain: Successfully connected to Redis"

  Client = client
  return Client