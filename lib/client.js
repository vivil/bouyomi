var Client, net;

net = require("net");

Client = (function() {
  var _createCommand;

  function Client(port) {
    if (port == null) {
      port = 50001;
    }
    this.port = port;
  }

  Client.prototype.connect = function(cb) {
    if (this.client) {
      return cb();
    }
    this.client = net.connect({
      port: this.port
    }, function() {
      this.paused = false;
      if (cb) {
        return cb();
      }
    });
    this.client.on("data", function(data) {});
    this.client.on("finish", function() {
      this.client = null;
    });
    return this.client.on('error', function(err) {});
  };

  Client.prototype.disconnect = function(cb) {
    if (this.client) {
      this.client.end();
    }
    if (cb) {
      return cb();
    }
  };

  Client.prototype.pause = function(cb) {
    if (this.client && !this.paused) {
      this.client.pause();
      this.paused = true;
    }
    if (cb) {
      return cb();
    }
  };

  Client.prototype.resume = function(cb) {
    if (this.client && this.paused) {
      this.client.resume();
      this.paused = false;
    }
    if (cb) {
      return cb();
    }
  };

  Client.prototype.read = function(message, option, cb) {
    var code, command, speed, tone, voice, volume;
    if (this.client && message) {
      speed = (option != null ? option.speed : void 0) ? parseInt(option.speed, 16) : null;
      tone = (option != null ? option.tone : void 0) ? parseInt(option.tone, 16) : null;
      volume = (option != null ? option.volume : void 0) ? parseInt(option.volume, 16) : null;
      voice = (option != null ? option.voice : void 0) ? parseInt(option.voice, 16) : null;
      code = (option != null ? option.code : void 0) ? parseInt(option.code, 16) : null;
      command = _createCommand.call(this, message, speed, tone, volume, voice, code);
      return this.client.write(command, cb);
    }
  };


  /*
   *# command: 0...read it(defined only 0)
   *# speed: speed for read(50..300 or -1)
   *# tone: tone for read(50..200 or -1)
   *# volume: volume for read(0..100 or -1)
   *# voice: voice type(0..8 or -1 or 10001...)
   *# code: message's Character Code(0:Utf8, 1:Unicode, 2:Shift-JIS)
   */

  _createCommand = function(message, command, speed, tone, volume, voice, code) {
    var buffer, messageBuffer;
    if (command == null) {
      command = 0x0001;
    }
    if (speed == null) {
      speed = 0xFFFF;
    }
    if (tone == null) {
      tone = 0xFFFF;
    }
    if (volume == null) {
      volume = 0xFFFF;
    }
    if (voice == null) {
      voice = 0x0000;
    }
    if (code == null) {
      code = 0x0;
    }
    messageBuffer = new Buffer(message);
    buffer = new Buffer(15 + messageBuffer.length);
    buffer.writeUInt16LE(command, 0);
    buffer.writeUInt16LE(speed, 2);
    buffer.writeUInt16LE(tone, 4);
    buffer.writeUInt16LE(volume, 6);
    buffer.writeUInt16LE(voice, 8);
    buffer.writeUInt8(code, 10);
    buffer.writeUInt32LE(messageBuffer.length, 11);
    messageBuffer.copy(buffer, 15, 0, messageBuffer.length);
    return buffer;
  };

  return Client;

})();

module.exports = Client;
