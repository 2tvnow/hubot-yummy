module.exports = (robot) ->

   robot.hear /.*=.=.*/, (msg) ->
     msg.reply "(＞x＜)"

   robot.hear /.*0.0.*/, (msg) ->
     msg.reply "o(〒﹏〒)o"

   robot.hear /.*-.-.*/, (msg) ->
     msg.reply "(￣▽￣)"

   robot.hear /.*Q.Q.*/, (msg) ->
     msg.reply "＠・ω・＠"

#   robot.hear /.*yo.*/, (msg) ->
#     msg.send "UL請客~"
#
#   robot.hear /.*ㄟ.*/, (msg) ->
#     msg.emote "UL喝水!"