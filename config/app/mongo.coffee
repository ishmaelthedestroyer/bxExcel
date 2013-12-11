Logger = require '../../lib/logger'
log = new Logger

if process.env.NODE_ENV && process.env.NODE_ENV is 'production'
  config = require '../../config/env/mongo-production'
  log.debug 'Connecting to mongo (production).'
else
  config = require '../../config/env/mongo-development'
  log.debug 'Connecting to mongo (development).'

mongoose = require 'mongoose'
module.exports = # return methods
  mongoose: mongoose
  connect: () ->
    return mongoose.createConnection config.url
