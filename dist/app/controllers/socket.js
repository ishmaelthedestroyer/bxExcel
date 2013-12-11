var $q, EventEmitter, Logger, S3, Server, log, redisCONFIG, s3, ss, util;

EventEmitter = require('events').EventEmitter;

$q = require('q');

redisCONFIG = require('../../config/app/redis');

util = require('../../lib/util');

Logger = require('../../lib/logger');

log = new Logger;

S3 = require('../../app/controllers/s3');

s3 = new S3;

ss = require('socket.io-stream');

Server = function(io) {
  if (!(this instanceof Server)) {
    return new Server(io);
  }
  EventEmitter.call(this);
  this.io = io || null;
  this.init();
  util.extend(this, log);
  util.inherits(this, EventEmitter);
  return this;
};

Server.prototype.init = function() {
  var _this = this;
  return this.io.sockets.on('connection', function(socket) {
    var hs;
    hs = socket.handshake;
    _this.debug('Socket connected to server.');
    _this.notify(socket.id, 'server:handshake', 'Successfully connected to the server.');
    /*
    socket.on 'dir:create', (data) =>
    
    socket.on 'dir:delete', (data) =>
    
    socket.on 'dir:list', (data) =>
      s3.listDir()
      .then (data) =>
        @debug 'Got directories.'
        @notify socket.id, 'dir:list', data.Buckets || []
      .fail (err) =>
        # TODO: notify client
    */

    socket.on('file:list', function(data) {});
    socket.on('file:download', function(data) {
      var stream;
      stream = ss.createStream();
      _this.notify(socket.id, 'file:download', stream, data);
      return s3.download(stream, data);
      /*
      s3.download data, (progress) =>
        # callback to notify progress
        @notify socket.id, 'file:download', progress
      */

    });
    ss(socket).on('file:upload', function(stream, meta) {
      return s3.upload(stream, meta, function(progress) {
        return _this.notify(socket.id, 'file:upload', progress);
      });
    });
    return socket.on('file:delete', function(data) {});
  });
};

Server.prototype.notify = function(id, e, data) {
  this.debug('Notifying socket.', {
    id: id,
    e: e
  });
  return this.io.sockets.socket(id).emit(e, data);
};

Server.prototype.toArrayBuffer = function(buffer) {
  var ab, i, view;
  ab = new ArrayBuffer(buffer.length);
  view = new Uint8Array(ab);
  i = 0;
  while (i < buffer.length) {
    view[i] = buffer[i];
    ++i;
  }
  return view;
};

Server.prototype.close = function(socket) {};

module.exports = function(io) {
  return Server(io);
};
