argv = require('optimist').argv

# set environment
if argv.environment? && argv.environment is 'production'
  process.env.NODE_ENV = 'production'
else
  process.env.NODE_ENV = 'development'

# bootstrap logger
Logger = require './lib/logger'
log = new Logger

# init express + app
express = require 'express'
app = express()

require('./config/app/express') app

# bootstrap routes
require('./config/app/routes') app

# route all uncaught requests to index
app.get '*', (req, res) ->
  res.sendfile __dirname + '/public/index.html'

###
server = require('http').createServer app
# bootstrap socket.io
io = require('./config/app/io') server
require('./app/controllers/socket') io
###

appCONFIG = require './config/env/app'
port = process.env.PORT || appCONFIG.port || 3000
#server.listen port
app.listen port

log.debug appCONFIG.name + ' listening on port ' + port + ' (' +
  process.env.NODE_ENV + ').'
