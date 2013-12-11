# bootstrap logger
Logger = require '../lib/logger'
log = new Logger

module.exports = (options) ->
  if !options.rclient
    throw new Error '/config/test-redis expected options.rclient'
    return

  rclient = options.rclient

  debug = (type) ->
    return () ->
      log.debug 'test-redis:' + type, arguments

  rclient.on 'connect', debug 'connect'
  rclient.on 'ready', debug 'ready'
  rclient.on 'reconnecting', debug 'reconnecting'
  rclient.on 'error', debug 'error'
  rclient.on 'end', debug 'end'
