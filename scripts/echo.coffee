# Description:
#   echo

module.exports = (bot) ->
  bot.respond /echo (.*)/, (res) ->
    res.reply res.match[1]
