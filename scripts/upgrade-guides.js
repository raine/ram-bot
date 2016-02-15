// Description:
//   upgrade guides

const { mdLink } = require('hubot-ramda-docs/lib/markdown')
const UPGRADE_GUIDES_ISSUES_URL = 'https://github.com/ramda/ramda/issues?q=is%3Aissue+label%3A%22upgrade+guide%22'

module.exports = (bot) =>
  bot.respond(/upgrade guides/, (res) =>
    res.reply(mdLink('Upgrade guides', UPGRADE_GUIDES_ISSUES_URL)))
