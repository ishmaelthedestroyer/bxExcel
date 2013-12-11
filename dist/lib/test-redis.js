var Logger, log;

Logger = require('../lib/logger');

log = new Logger;

module.exports = function(options) {
  var debug, rclient;
  if (!options.rclient) {
    throw new Error('/config/test-redis expected options.rclient');
    return;
  }
  rclient = options.rclient;
  debug = function(type) {
    return function() {
      return log.debug('test-redis:' + type, arguments);
    };
  };
  rclient.on('connect', debug('connect'));
  rclient.on('ready', debug('ready'));
  rclient.on('reconnecting', debug('reconnecting'));
  rclient.on('error', debug('error'));
  return rclient.on('end', debug('end'));
};
