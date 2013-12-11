var Logger, config, log, mongoose;

Logger = require('../../lib/logger');

log = new Logger;

if (process.env.NODE_ENV && process.env.NODE_ENV === 'production') {
  config = require('../../config/env/mongo-production');
  log.debug('Connecting to mongo (production).');
} else {
  config = require('../../config/env/mongo-development');
  log.debug('Connecting to mongo (development).');
}

mongoose = require('mongoose');

module.exports = {
  mongoose: mongoose,
  connect: function() {
    return mongoose.createConnection(config.url);
  }
};
