net = require "net"

class Client
  constructor: (port=50001)->
    @port = port

  connect: (cb)->
    if @client then return cb()

    @client = net.connect(
      port: @port
    , ->
      @paused = false
      if cb then cb()
    )

    @client.on "data", (data) ->
      return

    @client.on "finish", ->
      @client = null
      return

    @client.on 'error', (err) ->
      return

  disconnect: (cb)->
    if @client then @client.end()
    if cb then cb()

  pause: (cb) ->
    if @client and not @paused
      @client.pause()
      @paused = true
    if cb then cb()

  resume: (cb) ->
    if @client and @paused
      @client.resume()
      @paused = false
    if cb then cb()


  read: (message, option, cb) ->
    if @client and message
      speed = if(option?.speed) then parseInt(option.speed, 16) else null
      tone = if(option?.tone) then parseInt(option.tone, 16) else null
      volume = if(option?.volume) then parseInt(option.volume, 16) else null
      voice = if(option?.voice) then parseInt(option.voice, 16) else null
      code = if(option?.code) then parseInt(option.code, 16) else null

      command = _createCommand.call @, message, speed, tone, volume, voice, code
      @client.write command, cb

  ###
  ## command: 0...read it(defined only 0)
  ## speed: speed for read(50..300 or -1)
  ## tone: tone for read(50..200 or -1)
  ## volume: volume for read(0..100 or -1)
  ## voice: voice type(0..8 or -1 or 10001...)
  ## code: message's Character Code(0:Utf8, 1:Unicode, 2:Shift-JIS)
  ###
  _createCommand = (message, command=0x0001, speed=0xFFFF, tone=0xFFFF, volume=0xFFFF, voice=0x0000, code=0o0) ->
    messageBuffer = new Buffer(message)
    buffer = new Buffer(15 + messageBuffer.length)
    buffer.writeUInt16LE(command, 0)
    buffer.writeUInt16LE(speed, 2)
    buffer.writeUInt16LE(tone, 4)
    buffer.writeUInt16LE(volume, 6)
    buffer.writeUInt16LE(voice, 8)
    buffer.writeUInt8(code, 10)
    buffer.writeUInt32LE(messageBuffer.length, 11)
    messageBuffer.copy(buffer, 15, 0, messageBuffer.length)
    return buffer

module.exports = Client
