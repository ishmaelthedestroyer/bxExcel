var Logger, RedisStore, config, createClient, express, log, rclient, redis, redisURL, url;

Logger = require('../../lib/logger');

log = new Logger;

redis = require('redis');

express = require('express');

RedisStore = require('connect-redis')(express);

if (process.env.NODE_ENV && process.env.NODE_ENV === 'production') {
  log.debug('Connecting to redis (production).');
  config = require('../env/redis-production');
  url = 'redis://rediscloud:' + config.pass + '@' + config.url;
  redisURL = require('url').parse(url);
  createClient = function() {
    var client;
    log.debug('Creating Redis (production) client.');
    client = redis.createClient(redisURL.port, redisURL.hostname, {
      no_ready_check: true
    });
    client.auth(redisURL.auth.split(':')[1]);
    return client;
  };
} else {
  log.debug('Connecting to redis (development).');
  config = require('../env/redis-development');
  createClient = function() {
    log.debug('Creating Redis (development) client.');
    return redis.createClient();
  };
}

rclient = createClient();

require('../../lib/test-redis')({
  rclient: rclient
});

rclient.flushdb();

module.exports = {
  redis: redis,
  secret: config.secret,
  createClient: createClient,
  sessionStore: new RedisStore({
    ttl: 60 * 60,
    client: rclient
  }),
  cookie: {
    maxAge: 60 * 60 * 1000
  }
};
