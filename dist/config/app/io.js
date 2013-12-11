module.exports = function(server) {
  var Logger, connect, cookie, io, log, parse, redisCONFIG, socketRedisStore;
  Logger = require('../../lib/logger');
  log = new Logger;
  redisCONFIG = require('../../config/app/redis');
  socketRedisStore = require('socket.io/lib/stores/redis');
  connect = require('express/node_modules/connect');
  cookie = require('cookie');
  parse = connect.utils.parseSignedCookie;
  io = require('socket.io').listen(server);
  /*
  io.configure () ->
    io.enable 'browser client minification' # send minified client
    io.enable 'browser client etag' # apply etag caching l
    io.enable 'browser client gzip' # gzip the file
    io.set 'log level', 1 # reduce logging
  
    io.set 'store', new socketRedisStore
      redis: redisCONFIG.redis
      pub: redisCONFIG.createClient()
      sub: redisCONFIG.createClient()
      client: redisCONFIG.createClient()
  
    io.set 'logger',
      debug: log.debug
      info: log.info
      error: log.error
      warn: log.warn
  
    io.set 'authorization', (handshakeData, accept) ->
      hs = handshakeData
  
      if hs.headers.cookie?
        hs.cookie = cookie.parse hs.headers.cookie
        hs.sessionID = parse hs.cookie['connect.sid'], redisCONFIG.secret
  
        redisCONFIG.sessionStore.get hs.sessionID, (err, session) ->
          if err or !session?
            log.warn 'No cookie submitted on connection.'
            accept 'No cookie submitted on connection.', false
          else
            log.debug 'Authorized session found.'
            accept null, true # forward valid connection.
      else
        log.debug 'Error. No cookie transmitted.'
        return accept 'No cookie transmitted.', false
  */

  return io;
};
