# Description:
#   ping

module.exports = (bot) ->
  bot.respond /ping/, (res) ->
    res.reply 'pong!'
