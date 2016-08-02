# Description
#   A hubot script that tells you who is lucky guy
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot person list - 呈現所有人
#   hubot person add <name>[; years: <years>; | description: <description>]  - 新增人名
#   hubot person del <name> - 刪除人名
#   hubot person show <name> - 呈現特定人名資訊
#   hubot person update <name>[; years: <years>; | description: <description>] - 更新人名資訊
#   hubot who is lucky (guy or person) - 從人名列表抽選一位


module.exports = (robot) ->

  person_name = {
    "瑋瑋",
    "cat",
    "UL",
    "羊",
    "大叔",
    "星星",
    "1+",
    "聖淵",
    "p2",
    "小李姿"
  }

  robot.brain.set 'person_name', person_name

  robot.respond /person add ([^;]*)(; years: ([^;]*))?(; description: ([^;]*))?/i, (res) ->
    name = res.match[1]
    years = res.match[3]
    description = res.match[5]
    person = name: name, years: years, description: description
    person_name[name] = person
    robot.brain.set 'person_name', person_name
    res.reply "\"#{name}\" added!"

  robot.respond /person del (.*)/i, (res) ->
    name = res.match[1]
    person_name = robot.brain.get('person_name') or {}
    if name of person_name
      delete person_name[name]
      robot.brain.set 'person_name', person_name
      res.reply "\"#{name}\" deleted!"
    else
      res.reply 'No such person.'

  robot.respond /person list/i, (res) ->
    person_name = robot.brain.get('person_name') or {}
    all = for name, obj of person_name
      "#{name}"
    res.reply all.join('\n')

  robot.respond /person show (.*)/i, (res) ->
    person_name = robot.brain.get('person_name') or {}
    person = person_name[res.match[1]]
    if not person
      res.reply 'No such person.'
    else
      res.reply """
                Here it is!
                Name: #{person.name}
                years: #{person.years}
                description: #{person.description}
                """

  robot.respond /person update ([^;]*)(; years: ([^;]*))?(; description: ([^;]*))?/i, (res) ->
    person_name = robot.brain.get('person_name') or {}
    restaurant = person_name[res.match[1]]
    if not restaurant
      res.reply 'No such restaurant.'
    else
      if res.match[3]
        person.years = res.match[3]
      if res.match[5]
        person.description = res.match[5]
      robot.brain.set 'person_name', person_name
      res.reply """
                Updated!
                Name: #{person.name}
                years: #{person.years}
                description: #{person.description}
                """

  robot.respond /who is lucky( guy| person)\??/i, (res) ->
    person_name = robot.brain.get('person_name') or {}
    if Object.keys(person_name).length is 0
      res.reply "Please add person_name first."
    else
      keys = for temp_key of person_name
        temp_key
      res.reply(res.random(keys) + ' may be a good choice!')
