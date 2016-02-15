chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

Robot       = require 'hubot/src/robot'
TextMessage = require('hubot/src/message').TextMessage

describe 'factoids', ->
  robot = {}
  user = {}
  adapter = {}
  spies = {}

  beforeEach (done) ->
    # Create new robot, with http, using mock adapter
    robot = new Robot null, 'mock-adapter', false

    robot.adapter.on 'connected', =>
      spies.hear = sinon.spy(robot, 'hear')
      spies.respond = sinon.spy(robot, 'respond')

      require('../src/factoids')(robot)

      user = robot.brain.userForId '1', {
        name: 'user'
        room: '#test'
      }

      adapter = robot.adapter

    robot.run()

    done()

  afterEach ->
    robot.shutdown()

  describe 'listeners', ->
    it 'registered hear !factoid', ->
      expect(spies.hear).to.have.been.calledWith(/^[!]([\w\s-]{2,}\w)( @.+)?/i)

    it 'registered respond learn', ->
      expect(spies.respond).to.have.been.calledWith(/learn (.{3,}) = ([^@].+)/i)

    it 'registered respond learn substitution', ->
      expect(spies.respond).to.have.been.calledWith(/learn (.{3,}) =~ s\/(.+)\/(.+)\/(.*)/i)

    it 'registered respond forget', ->
      expect(spies.respond).to.have.been.calledWith(/forget (.{3,})/i)

    it 'registered respond remember', ->
      expect(spies.respond).to.have.been.calledWith(/remember (.{3,})/i)

    it 'registered respond factoids', ->
      expect(spies.respond).to.have.been.calledWith(/factoids?/i)

    it 'registered respond search', ->
      expect(spies.respond).to.have.been.calledWith(/search (.{3,})/i)

    it 'registered respond alias', ->
      expect(spies.respond).to.have.been.calledWith(/alias (.{3,}) = (.{3,})/i)

    it 'registered respond drop', ->
      expect(spies.respond).to.have.been.calledWith(/drop (.{3,})/i)

  it 'responds to learn', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, foo is now bar/
      done()

    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

  it 'responds to !factoid', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).to.match /user: bar/
      done()

    adapter.receive(new TextMessage user, '!foo')

  it 'responds to !factoid @mention', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).to.match /@user2: bar/
      done()

    adapter.receive(new TextMessage user, '!foo @user2')

  it 'responds to learn substitution', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, foo is now qux/
      done()

    adapter.receive(new TextMessage user, 'hubot: learn foo =~ s/bar/qux/i')

  it 'responds to forget', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, forgot foo/
      done()

    adapter.receive(new TextMessage user, 'hubot: forget foo')

  it 'responds to remember', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')
    adapter.receive(new TextMessage user, 'hubot: forget foo')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, foo is bar/
      done()

    adapter.receive(new TextMessage user, 'hubot: remember foo')

  it 'responds to factoids', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /http:\/\/not-yet-set\/.*\/factoids/
      done()

    adapter.receive(new TextMessage user, 'hubot: factoids')

  it 'responds to search', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foobar = baz')
    adapter.receive(new TextMessage user, 'hubot: learn barbaz = foo')
    adapter.receive(new TextMessage user, 'hubot: learn qix = bar')
    adapter.receive(new TextMessage user, 'hubot: learn qux = baz')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /.* the following factoids: .*!foobar/
      expect(strings[0]).to.match /.* the following factoids: .*!barbaz/
      expect(strings[0]).to.match /.* the following factoids: .*!qix/
      expect(strings[0]).not.to.match /.* the following factoids: .*!qux/
      done()

    adapter.receive(new TextMessage user, 'hubot: search bar')

  it 'responds to alias', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, aliased baz to foo/
      done()

    adapter.receive(new TextMessage user, 'hubot: alias baz = foo')

  it 'responds to drop', (done) ->
    adapter.receive(new TextMessage user, 'hubot: learn foo = bar')

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /OK, foo has been dropped/
      done()

    adapter.receive(new TextMessage user, 'hubot: drop foo')

  it 'responds to invalid !factoid', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /Not a factoid/
      done()

    adapter.receive(new TextMessage user, '!foo')

  it 'responds to invalid learn substitution', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /Not a factoid/
      done()

    adapter.receive(new TextMessage user, 'hubot: learn foo =~ s/bar/baz/gi')

  it 'responds to invalid forget', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /Not a factoid/
      done()

    adapter.receive(new TextMessage user, 'hubot: forget foo')

  it 'responds to invalid drop', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).to.match /Not a factoid/
      done()

    adapter.receive(new TextMessage user, 'hubot: drop foo')

describe 'factoids customization', ->
  robot = {}
  user = {}
  adapter = {}
  spies = {}

  beforeEach (done) ->
    process.env.HUBOT_FACTOID_PREFIX = '?'
    # Create new robot, with http, using mock adapter
    robot = new Robot null, 'mock-adapter', false

    robot.adapter.on 'connected', =>
      spies.hear = sinon.spy(robot, 'hear')
      spies.respond = sinon.spy(robot, 'respond')

      require('../src/factoids')(robot)

      user = robot.brain.userForId '1', {
        name: 'user'
        room: '#test'
      }

      adapter = robot.adapter

    robot.run()

    done()

  afterEach ->
    robot.shutdown()

  it 'can override prefix', ->
    expect(spies.hear).to.have.been.calledWith(/^[?]([\w\s-]{2,}\w)( @.+)?/i)
