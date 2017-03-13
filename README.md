# ram-bot

<img src="https://avatars2.githubusercontent.com/u/15848234?v=3&s=75" />

Half animal, half machine.

## scripts

- [hubot-ramda-docs](https://github.com/raine/hubot-ramda-docs)
- [hubot-eval-js](https://github.com/raine/hubot-eval-js)

## setup

### prerequisites

- Get a [Personal Access Token](https://developer.gitter.im/apps) for Gitter

--

```sh
$ git clone git@github.com:raine/ram-bot.git
$ cd ram-bot
$ npm install

$ HUBOT_NAME=<github-username> \
  HUBOT_GITTER2_TOKEN=<token> \
    ./bin/hubot [-a gitter2]
```

Token and `-a gitter2` can be omitted to run the bot in developer console
mode.
