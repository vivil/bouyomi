assert = require 'power-assert'
net = require 'net'
Client = require '../lib/client'

describe 'client test', ->
  TEST_PORT = 150001
  server = {}

  before ->
    server = net.createServer( ->
    ).listen(TEST_PORT)

  after ->
    server.close()

  client = new Client(TEST_PORT)
  it 'should set port with constructor', ->
    assert.equal client.port, TEST_PORT

  it 'can connect to server', ->
    client.connect ->
      server.getConnections (err, count)->
        assert.equal err, null
        assert.equal count, 1

  it 'can send data', ->
    client.read "This is test post"
    server.on 'data', (data) ->
      assert.equal typeof data, 'string'

  it 'can pause client', ->
    client.pause ->
      client.read "This is test post"
      server.on 'data', (data) ->
        if data then throw new Error('cannot pause it')

  it 'can resume client', ->
    client.resume ->
      server.on 'data', (data) ->
        assert.equal typeof data, 'string'
      client.read "This is test post"

  it 'can disconnect to server', ->
    client.disconnect ->
      server.getConnections (err, count)->
        assert.equal err, null
        assert.equal count, 1

