EventEmitter = require('events').EventEmitter
$q = require 'q'
redisCONFIG = require '../../config/app/redis'
util = require '../../lib/util'

Logger = require '../../lib/logger'
log = new Logger

S3 = require '../../app/controllers/s3'
s3 = new S3

ss = require 'socket.io-stream'

Server = (io) ->
  if !(@ instanceof Server)
    return new Server io

  EventEmitter.call @

  @io = io || null
  @init()

  util.extend @, log
  util.inherits @, EventEmitter

  return @

Server::init = () ->
  @io.sockets.on 'connection', (socket) =>
    hs = socket.handshake
    @debug 'Socket connected to server.'
    @notify socket.id, 'server:handshake',
      'Successfully connected to the server.'

    ###
    socket.on 'dir:create', (data) =>

    socket.on 'dir:delete', (data) =>

    socket.on 'dir:list', (data) =>
      s3.listDir()
      .then (data) =>
        @debug 'Got directories.'
        @notify socket.id, 'dir:list', data.Buckets || []
      .fail (err) =>
        # TODO: notify client
    ###

    # socket.on 'dir:cwd', (data) =>

    socket.on 'file:list', (data) =>

    socket.on 'file:download', (data) =>
      stream = ss.createStream()

      # @notify socket.id, 'file:download', stream # , data
      @notify socket.id, 'file:download', stream, data

      s3.download stream, data


      ###
      s3.download data, (progress) =>
        # callback to notify progress
        @notify socket.id, 'file:download', progress
      ###

    ss(socket).on 'file:upload', (stream, meta) =>
      s3.upload stream, meta, (progress) =>
        # callback to notify progress
        @notify socket.id, 'file:upload', progress

    socket.on 'file:delete', (data) =>

Server::notify = (id, e, data) ->
  @debug 'Notifying socket.',
    id: id
    e: e
    # data: data

  @io.sockets.socket(id).emit e, data

Server::toArrayBuffer = (buffer) ->
  ab = new ArrayBuffer buffer.length
  view = new Uint8Array ab
  i = 0
  while i < buffer.length
    view[i] = buffer[i]
    ++i
  return view

Server::close = (socket) ->
  # TODO: ...

module.exports = (io) ->
  return Server io
