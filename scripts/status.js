// Description:
//   status

module.exports = (bot) => {
  bot.respond(/^(status|ping)$/, (res) => {
    res.reply('All systems operational.')
  })
}
