# Description
#   A hubot script that tells you where to eat
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot restaurant add <name>[; addr: <address>; | tel: <telephone no.>] - 新增餐廳
#   hubot restaurant del <name> - 刪除餐廳
#   hubot restaurant list - 呈現所有餐廳
#   hubot restaurant show <name> - 呈現特定餐廳資訊
#   hubot restaurant update <name>[; addr: <address>; | tel: <telephone no.>] - 更新餐廳資訊
#   hubot where to eat? - 從餐廳列表抽選一家



module.exports = (robot) ->
#  robot.brain.getData
  restaurants = {
    "鴻園",
    "麥當勞",
    "東海",
    "地下室",
    "小南門",
    "義大利麵",
    "韓式",
    "民生炒飯",
    "響家",
    "但仔麵",
    "咖哩豬排",
    "蚌麵",
    "牛肉麵",
    "韓式旁邊的麵",
    "熊師父",
    "熊本熊丼飯",
    "妞妞義大利麵隔壁的麵",
    "好米吉",
    "放山雞",
    "妞妞義大利麵",
    "摩斯",
    "建鴻雞肉飯",
    "市場包子",
    "市場牛肉麵",
    "燒臘飯",
    "鐵板燒",
    "三友拉麵",
    "麵疙瘩",
    "小籠包",
    "部隊鍋",
    "O2",
    "建鴻那的牛肉麵",
  }
#  if robot.brain.get('restaurants') is null
  robot.brain.set 'restaurants', restaurants
#  robot.brain.set 'restaurants', restaurants

  robot.respond /restaurant add ([^;]*)(; addr: ([^;]*))?(; tel: ([^;]*))?/i, (res) ->
    name = res.match[1]
    addr = res.match[3]
    tel = res.match[5]
    restaurant = name: name, addr: addr, tel: tel
    restaurants[name] = restaurant
    robot.brain.set 'restaurants', restaurants
    res.reply "\"#{name}\" added!"

  robot.respond /restaurant del (.*)/i, (res) ->
    name = res.match[1]
    restaurants = robot.brain.get('restaurants') or {}
    if name of restaurants
      delete restaurants[name]
      robot.brain.set 'restaurants', restaurants
      res.reply "\"#{name}\" deleted!"
    else
      res.reply 'No such restaurant.'

  robot.respond /restaurant list/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    all = for name, obj of restaurants
      "#{name}"
    res.reply all.join('\n')

  robot.respond /restaurant show (.*)/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    restaurant = restaurants[res.match[1]]
    if not restaurant
      res.reply 'No such restaurant.'
    else
      res.reply """
                Here it is!
                Name: #{restaurant.name}
                Address: #{restaurant.addr}
                Telephone No.: #{restaurant.tel}
                """

  robot.respond /restaurant update ([^;]*)(; addr: ([^;]*))?(; tel: ([^;]*))?/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    restaurant = restaurants[res.match[1]]
    if not restaurant
      res.reply 'No such restaurant.'
    else
      if res.match[3]
        restaurant.addr = res.match[3]
      if res.match[5]
        restaurant.tel = res.match[5]
      robot.brain.set 'restaurants', restaurants
      res.reply """
                Updated!
                Name: #{restaurant.name}
                Address: #{restaurant.addr}
                Telephone No.: #{restaurant.tel}
                """

  robot.respond /where to eat\??/i, (res) ->
    restaurants = robot.brain.get('restaurants') or {}
    if Object.keys(restaurants).length is 0
      res.reply "Please add restaurants first."
    else
      keys = for temp_key of restaurants
        temp_key
      res.reply(res.random(keys) + ' may be a good choice!')
