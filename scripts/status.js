// Description:
//   status

module.exports = (bot) => {
  bot.respond('status', (res) => {
    res.reply('All systems operational.')
  })
}
